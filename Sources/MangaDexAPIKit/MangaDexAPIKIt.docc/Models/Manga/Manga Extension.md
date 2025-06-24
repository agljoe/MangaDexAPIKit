# ``Manga``

## Topics

### Creating a Manga

- ``Manga/init(from:)``

### Getting Manga

- ``MangaDexAPIClient/getManga(_:)->Result<Manga,Error>``
- ``MangaDexAPIClient/getManga(_:)-46lz8``
- ``MangaDexAPIClient/getManga(_:limit:offset:)``
- ``MangaDexAPIClient/getRandomManga()``

### Getting the Chapters for a Manga

- ``MangaDexAPIClient/getChapters(for:limit:offset:)``

### Getting all Covers for a Manga

- ``MangaDexAPIClient/getCovers(mangaIDs:limit:offset:)``

### Following

- ``MangaDexAPIClient/follow(manga:)``

### Unfollowing

- ``MangaDexAPIClient/unfollow(manga:)``

### Finding Followed Manga

- ``MangaDexAPIClient/checkIfMangaIsFollowed(_:)``

### Getting Reading Statustes

- ``MangaDexAPIClient/getReadingStatus(for:)``
- ``MangaDexAPIClient/getAllReadingStatus()``

### Updating Reading Statuses

- ``MangaDexAPIClient/updateReadingStatus(for:to:)``

### Getting Statisics

- ``MangaDexAPIClient/getStatistics(for:)-52hb``
- ``MangaDexAPIClient/getStatisics(for:)``

### Getting Available Tags

- ``MangaDexAPIClient/getTags()``

### Filtering by Language

- ``Manga/originalLanguage``

### Finding Titles

- ``Manga/title``
- ``Manga/localizedTitle``
- ``Manga/alternateTitle``

### Finding Titles in Multiple Languages

- ``Manga/altTitles``

### Array Utility for AltTitles

- ``Swift/Array/flattenAltTitles()``

### Finding Translations

- ``Manga/availableTranslatedLanguages``

### Appears in

- ``RelatedManga``
- ``MangaStatistics``
