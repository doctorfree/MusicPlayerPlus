"""Identify tracks which are the only ones we have by that artist.

The intention here is to move one-hit-wonders or random free tracks I've
acquired over the years out of the artist/album structure, as seeing thousands
of "albums" with one track each is not useful.
"""

import collections
import re
from beets import library, plugins, ui
from beets.dbcore import types


class SoleTracks(plugins.BeetsPlugin):
    item_types = {
        "sole_track": types.BOOLEAN,
    }

    def __init__(self, name=None):
        super().__init__(name=name)

        self.config.add(
            {
                "artist_fields": "artist artist_credit artists",
                "check_fields": "artist artist_credit artists albumartist albumartist_credit",
                "check_query": "^comp:1",
                "check_single_track": True,
                "sections": "",
            }
        )

        self.feat_tokens = re.compile(
            plugins.feat_tokens(for_artist=True).replace("|and", "").replace("|\&", "")
        )
        self.artist_tokens = re.compile(r"(?<=\s)(?:and|\&|,)(?=\s)")
        self.asciify = library.DefaultTemplateFunctions.tmpl_asciify

    def commands(self):
        list_cmd = ui.Subcommand(
            "list-sole-tracks",
            help="Identify tracks which are the only ones we have by that artist.",
            aliases=(
                "ls-sole-tracks",
                "sole-tracks",
            ),
        )
        list_cmd.parser.add_option(
            "-n",
            "--non-matching",
            help="List non-matching rather than matching tracks.",
            action="store_true",
        )
        list_cmd.parser.add_path_option()
        list_cmd.parser.add_format_option()
        list_cmd.func = self.list_command

        modify_cmd = ui.Subcommand(
            "modify-sole-tracks",
            help='Modify "sole_track" flexible field on tracks based on whether they are the only tracks by that artist.',
        )
        modify_cmd.parser.add_option(
            "-p",
            "--pretend",
            action="store_true",
            help="show all changes but do nothing",
        )
        modify_cmd.func = self.modify_command
        return [list_cmd, modify_cmd]

    def list_command(self, lib, opts, args):
        self.handle_common_args(opts, args)

        for item, is_sole_track in self.list_sole_tracks(lib):
            if is_sole_track:
                ui.print_(format(item))
            elif opts.non_matching and not is_sole_track:
                ui.print_(format(item))

    def modify_command(self, lib, opts, args):
        self.handle_common_args(opts, args)

        sole_tracks = set(
            item.id
            for item, is_sole_track in self.list_sole_tracks(lib)
            if is_sole_track
        )
        for item in lib.items():
            sole_track = item.id in sole_tracks
            existing_sole_track = item.get("sole_track", False)
            if existing_sole_track != sole_track:
                if not sole_track:
                    del item["sole_track"]
                else:
                    item["sole_track"] = True

                ui.show_model_changes(item, fields=("sole_track",))
                if not opts.pretend:
                    item.store()

    def handle_common_args(self, opts, args):
        self.config.set_args(opts)
        query = ui.decargs(args)
        if query:
            self.config["query"] = query
            self._log.debug(f'Using base query {" ".join(query)}')
            base_query, _ = library.parse_query_parts(query, library.Item)
        else:
            query = self.config["query"].as_str()
            self._log.debug(f"Using base query {query}")
            base_query, _ = library.parse_query_string(query, library.Item)
        self.base_query = base_query

    def list_sole_tracks(self, lib):
        check_single_track = self.config["check_single_track"].get(True)
        artist_fields = self.config["artist_fields"].as_str_seq()
        check_fields = self.config["check_fields"].as_str_seq()
        sections = self.config["sections"].as_str_seq()

        base_check_query = self.config["check_query"].as_str()
        self._log.debug(f"Using check query {base_check_query}")
        base_check_query, _ = library.parse_query_string(base_check_query, library.Item)

        candidates_by_section = collections.defaultdict(set)
        checked_by_artist = collections.defaultdict(lambda: collections.defaultdict(set))

        self._log.debug("Gathering item artist information")
        for item in lib.items():
            base_match = self.base_query.match(item)
            check_match = base_check_query.match(item)
            if not base_match and not check_match:
                continue

            for section in sections:
                section_query, _ = library.parse_query_string(section, library.Item)
                if section_query.match(item):
                    if base_match:
                        candidates_by_section[section].add(item)
                    if check_match:
                        for artist in self.artists(item, check_fields):
                            checked_by_artist[section][artist].add(item)

        seen = set()
        for section in sections:
            self._log.info(f"Checking section: {section}")
            for item in candidates_by_section[section]:
                if item in seen:
                    continue
                seen.add(item)

                if check_single_track:
                    if item.album and item._cached_album:
                        if len(item._cached_album.items()) > 1:
                            # Not a single track
                            continue

                item_artists = self.artists(item, artist_fields)
                self._log.debug(f'Checking for artists ({", ".join(item_artists)})')
                for artist in item_artists:
                    other_items = [i for i in checked_by_artist[section][artist] if i != item]
                    if other_items:
                        yield item, False
                        break
                else:
                    yield item, True

    def artists(self, item, artist_fields):
        artists = set()
        for field in artist_fields:
            if field in item:
                value = item.get(field)
                if value:
                    artists.add(value.strip().lower())

                    value = self.feat_tokens.split(value, 1)[0]
                    artists.add(value.strip().lower())

                    split_artist = self.artist_tokens.split(value)[0]
                    if split_artist:
                        artists.add(split_artist)

        if artists:
            artists |= set(self.asciify(artist) for artist in artists)

        return artists
