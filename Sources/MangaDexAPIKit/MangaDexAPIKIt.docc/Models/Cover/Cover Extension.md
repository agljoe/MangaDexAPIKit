# ``Cover``

## Topics

### Creating a Cover

- ``Cover/init(from:)``

### Getting Covers

- ``Manga/cover``
- ``MangaDexAPIClient/getCover(_:)``
- ``MangaDexAPIClient/getCovers(coverIDs:limit:offset:)``

### Getting all Covers for a Manga

- ``MangaDexAPIClient/getCovers(mangaIDs:limit:offset:)``

### Getting the Latest Cover of Multiple Manga

- ``MangaDexAPIClient/getCovers(for:limit:offset:)``

### Comparing Covers

- ``Cover/==(_:_:)``

### Required for Decoding

- ``CoverRelationship``

### Appears in

- ``Manga/cover``
- ``MangaRelationship/cover_art(_:)``
- ``MangaRelationshipType/cover_art``
