# Representing Data Models with Entities

Entities are representations used to simplify API requests.

## Overview

Data retireved from an API is generally refered to as a resource, but the name "entity" is used here to mirror MangaDex's documentation. 

Entities represent their endpoint specific details including available query parameters, and use of authentication. Most entities can be passed to a generic ``Request`` type, but in some case custom requests may be preferable. Enities are responsible for specifying the actual type of the data being requested. To ensure that you are meeting any endpoint specific requirements consult the documentation of the API being used.

## Topics

### Wrappers and Standard Responses

- ``Wrapper``
- ``Response``

### Retrieving Single Values

- ``MangaDexAPIEntity``

