# ``Chapter``

## Topics

### Creating a Chapter

- ``Chapter/init(from:)``

### Getting Chapers

- ``MangaDexAPIClient/getChapter(_:)``
- ``MangaDexAPIClient/getChapters(_:)``
- ``MangaDexAPIClient/getChapters(_:limit:offset:)``

### Getting Chapter Images

- ``MangaDexAPIClient/getChapterComponents(for:)``

### Comparing Chapters

- ``Chapter/==(_:_:)``

### Filtering by Language

- ``Chapter/translatedLanguage``

### Getting Chapter Uploaders

- ``Chapter/scanlationGroup``
- ``Chapter/user``

### Getting a Parent Manga

- ``Chapter/parentManga``

### Getting Read Markers

- ``MangaDexAPIClient/getReadMarker(_:)``
- ``MangaDexAPIClient/getReadMarkers(_:)``

### Setting Read Markers

- ``MangaDexAPIClient/updateReadMarkers(mangaID:readChapters:unreadChapters:)``

### Getting Statistics

- ``MangaDexAPIClient/getStatistics(for:)-yixx``
- ``MangaDexAPIClient/getStatistics(for:)-8nb0t``

### Loading Chapter Feeds

- ``MangaDexAPIClient/getCustomFeed(_:limit:offset:)``
- ``MangaDexAPIClient/getFollowedFeed(limit:offset:)``

### Appears in

- ``AtHomeChapterComponents``
- ``ChapterStatistics``

