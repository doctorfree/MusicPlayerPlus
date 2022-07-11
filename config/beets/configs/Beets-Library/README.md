# Beets-Library

My personal beets configuration and scripts

## Terminology

In my library and configuration, a `sole track` is a case where I only have a single track by that artist in my library. I like to separate these to allow tracks where I have other works by that artist to be placed in the same location as the other tracks and albums by that artist, rather than in my `single tracks` folder.
A `single track` is a case where I only have one track from that album.

## Flexible Fields

My library utilizes various flexible fields.

The `loved` field is used at both item and track level to bring those items up to the top-level in my media player path formats for easier navigation to the songs and albums I listen to most often. I may rename this field in the future.

- `disliked`: Music I actively dislike but don't yet want to remove from the library.
- `loved`: This field is used at both album and track level to hoist those items up to the root level in my media player path formats for easier navigation to items I play often.
- `to_listen`: Music I'd like to listen to.
- `avmedia`: Media type. Current expected values: Video Games, TV, Movies, Performances, Musicals, Anime, Documentaries.
- `mediatitle`: The name of the media this music is about. This may be for a soundtrack, but could also be for albums inspired by that game.
- `mediatitledisambig`: This string disambiguates cases where multiple albums reference the same media. In-game, score, orchestral, inspired by, etc.
- `franchise`: The media franchise this music references.

## Reference

### Commands

- `beet lastgenre` to set genres on music from last.fm. This requires manual review, and may well require further tweaking of genre-whitelist.txt and genres-tree.yaml. Better yet, I intend to drop it in favor of whatlastgenre, but it'll do for now.
- `beet wlg` to set genre from discogs, etc. This still requires review.
- `beet mbsync` will update from musicbrainz, but often requires manual review to correct bits that were fixed at import time. I should fix `modifyonimport` to also apply on `mbsync`.

### Query Prefixes

#### Fields

- `=` is for a case-sensitive exact match
- `~` is for a case-insensitive exact match
- `:` is for a regular expression match
- `#` is for a bare ASCII match
- `*` is for a fuzzy match
- `%` is for a set/non-NULL match
- `^` is for an unset/NULL match

#### Global

- `<` is limit to N entries. I.e. `<10` gives you ten entries

### Other

- [Rehoming an existing database?](https://github.com/beetbox/beets/issues/1598) Shows how to change the library paths hardcoded in the library db after the fact:
  ```sql
  UPDATE items
  SET "path" = CAST(REPLACE(CAST("path" AS TEXT), '/Volumes/SD/Music Library/Library/', '/Volumes/Data/Music Library/Library/') AS BLOB);

  UPDATE albums
  SET "artpath" = CAST(REPLACE(CAST("artpath" AS TEXT), '/Volumes/SD/Music Library/Library/', '/Volumes/Data/Music Library/Library/') AS BLOB);
  ```
