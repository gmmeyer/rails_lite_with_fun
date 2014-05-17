# Rails Lite

Rails is an amazing piece of software. It does so much for you, and I wanted to understand the core of the functionality that it offers. So, I decided to build a clone of it (to go with my [active record clone](https://github.com/gmmeyer/active_record_with_fun)).

Stripping Rails down to the base leaves us with a few things: 
* The WEBRICK server
* A router
* The controllers
* The Parameters Hash
* The session cookie

These are the very barebones pieces that will allow you to build a website on top of them. That being said, I do not recommend that you utilize this to build a website, it has never been tested in a real world situation and would probably break pretty quickly (in addition to being extremely insecure in it's serving of data). But, the knowledge that I gained from building rails has allowed me to use rails far more efficiently than I would have been able to otherwise.