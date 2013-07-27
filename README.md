NSURLConnection+Swizzled
=============
-------------

Category used to "log curl command line prompts for debugging purposes". This category was inspired on NSMutableURLRequest+MKCurlAdditions from [Mugunth Kumar](https://twitter.com/mugunthkumar), you can find it [here](https://github.com/MugunthKumar/CurlNSMutableURLRequestDemo). It will also print the stacktrace so you can understand from where the calls are coming from.

**Don't forget to disable it in production code.**

------------
Requirements
============

Include the library:

* libobjc.dylib

And import the category where you want to use it:

* #import "NSURLConnection+Swizzled.h"

------------------------------------
Adding NSURLConnection+Swizzled to your project
====================================

Just add the two files inside your project (`NSURLConnection+Swizzled.h` and `NSURLConnection+Swizzled.m`).

-----
Usage
=====

Before a call you can call `SWIZZ_IT` and after you are done with it `UN_SWIZZ_IT`.
If you want to keep receiving information during the whole application just `SWIZZ_IT`.

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 
