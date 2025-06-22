# ``AtHomeChapterComponents``

## Overview

At-home chapter components contain the fields use to construct the URLs for a dynamically assigned server. URLs constructed from these components are alive for fifteen minutes before new ones must be retrieved. In order to avoid getting new images constantly consider temporarly downloading images to a specialized cache to reduce bandwith use. 

As MangaDex explicitly states that at-home URLs are for temporary use they cannot be stored in a persistent model.

- Warning: Do not extract complete URLs from this structure, hardcoding URLs is never recommended.
          See [MangaDex API Documentation](https://api.mangadex.org/docs/04-chapter/retrieving-chapter/#about-hardcoding-base-urls).

 [Retreving a chapter's images](https://api.mangadex.org/docs/04-chapter/retrieving-chapter/)

## Topics

### Creating AtHomeChapterComponents

- ``AtHomeChapterComponents/init()``
- ``AtHomeChapterComponents/init(from:)``

### Getting AtHomeChapterComponents

- ``MangaDexAPIClient/getChapterComponents(for:)``

### Constructing URLs

- ``AtHomeChapterComponents/subscript(dataIndex:)``
- ``AtHomeChapterComponents/subscript(dataSaverIndex:)``

### Specifying Image Resolution

- ``AtHomeChapterComponents/data``
- ``AtHomeChapterComponents/dataSaver``

### Appears in

- ``AtHomeRequest``
