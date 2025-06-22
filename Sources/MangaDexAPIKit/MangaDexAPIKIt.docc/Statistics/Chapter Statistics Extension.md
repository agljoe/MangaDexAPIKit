# ``ChapterStatistics``

## Overview

A chapter's statisics simply contains an ID for its comments thread. Most chapters will have a comments thread by default, but in the cases where none exists the thread ID will be nil.

## Topics

### Creating Chapter Statistics

- ``ChapterStatistics/init(from:)``

### Getting the Statisics for a Chapter

- ``MangaDexAPIRequestManager/getStatistics(for:)->ChapterStatistics``
- ``MangaDexAPIRequestManager/getStatistics(for:)->[String:ChapterStatistics]``

### Contructing a Thread URL

- ``Statistics/commentsURL``

### Appears in

- ``ChapterStatisticsRequest``
- ``GroupedChapterStatisticsRequest``

