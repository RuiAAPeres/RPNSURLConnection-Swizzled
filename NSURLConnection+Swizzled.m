//
//  NSURLConnection+Swizzled.m
//
//  Created by Rui Peres on 27/07/13.
//  Copyright (c) 2013 Rui Peres. All rights reserved.
//

#import "NSURLConnection+Swizzled.h"
#import <objc/runtime.h>

@implementation NSURLConnection (Swizzled)

// Poor's man flag. Used to know if the methods are already Swizzed
static BOOL isSwizzed;
// Flag to know if the output of the stacktrace should be used. By default YES
static BOOL shouldUseStackTrace;


+(void)load
{
    isSwizzed = NO;
    shouldUseStackTrace = YES;
}

#pragma mark - Util methods

static void swizzClass(Class class, SEL originalSel, SEL newSel)
{
    Method origMethod = class_getClassMethod(class, originalSel);
    Method newMethod = class_getClassMethod(class, newSel);
    
    method_exchangeImplementations(origMethod, newMethod);
}

static void swizzInstance(Class class, SEL originalSel, SEL newSel)
{
    Method origMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    
    method_exchangeImplementations(origMethod, newMethod);
}


+ (NSString*)logInfoWithRequest:(NSURLRequest *)request
{
    
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\ncurl -X %@",
                                      [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]],
                                      request.HTTPMethod];
    
    [[request allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop)
     {
         [displayString appendFormat:@" -H \'%@: %@\'", key, val];
     }];
    
    [displayString appendFormat:@" \'%@\'",  request.URL.absoluteString];
    
    if ([request.HTTPMethod isEqualToString:@"POST"] ||
        [request.HTTPMethod isEqualToString:@"PUT"] ||
        [request.HTTPMethod isEqualToString:@"PATCH"]) {
        
        NSString *bodyString = [[NSString alloc] initWithData:[request HTTPBody]
                                                     encoding:NSUTF8StringEncoding];
        [displayString appendFormat:@" -d \'%@\'", bodyString];
    }
    
    return displayString;
}

+ (NSString *)stripDoubleSpaceFrom:(NSString *)str {
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}

+ (void)outputStackTrace
{
    NSArray *stackSymbolsArray =    [NSThread callStackSymbols];
    // Here we will format the stack symbols, in order to not polute too much
    // the console
    NSLog(@"------------------------------  Stack trace  ---------------------------------------");
    for (NSString *stackSymbolsLine in stackSymbolsArray)
    {
        // Remove the extra white spaces
        NSMutableArray *blaharray = [NSMutableArray arrayWithArray:[[NSURLConnection stripDoubleSpaceFrom:stackSymbolsLine] componentsSeparatedByString:@" "]];
        
        // Remove the hexa information
        [blaharray removeObjectAtIndex:2];
        // Build the final string
        NSString *finalString = [blaharray componentsJoinedByString:@" "];
        // Output it
        NSLog(@"%@", finalString);
    }
 NSLog(@"----------------------------------------------------------------------------");
}

+ (void)operateRequest:(NSURLRequest*)request
{
    
    if (shouldUseStackTrace)
    {
        //NSLog(@"%@",[NSThread callStackSymbols]); // If you are not happy with the modifications, uncoment this line
        //and comment the bellow
        [NSURLConnection outputStackTrace];
    }
    
    // Log the curl info
    NSLog(@"%@",[NSURLConnection logInfoWithRequest:request]);
}


#pragma mark - SwizzMethods

+ (void)swizzSendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    [NSURLConnection operateRequest:request];
    // Call the original method
    [self swizzSendAsynchronousRequest:request queue:queue completionHandler:handler];
}

- (id)swizzInitWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately
{
    [NSURLConnection operateRequest:request];
    // Call the original method
    return  [self swizzInitWithRequest:request delegate:delegate startImmediately:startImmediately];
}

#pragma mark - Public methods

+ (void)stopStackTrace
{
    shouldUseStackTrace = NO;
}


+ (void)swizzIt
{
    // We won't do anything if it's already swizzed
    if (isSwizzed)
    {
        return;
    }
    
    isSwizzed = YES;
    // First we take care about the initWithRequest:delegate:startImmediately: (notice that it's a instance method)
    swizzInstance([self class],@selector(initWithRequest:delegate:startImmediately:),@selector(swizzInitWithRequest:delegate:startImmediately:));
    
    // Secondly we take care about the sendAsynchronousRequest:queue:completionHandler: (notice that it's a class method)
    swizzClass([self class],@selector(sendAsynchronousRequest:queue:completionHandler:),@selector(swizzSendAsynchronousRequest:queue:completionHandler:));
}

+ (void)undoSwizz
{
    // We won't do anything if it has not been Swizzed
    if (!isSwizzed)
    {
        return;
    }
    
    isSwizzed = NO;
    // First we take care about the initWithRequest:delegate:startImmediately: (notice that it's a instance method)
    swizzInstance([self class],@selector(swizzInitWithRequest:delegate:startImmediately:),@selector(initWithRequest:delegate:startImmediately:));
    
    // Secondly we take care about the sendAsynchronousRequest:queue:completionHandler: (notice that it's a class method)
    swizzClass([self class],@selector(swizzSendAsynchronousRequest:queue:completionHandler:),@selector(sendAsynchronousRequest:queue:completionHandler:));
}

@end
