# ``MangaDexAPIClient``

## Topics

### Authentication

- ``MangaDexAPIClient/login(with:)``
- ``MangaDexAPIClient/reauthenticate()``

### Author and Artist Requests

- ``MangaDexAPIClient/getAuthor(_:)``
- ``MangaDexAPIClient/getAuthors(_:)``
- ``MangaDexAPIClient/getAuthors(_:limit:offset:)``

### Chapter and Related Requests

- ``MangaDexAPIClient/getChapter(_:)``
- ``MangaDexAPIClient/getChapters(_:)``
- ``MangaDexAPIClient/getChapters(_:limit:offset:)``
- ``MangaDexAPIClient/getChapterComponents(for:)``
- ``MangaDexAPIClient/getCustomFeed(_:limit:offset:)``
- ``MangaDexAPIClient/getFollowedFeed(limit:offset:)``
- ``MangaDexAPIClient/getReadMarker(_:)``
- ``MangaDexAPIClient/getReadMarkers(_:)``
- ``MangaDexAPIClient/updateReadMarkers(mangaID:readChapters:unreadChapters:)``
- ``MangaDexAPIClient/getStatistics(for:)-yixx``
- ``MangaDexAPIClient/getStatistics(for:)-8nb0t``

### Cover Requests

- ``MangaDexAPIClient/getCover(_:)``
- ``MangaDexAPIClient/getCovers(for:limit:offset:)``
- ``MangaDexAPIClient/getCovers(coverIDs:limit:offset:)``
- ``MangaDexAPIClient/getCovers(mangaIDs:limit:offset:)``

### Manga and Related Requests

- ``MangaDexAPIClient/getManga(_:)->Result<Manga,Error>``
- ``MangaDexAPIClient/getManga(_:)-46lz8``
- ``MangaDexAPIClient/getManga(_:limit:offset:)``
- ``MangaDexAPIClient/getRandomManga()``
- ``MangaDexAPIClient/getChapters(for:limit:offset:)``
- ``MangaDexAPIClient/getAllChapters(for:)``
- ``MangaDexAPIClient/checkIfMangaIsFollowed(_:)``
- ``MangaDexAPIClient/follow(manga:)``
- ``MangaDexAPIClient/unfollow(manga:)``
- ``MangaDexAPIClient/getReadingStatus(for:)``
- ``MangaDexAPIClient/getAllReadingStatus()``
- ``MangaDexAPIClient/updateReadingStatus(for:to:)``
- ``MangaDexAPIClient/getStatistics(for:)->Result<MangaStatistics,Error>``
- ``MangaDexAPIClient/getStatisics(for:)``
- ``MangaDexAPIClient/getTags()``

### Scanlation Group Requests

- ``MangaDexAPIClient/getScanlationGroup(_:)``

### User Requests

- ``MangaDexAPIClient/getUser(_:)``

### Being Environmentaly Friendly

- ``SwiftUICore/View/apiClient(_:)``
- ``SwiftUICore/EnvironmentValues/apiClient``
