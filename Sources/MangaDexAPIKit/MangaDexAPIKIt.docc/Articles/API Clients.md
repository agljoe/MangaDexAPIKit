# API Clients

Objects that send and recieve data over the network.

## Overview

All MangaDexAPI clients are responsible for adhearing to the rules outlined MangaDex's' their documentation. This includes rate limits, authentication headers, and image proxies. You can use the default global `MangaDexAPIClient` actor, or implement your own by conforming to the `APIClient` protocol.

- Note: By default the `MangaDexAPiClient` enforces a maximum of 5 concurrent requests, rather than the true global 10 requests per second rate limit. If you believe that you will exceed this limit, you are encouraged to implement your own API client.

## Topics

### Types

- ``APIClient``
- ``MangaDexAPIClient``
- ``TokenBucket``

