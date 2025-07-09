This is the result of 2 years of figuring out how to interact with the MangaDexAPI only using native Swift code. Efficient? Maybe not, but a fun and interesting challenge nonetheles.

Note that some things such as rate limits and UserDefaults are implemented for my use cases, so you are recommended to fork this repository and make changes as you see fit.

Some Things to be Aware of:

- This library is has not been tested at all. It seems to work for my use cases (classic response) but you will definetely run into edge cases I haven't accounted for. If this happens make a pull request or open an issue or whatever the proper git thing to do is. 

- You can hit, and exceed MangaDex's rate limits with this library. If you get banned by MD its on you (sorry), so just try not to spam requests. If you're trying to get lots of data you're probably been off web-scraping than trying to use random some undergrads swift package.

- I will try to remember to use the @deprecated macro, but instance members, and functions may just change names without warning. Also I plan to mark most of the functionality with @cocurrent whenever it comes out in September so you have been warned.
