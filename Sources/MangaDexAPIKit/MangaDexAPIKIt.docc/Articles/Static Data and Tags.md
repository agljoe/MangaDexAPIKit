# Static Data and Tags

A collection of alternate non-unique identifiers, categories, and sort descriptors.

## Overview

MangaDex categorizes manga by themes, genre, and content to allow for a better search experience. With the exception of tags, these values are not directly accessible through the API, but rather are included in the JSON data returned at various endpoints.

For more information the official developer reference can be found [here](https://api.mangadex.org/docs/3-enumerations/).

## Topics

### Languages and Localization

- ``LocalizedLanguage``
- ``languageCodeDictonary``

### Links

- ``MangaLink``

### Indentifiers and Categories

- ``Demographic``
- ``Status``
- ``ReadingStatus``
- ``Rating``
- ``Tag``

### Related Object Types

- ``RelationshipType``
- ``MangaRelated``

### Sort Descriptors

- ``Order``
- ``IncludedTagsMode``
- ``ExcludedTagsMode``

### Servers

- ``MangaDexAPIBaseURL``
