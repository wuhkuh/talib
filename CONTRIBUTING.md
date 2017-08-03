# Contributing Guidelines

If you wonder how you could help out, there are several ways to do so:

### 1. Auditing the functions  

Every function in this library is critical for the end-user.  
The end-user must be able to trust us when it comes down to maintaining the
correct equations and their optimization.  
This means that the functions and their equations, just like science in general,
have a **need to be reviewed**.

This is where external people, like you, come into play.

Equation testing is achieved by creating or using a test suite: plug the input
in the correct functions and compare the output.  
An easy way to do this is by replacing the unit test fixtures and running
`mix test`.

If you can confirm the function works properly, please create a pull request and
add your name and title in the function docs.  
This way people can see the function has been audited and who audited it.

### 2. Refactoring the functions

It may happen that a function can be optimized further. In this case,
feel free to create a pull request with the necessary changes.  

Please keep the style consistent.  
Readability is just as important as efficient code, if not more important
(due to better maintainability)!

### 3. Suggesting new functions

It is possible that this library lacks a certain function, which could just be
the one you want to implement somewhere.  
In this case, you could create the function and send it as a pull request. Don't
forget to include unit tests!

Even if you don't have the time to create the function yourself, feel free to
open an issue in the issue tracker.

Remember the scope of the project: it is not made for interpretation of data
(calculating long/short signals): that is up to the end-user.

------------------------
### Thanks for checking the Talib project!
