# -*- coding: utf-8 -*-
"""Tests for the beets-extrafiles plugin."""
import logging
import os
import shutil
import tempfile
import unittest.mock

import beets.util.confit

import beetsplug.extrafiles

RSRC = os.path.join(os.path.dirname(__file__), 'rsrc')

log = logging.getLogger('beets')
log.propagate = True
log.setLevel(logging.DEBUG)


class BaseTestCase(unittest.TestCase):
    """Base testcase class that sets up example files."""

    PLUGIN_CONFIG = {
        'extrafiles': {
            'patterns': {
                'log': ['*.log'],
                'cue': ['*.cue', '*/*.cue'],
                'artwork': ['scans/', 'Scans/', 'artwork/', 'Artwork/'],
            },
            'paths': {
                'artwork': '$albumpath/artwork',
                'log': '$albumpath/audio',
            },
        },
    }

    def _create_example_file(self, *path):
        open(os.path.join(*path), mode='w').close()

    def _create_artwork_files(self, *path):
        artwork_path = os.path.join(*path)
        os.mkdir(artwork_path)
        for filename in ('front.jpg', 'back.jpg'):
            self._create_example_file(artwork_path, filename)

    def setUp(self):
        """Set up example files and instanciate the plugin."""
        self.srcdir = tempfile.TemporaryDirectory(suffix='src')
        self.dstdir = tempfile.TemporaryDirectory(suffix='dst')

        # Create example files for single directory album
        os.makedirs(os.path.join(self.dstdir.name, 'single'))
        sourcedir = os.path.join(self.srcdir.name, 'single')
        os.makedirs(sourcedir)
        shutil.copy(
            os.path.join(RSRC, 'full.mp3'),
            os.path.join(sourcedir, 'file.mp3'),
        )
        for filename in ('file.cue', 'file.txt', 'file.log'):
            self._create_example_file(sourcedir, filename)
        self._create_artwork_files(sourcedir, 'scans')

        # Create example files for multi-directory album
        os.makedirs(os.path.join(self.dstdir.name, 'multiple'))
        sourcedir = os.path.join(self.srcdir.name, 'multiple')
        os.makedirs(os.path.join(sourcedir, 'CD1'))
        shutil.copy(
            os.path.join(RSRC, 'full.mp3'),
            os.path.join(sourcedir, 'CD1', 'file.mp3'),
        )
        os.makedirs(os.path.join(sourcedir, 'CD2'))
        shutil.copy(
            os.path.join(RSRC, 'full.mp3'),
            os.path.join(sourcedir, 'CD2', 'file.mp3'),
        )
        for filename in ('file.txt', 'file.log'):
            self._create_example_file(sourcedir, filename)
        for discdir in ('CD1', 'CD2'):
            self._create_example_file(sourcedir, discdir, 'file.cue')
        self._create_artwork_files(sourcedir, 'scans')

        # Set up plugin instance
        config = beets.util.confit.RootView(sources=[
            beets.util.confit.ConfigSource.of(self.PLUGIN_CONFIG),
        ])

        with unittest.mock.patch(
                'beetsplug.extrafiles.beets.plugins.beets.config', config,
        ):
            self.plugin = beetsplug.extrafiles.ExtraFilesPlugin('extrafiles')

    def tearDown(self):
        """Remove the example files."""
        self.srcdir.cleanup()
        self.dstdir.cleanup()


class MatchPatternsTestCase(BaseTestCase):
    """Testcase that checks if all extra files are matched."""

    def testMatchPattern(self):
        """Test if extra files are matched in the media file's directory."""
        sourcedir = os.path.join(self.srcdir.name, 'single')
        files = set(
            (beets.util.displayable_path(path), category)
            for path, category in self.plugin.match_patterns(source=sourcedir)
        )

        expected_files = set([
            (os.path.join(sourcedir, 'scans/'), 'artwork'),
            (os.path.join(sourcedir, 'file.cue'), 'cue'),
            (os.path.join(sourcedir, 'file.log'), 'log'),
        ])

        assert files == expected_files


class MoveFilesTestCase(BaseTestCase):
    """Testcase that moves files."""

    def testMoveFilesSingle(self):
        """Test if extra files are moved for single directory imports."""
        sourcedir = os.path.join(self.srcdir.name, 'single')
        destdir = os.path.join(self.dstdir.name, 'single')

        # Move file
        source = os.path.join(sourcedir, 'file.mp3')
        destination = os.path.join(destdir, 'moved_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.move(source, destination)
        self.plugin.on_item_moved(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        self.plugin.on_cli_exit(None)

        # Check source directory
        assert os.path.exists(os.path.join(sourcedir, 'file.txt'))
        assert not os.path.exists(os.path.join(sourcedir, 'file.cue'))
        assert not os.path.exists(os.path.join(sourcedir, 'file.log'))
        assert not os.path.exists(os.path.join(sourcedir, 'audio.log'))

        assert not os.path.exists(os.path.join(sourcedir, 'artwork'))
        assert not os.path.exists(os.path.join(sourcedir, 'scans'))

        # Check destination directory
        assert not os.path.exists(os.path.join(destdir, 'file.txt'))
        assert os.path.exists(os.path.join(destdir, 'file.cue'))
        assert not os.path.exists(os.path.join(destdir, 'file.log'))
        assert os.path.exists(os.path.join(destdir, 'audio.log'))

        assert not os.path.isdir(os.path.join(destdir, 'scans'))
        assert os.path.isdir(os.path.join(destdir, 'artwork'))
        assert (set(os.listdir(os.path.join(destdir, 'artwork'))) ==
                set(('front.jpg', 'back.jpg')))

    def testMoveFilesMultiple(self):
        """Test if extra files are moved for multi-directory imports."""
        sourcedir = os.path.join(self.srcdir.name, 'multiple')
        destdir = os.path.join(self.dstdir.name, 'multiple')

        # Move first file
        source = os.path.join(sourcedir, 'CD1', 'file.mp3')
        destination = os.path.join(destdir, '01 - moved_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.move(source, destination)
        self.plugin.on_item_moved(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        # Move second file
        source = os.path.join(sourcedir, 'CD2', 'file.mp3')
        destination = os.path.join(destdir, '02 - moved_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.move(source, destination)
        self.plugin.on_item_moved(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        self.plugin.on_cli_exit(None)

        # Check source directory
        assert os.path.exists(os.path.join(sourcedir, 'file.txt'))
        assert not os.path.exists(os.path.join(sourcedir, 'CD1', 'file.cue'))
        assert not os.path.exists(os.path.join(sourcedir, 'CD2', 'file.cue'))
        assert not os.path.exists(os.path.join(sourcedir, 'file.log'))
        assert not os.path.exists(os.path.join(sourcedir, 'audio.log'))

        assert not os.path.exists(os.path.join(sourcedir, 'artwork'))
        assert not os.path.exists(os.path.join(sourcedir, 'scans'))

        # Check destination directory
        assert not os.path.exists(os.path.join(destdir, 'file.txt'))
        assert not os.path.exists(os.path.join(sourcedir, 'CD1_file.cue'))
        assert not os.path.exists(os.path.join(sourcedir, 'CD2_file.cue'))
        assert not os.path.exists(os.path.join(destdir, 'file.log'))
        assert os.path.exists(os.path.join(destdir, 'audio.log'))

        assert not os.path.isdir(os.path.join(destdir, 'scans'))
        assert os.path.isdir(os.path.join(destdir, 'artwork'))
        assert (set(os.listdir(os.path.join(destdir, 'artwork'))) ==
                set(('front.jpg', 'back.jpg')))


class CopyFilesTestCase(BaseTestCase):
    """Testcase that copies files."""

    def testCopyFilesSingle(self):
        """Test if extra files are copied for single directory imports."""
        sourcedir = os.path.join(self.srcdir.name, 'single')
        destdir = os.path.join(self.dstdir.name, 'single')

        # Copy file
        source = os.path.join(sourcedir, 'file.mp3')
        destination = os.path.join(destdir, 'copied_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.copy(source, destination)
        self.plugin.on_item_copied(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        self.plugin.on_cli_exit(None)

        # Check source directory
        assert os.path.exists(os.path.join(sourcedir, 'file.txt'))
        assert os.path.exists(os.path.join(sourcedir, 'file.cue'))
        assert os.path.exists(os.path.join(sourcedir, 'file.log'))
        assert not os.path.exists(os.path.join(sourcedir, 'audio.log'))

        assert not os.path.exists(os.path.join(sourcedir, 'artwork'))
        assert os.path.isdir(os.path.join(sourcedir, 'scans'))
        assert (set(os.listdir(os.path.join(sourcedir, 'scans'))) ==
                set(('front.jpg', 'back.jpg')))

        # Check destination directory
        assert not os.path.exists(os.path.join(destdir, 'file.txt'))
        assert os.path.exists(os.path.join(destdir, 'file.cue'))
        assert not os.path.exists(os.path.join(destdir, 'file.log'))
        assert os.path.exists(os.path.join(destdir, 'audio.log'))

        assert not os.path.exists(os.path.join(destdir, 'scans'))
        assert os.path.isdir(os.path.join(destdir, 'artwork'))
        assert (set(os.listdir(os.path.join(destdir, 'artwork'))) ==
                set(('front.jpg', 'back.jpg')))

    def testCopyFilesMultiple(self):
        """Test if extra files are copied for multi-directory imports."""
        sourcedir = os.path.join(self.srcdir.name, 'multiple')
        destdir = os.path.join(self.dstdir.name, 'multiple')

        # Copy first file
        source = os.path.join(sourcedir, 'CD1', 'file.mp3')
        destination = os.path.join(destdir, '01 - copied_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.copy(source, destination)
        self.plugin.on_item_copied(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        # Copy second file
        source = os.path.join(sourcedir, 'CD2', 'file.mp3')
        destination = os.path.join(destdir, '02 - copied_file.mp3')
        item = beets.library.Item.from_path(source)
        shutil.copy(source, destination)
        self.plugin.on_item_copied(
            item, beets.util.bytestring_path(source),
            beets.util.bytestring_path(destination),
        )

        self.plugin.on_cli_exit(None)

        # Check source directory
        assert os.path.exists(os.path.join(sourcedir, 'file.txt'))
        assert os.path.exists(os.path.join(sourcedir, 'CD1', 'file.cue'))
        assert os.path.exists(os.path.join(sourcedir, 'CD2', 'file.cue'))
        assert os.path.exists(os.path.join(sourcedir, 'file.log'))
        assert not os.path.exists(os.path.join(sourcedir, 'audio.log'))

        assert not os.path.exists(os.path.join(sourcedir, 'artwork'))
        assert os.path.isdir(os.path.join(sourcedir, 'scans'))
        assert (set(os.listdir(os.path.join(sourcedir, 'scans'))) ==
                set(('front.jpg', 'back.jpg')))

        # Check destination directory
        assert not os.path.exists(os.path.join(destdir, 'file.txt'))
        assert os.path.exists(os.path.join(destdir, 'CD1_file.cue'))
        assert os.path.exists(os.path.join(destdir, 'CD2_file.cue'))
        assert not os.path.exists(os.path.join(destdir, 'file.log'))
        assert os.path.exists(os.path.join(destdir, 'audio.log'))

        assert not os.path.exists(os.path.join(destdir, 'scans'))
        assert os.path.isdir(os.path.join(destdir, 'artwork'))
        assert (set(os.listdir(os.path.join(destdir, 'artwork'))) ==
                set(('front.jpg', 'back.jpg')))


class MultiAlbumTestCase(unittest.TestCase):
    """Testcase class that checks if multiple albums are grouped correctly."""

    PLUGIN_CONFIG = {
        'extrafiles': {
            'patterns': {
                'log': ['*.log'],
            },
        },
    }

    def setUp(self):
        """Set up example files and instanciate the plugin."""
        self.srcdir = tempfile.TemporaryDirectory(suffix='src')
        self.dstdir = tempfile.TemporaryDirectory(suffix='dst')

        for album in ('album1', 'album2'):
            os.makedirs(os.path.join(self.dstdir.name, album))
            sourcedir = os.path.join(self.srcdir.name, album)
            os.makedirs(sourcedir)
            shutil.copy(
                os.path.join(RSRC, 'full.mp3'),
                os.path.join(sourcedir, 'track01.mp3'),
            )
            shutil.copy(
                os.path.join(RSRC, 'full.mp3'),
                os.path.join(sourcedir, 'track02.mp3'),
            )
            logfile = os.path.join(sourcedir, '{}.log'.format(album))
            open(logfile, mode='w').close()

        # Set up plugin instance
        config = beets.util.confit.RootView(sources=[
            beets.util.confit.ConfigSource.of(self.PLUGIN_CONFIG),
        ])

        with unittest.mock.patch(
                'beetsplug.extrafiles.beets.plugins.beets.config', config,
        ):
            self.plugin = beetsplug.extrafiles.ExtraFilesPlugin('extrafiles')

    def tearDown(self):
        """Remove the example files."""
        self.srcdir.cleanup()
        self.dstdir.cleanup()

    def testAlbumGrouping(self):
        """Test if albums are."""
        for album in ('album1', 'album2'):
            sourcedir = os.path.join(self.srcdir.name, album)
            destdir = os.path.join(self.dstdir.name, album)

            for i in range(1, 3):
                source = os.path.join(sourcedir, 'track{0:02d}.mp3'.format(i))
                destination = os.path.join(
                    destdir, '{0:02d} - {1} - untitled.mp3'.format(i, album),
                )
                item = beets.library.Item.from_path(source)
                item.album = album
                item.track = i
                item.tracktotal = 2
                shutil.copy(source, destination)
                self.plugin.on_item_copied(
                    item, beets.util.bytestring_path(source),
                    beets.util.bytestring_path(destination),
                )

        self.plugin.on_cli_exit(None)

        for album in ('album1', 'album2'):
            destdir = os.path.join(self.dstdir.name, album)
            for i in range(1, 3):
                destination = os.path.join(
                    destdir, '{0:02d} - {1} - untitled.mp3'.format(i, album),
                )
                assert os.path.exists(destination)
            assert os.path.exists(os.path.join(
                self.dstdir.name, album, '{}.log'.format(album),
            ))
