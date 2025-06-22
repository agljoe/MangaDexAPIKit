# Request Types and Authentication

Create API requests that can be executed at any time.

## Overview

Request types retieve data using the information provided by an entity. Requests are responsible for retieveing and and decoding data into a format that can be presented in a view. General ``Request`` and ``ListRequest`` types assume that the URLs they have been provided match their endpoint specifications. 

Authenicated requests must be made using OAuth 2.0 protcols as state [here](https://api.mangadex.org/docs/02-authentication/), tokens are automatically handled by Apple's Keychain library.

## Topics

### General Requests

- ``MangaDexAPIRequest``
- ``Request``
- ``ListRequest``

### Specialized Requests

- ``AtHomeRequest``
- ``TagListRequest``
- ``ChapterStatisticsRequest``
- ``GroupedChapterStatisticsRequest``
- ``MangaStatisticsRequest``
- ``GroupedMangaStatisticsRequest``
- ``CoverListFromMangaRequest``

### Credentials

- ``Credentials``
- ``Token``

### Managing Sensitive Data
- 
### Authenticated Requests

- ``LoginRequest``
- ``ReAuthenticationRequest``
- ``CheckIfMangaIsFollowedRequest``
- ``Follow``
- ``Unfollow``
- ``MangaReadingStatusRequest``
- ``AllMangaReadingStatusRequest``
- ``UpdateReadMarkerRequest``
- ``UpdateMangaReadingStatusRequest``

### About Errors

- ``ErrorResponse``
- ``MangaDexAPIError``
- ``MangaDexAPIErrorResponse``
- ``AuthenticationError``

