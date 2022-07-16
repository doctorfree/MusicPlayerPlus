# -*- coding: utf-8 -*-
"""beets-extrafiles plugin for beets."""
import glob
import itertools
import os
import shutil
import sys
import traceback

import mediafile
import beets.dbcore.db
import beets.library
import beets.plugins
import beets.ui
import beets.util.functemplate


def commonpath(paths):
    """Find longest common sub-path of each path in the sequence paths."""
    # Typecast to list needed for Python version < 3.6
    paths = list(paths)
    if sys.version_info >= (3, 5):
        return os.path.commonpath(paths)
    else:
        # os.path.commonpath does not exist in Python < 3.5
        prefix = os.path.commonprefix(paths)

        sep = os.sep.encode() if isinstance(prefix, bytes) else os.sep
        prefix_split = prefix.split(sep)
        path_split = paths[0].split(sep)
        if path_split[:len(prefix_split)] != prefix_split:
            prefix = os.path.dirname(prefix)

        return prefix


class FormattedExtraFileMapping(beets.dbcore.db.FormattedMapping):
    """Formatted Mapping that allows path separators for certain keys."""

    def __getitem__(self, key):
        """Get the formatted version of model[key] as string."""
        if key == 'albumpath':
            value = self.model._type(key).format(self.model.get(key))
            if isinstance(value, bytes):
                value = value.decode('utf-8', 'ignore')
            return value
        else:
            return super(FormattedExtraFileMapping, self).__getitem__(key)


class ExtraFileModel(beets.dbcore.db.Model):
    """Model for a  FormattedExtraFileMapping instance."""

    _fields = {
        'artist':      beets.dbcore.types.STRING,
        'albumartist': beets.dbcore.types.STRING,
        'album':       beets.dbcore.types.STRING,
        'albumpath':   beets.dbcore.types.STRING,
        'filename':    beets.dbcore.types.STRING,
    }

    @classmethod
    def _getters(cls):
        """Return a mapping from field names to getter functions."""
        return {}


class ExtraFilesPlugin(beets.plugins.BeetsPlugin):
    """Plugin main class."""

    def __init__(self, *args, **kwargs):
        """Initialize a new plugin instance."""
        super(ExtraFilesPlugin, self).__init__(*args, **kwargs)
        self.config.add({
            'patterns': {},
            'paths': {},
        })

        self._moved_items = set()
        self._copied_items = set()
        self._scanned_paths = set()
        self.path_formats = beets.ui.get_path_formats(self.config['paths'])

        self.register_listener('item_moved', self.on_item_moved)
        self.register_listener('item_copied', self.on_item_copied)
        self.register_listener('cli_exit', self.on_cli_exit)

    def on_item_moved(self, item, source, destination):
        """Run this listener function on item_moved events."""
        self._moved_items.add((item, source, destination))

    def on_item_copied(self, item, source, destination):
        """Run this listener function on item_copied events."""
        self._copied_items.add((item, source, destination))

    def on_cli_exit(self, lib):
        """Run this listener function when the CLI exits."""
        files = self.gather_files(self._copied_items)
        self.process_items(files, action=self._copy_file)

        files = self.gather_files(self._moved_items)
        self.process_items(files, action=self._move_file)

    def _copy_file(self, path, dest):
        """Copy path to dest."""
        self._log.info('Copying extra file: {0} -> {1}', path, dest)
        if os.path.isdir(path):
            if os.path.exists(dest):
                raise beets.util.FilesystemError(
                    'file exists', 'copy',
                    (path, dest),
                )

            sourcepath = beets.util.displayable_path(path)
            destpath = beets.util.displayable_path(dest)
            try:
                shutil.copytree(sourcepath, destpath)
            except (OSError, IOError) as exc:
                raise beets.util.FilesystemError(
                    exc, 'copy', (path, dest),
                    traceback.format_exc(),
                )
        else:
            beets.util.copy(path, dest)

    def _move_file(self, path, dest):
        """Move path to dest."""
        self._log.info('Moving extra file: {0} -> {1}', path, dest)
        sourcepath = beets.util.displayable_path(path)
        destpath = beets.util.displayable_path(dest)
        shutil.move(sourcepath, destpath)

    def process_items(self, files, action):
        """Move path to dest."""
        for source, destination in files:
            if not os.path.exists(source):
                self._log.warning('Skipping missing source file: {0}', source)
                continue

            if os.path.exists(destination):
                self._log.warning(
                    'Skipping already present destination file: {0}',
                    destination,
                )
                continue

            sourcepath = beets.util.bytestring_path(source)
            destpath = beets.util.bytestring_path(destination)
            destpath = beets.util.unique_path(destpath)
            beets.util.mkdirall(destpath)

            try:
                action(sourcepath, destpath)
            except beets.util.FilesystemError:
                self._log.warning(
                    'Failed to process file: {} -> {}', source, destpath,
                )

    def gather_files(self, itemops):
        """Generate a sequence of (path, destpath) tuples."""
        def group(itemop):
            item = itemop[0]
            return (item.albumartist or item.artist, item.album)

        sorted_itemops = sorted(itemops, key=group)
        for _, itemopgroup in itertools.groupby(sorted_itemops, key=group):
            items, sources, destinations = zip(*itemopgroup)
            item = items[0]

            sourcedirs = set(os.path.dirname(f) for f in sources)
            destdirs = set(os.path.dirname(f) for f in destinations)

            source = commonpath(sourcedirs)
            destination = commonpath(destdirs)
            self._log.debug(
                '{0} -> {1} ({2.album} by {2.albumartist}, {3} tracks)',
                source, destination, item, len(items),
            )

            meta = {
                'artist': item.artist or u'None',
                'albumartist': item.albumartist or u'None',
                'album': item.album or u'None',
                'albumpath': beets.util.displayable_path(destination),
            }

            for path, category in self.match_patterns(
                    source, skip=self._scanned_paths,
            ):
                path = beets.util.bytestring_path(path)
                relpath = os.path.normpath(os.path.relpath(path, start=source))
                destpath = self.get_destination(relpath, category, meta.copy())
                yield path, destpath

    def match_patterns(self, source, skip=set()):
        """Find all files matched by the patterns."""
        source_path = beets.util.displayable_path(source)

        if source_path in skip:
            return

        for category, patterns in self.config['patterns'].get(dict).items():
            for pattern in patterns:
                globpath = os.path.join(glob.escape(source_path), pattern)
                for path in glob.iglob(globpath):
                    # Skip special dot directories (just in case)
                    if os.path.basename(path) in ('.', '..'):
                        continue

                    # Skip files handled by the beets media importer
                    ext = os.path.splitext(path)[1]
                    if len(ext) > 1 and ext[1:] in mediafile.TYPES.keys():
                        continue

                    yield (path, category)

        skip.add(source_path)

    def get_destination(self, path, category, meta):
        """Get the destination path for a source file's relative path."""
        pathsep = beets.config['path_sep_replace'].get(str)
        strpath = beets.util.displayable_path(path)
        old_basename, fileext = os.path.splitext(os.path.basename(strpath))
        old_filename, _ = os.path.splitext(pathsep.join(strpath.split(os.sep)))

        mapping = FormattedExtraFileMapping(
            ExtraFileModel(
                basename=old_basename,
                filename=old_filename,
                **meta
            ), for_path=True,
        )

        for query, path_format in self.path_formats:
            if query == category:
                break
        else:
            # No query matched; use original filename
            path_format = beets.util.functemplate.Template(
                '$albumpath/$filename',
            )

        # Get template funcs and evaluate against mapping
        funcs = beets.library.DefaultTemplateFunctions().functions()
        filepath = path_format.substitute(mapping, funcs) + fileext

        # Sanitize filename
        filename = beets.util.sanitize_path(os.path.basename(filepath))
        dirname = os.path.dirname(filepath)
        filepath = os.path.join(dirname, filename)

        return filepath
