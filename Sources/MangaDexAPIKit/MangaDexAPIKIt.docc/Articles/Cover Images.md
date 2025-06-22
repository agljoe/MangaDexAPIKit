# Cover Images

A peice of artwork found on the front of a manga volume.

## Overview

Most manga have a decicated cover art for each volume. Oneshots may provide a single page as their cover art.

Cover images can be accessed three different ways. Through the get cover enpoint, by supplying a cover UUID, the get covers endpoint by supplying a list of manga UUIDs, or from the reference expansion of the get manga endpoint. In general the most efficient way to get the lastest cover for a given manga is to specify the includes cover endpoint. To fetch all the availble covers for a manga use the get covers endpoint.

The unexpanded refernce for a given manga's cover is simply the cover's UUID. Fetching the cover with this UUID will return the same result that could have been included in the expanded reference with one less API call.

## Topics

### Types

- ``Cover``
