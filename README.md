NSURLConnection+Swizzled
=============
-------------

Category used to "log curl command line prompts for debugging purposes". This category was inspired on NSMutableURLRequest+MKCurlAdditions from [Mugunth Kumar](https://twitter.com/mugunthkumar), you can find it [here](https://github.com/MugunthKumar/CurlNSMutableURLRequestDemo). It will also print the stacktrace so you can understand from where the calls are coming from.

**Don't forget to disable it in production code. This is only for debugging**

------------
Requirements
============

Include the library:

* libobjc.dylib

And import the category where you want to use it:

* `#import "NSURLConnection+Swizzled.h"`

------------------------------------
Adding NSURLConnection+Swizzled to your project
====================================

Just add the two files inside your project (`NSURLConnection+Swizzled.h` and `NSURLConnection+Swizzled.m`).

-----
Usage
=====

Before making a remote connection you can call `SWIZZ_IT` and after you are done with it `UN_SWIZZ_IT`. For example:

```objective-c
SWIZZ_IT
[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.google.com"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *as, NSData *a, NSError *ads)
{
   NSLog(@"blah blah");
}];
    
UN_SWIZZ_IT
```

This will output:

```
2013-07-27 01:33:24.366 Testing[12197:c07] ------------------------------  Stack trace  ---------------------------------------
2013-07-27 01:33:24.369 Testing[12197:c07] 0 Testing +[NSURLConnection(Swizzled) outputStackTrace] + 71
2013-07-27 01:33:24.370 Testing[12197:c07] 1 Testing +[NSURLConnection(Swizzled) operateRequest:] + 69
2013-07-27 01:33:24.370 Testing[12197:c07] 2 Testing +[NSURLConnection(Swizzled) swizzSendAsynchronousRequest:queue:completionHandler:] + 132
2013-07-27 01:33:24.371 Testing[12197:c07] 3 Testing -[APViewController viewDidLoad] + 296
2013-07-27 01:33:24.371 Testing[12197:c07] 4 UIKit -[UIViewController loadViewIfRequired] + 536
2013-07-27 01:33:24.371 Testing[12197:c07] 5 UIKit -[UIViewController view] + 33
2013-07-27 01:33:24.372 Testing[12197:c07] 6 UIKit -[UIWindow addRootViewControllerViewIfPossible] + 66
2013-07-27 01:33:24.372 Testing[12197:c07] 7 UIKit -[UIWindow _setHidden:forced:] + 368
2013-07-27 01:33:24.373 Testing[12197:c07] 8 UIKit -[UIWindow _orderFrontWithoutMakingKey] + 49
2013-07-27 01:33:24.373 Testing[12197:c07] 9 UIKit -[UIWindowAccessibility(SafeCategory) _orderFrontWithoutMakingKey] + 77
2013-07-27 01:33:24.374 Testing[12197:c07] 10 UIKit -[UIWindow makeKeyAndVisible] + 65
2013-07-27 01:33:24.374 Testing[12197:c07] 11 Testing -[APAppDelegate application:didFinishLaunchingWithOptions:] + 661
2013-07-27 01:33:24.375 Testing[12197:c07] 12 UIKit -[UIApplication _handleDelegateCallbacksWithOptions:isSuspended:restoreState:] + 266
2013-07-27 01:33:24.375 Testing[12197:c07] 13 UIKit -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1248
2013-07-27 01:33:24.375 Testing[12197:c07] 14 UIKit -[UIApplication _runWithURL:payload:launchOrientation:statusBarStyle:statusBarHidden:] + 805
2013-07-27 01:33:24.376 Testing[12197:c07] 15 UIKit -[UIApplication handleEvent:withNewEvent:] + 1022
2013-07-27 01:33:24.376 Testing[12197:c07] 16 UIKit -[UIApplication sendEvent:] + 85
2013-07-27 01:33:24.377 Testing[12197:c07] 17 UIKit _UIApplicationHandleEvent + 9874
2013-07-27 01:33:24.377 Testing[12197:c07] 18 GraphicsServices _PurpleEventCallback + 339
2013-07-27 01:33:24.378 Testing[12197:c07] 19 GraphicsServices PurpleEventCallback + 46
2013-07-27 01:33:24.378 Testing[12197:c07] 20 CoreFoundation __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__ + 53
2013-07-27 01:33:24.379 Testing[12197:c07] 21 CoreFoundation __CFRunLoopDoSource1 + 146
2013-07-27 01:33:24.379 Testing[12197:c07] 22 CoreFoundation __CFRunLoopRun + 2118
2013-07-27 01:33:24.380 Testing[12197:c07] 23 CoreFoundation CFRunLoopRunSpecific + 276
2013-07-27 01:33:24.380 Testing[12197:c07] 24 CoreFoundation CFRunLoopRunInMode + 123
2013-07-27 01:33:24.381 Testing[12197:c07] 25 UIKit -[UIApplication _run] + 774
2013-07-27 01:33:24.381 Testing[12197:c07] 26 UIKit UIApplicationMain + 1211
2013-07-27 01:33:24.382 Testing[12197:c07] 27 Testing main + 141
2013-07-27 01:33:24.382 Testing[12197:c07] 28 Testing start + 53
2013-07-27 01:33:24.383 Testing[12197:c07] ----------------------------------------------------------------------------
2013-07-27 01:33:24.384 Testing[12197:c07] Saturday, July 27, 2013, 1:33:24 AM Western European Summer Time
Request
-------
curl -X GET 'www.google.com'
```

If you want to keep receiving information during the whole application just `SWIZZ_IT` on your `applicationDidFinishLaunching` and don't use `UN_SWIZZ_IT`.

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 
