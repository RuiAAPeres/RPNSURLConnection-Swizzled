//
//  NSURLConnection+Swizzled.h
//  Testing
//
//  Created by Rui Peres on 27/07/13.
//  Copyright (c) 2013 Aphely. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SWIZZ_IT [NSURLConnection swizzIt];
#define UN_SWIZZ_IT [NSURLConnection undoSwizz];

/**
 Category used to "log curl command line prompts for debugging purposes". 
 This category was inspired on NSMutableURLRequest+MKCurlAdditions from
 MugunthKumar. You can find it here: 
 https://github.com/MugunthKumar/CurlNSMutableURLRequestDemo
 It will also print the stacktrace so you can understand from where this call is
 coming from.
 */
@interface NSURLConnection (Swizzled)

/**
 It will swizz the methods:
 1) sendAsynchronousRequest:queue:completionHandler:
 2) initWithRequest:delegate:startImmediately:

 The first one was selected because I use quite often.
 The second one because AFNetworking uses it.
 @return void
 */
+ (void)swizzIt;

/**
 It will undo what was done with the swizzIt
 @return void
 */
+ (void)undoSwizz;

@end
