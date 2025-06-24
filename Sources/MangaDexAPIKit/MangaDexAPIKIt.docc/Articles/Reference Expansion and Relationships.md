# Reference Expansion and Relationships

Reduce API calls, and retieve any addition information related to an entity.

## Overview

In order to reduce server load MangaDex supplies reference expansions at certain endpoints in a heterogeneous JSON array. These must be dynamically decoded using the type indicated at the index 1 keypath "type" usually after the "id" JSON key. The flatten and decode this sort of JSON structure I have combined basically the only implementions I could find online to do both of these.

- Note: The JSON decoding problem could have probably been solved with a billion different structs. Well that's an exaggeration, but I find many structs to be one ugly and poorly formed code, and two hellish to document so I have opted for the current implementation.

- Warning: If a reference is expanded that does not have a case in its respective relationship type enum it will cause a crash. This can happen if MangaDex introduces new references that are included but not expanded by default. 

## Topics

### Being Expandable

- ``ReferenceExpansion``
- ``Expandable``

### Relationships

- ``AuthorRelationship``
- ``AuthorRelationshipType``
- ``ChapterRelationship``
- ``ChapterRelationshipType``
- ``MangaRelationship``
- ``MangaRelationshipType``

### Available Reference Expansions

- ``AuthorReferenceExpansion``
- ``ChapterReferenceExpansion``
- ``CoverReferenceExpansion``
- ``MangaReferenceExpansion``
- ``ScanlationGroupReferenceExpansion``

