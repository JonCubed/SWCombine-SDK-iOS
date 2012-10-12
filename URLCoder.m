//
//  URLCoder.m
//  swc test app
//
//  Created by Yian on 29/09/12.
//
//

#import "URLCoder.h"

@implementation URLCoder



// Encode a string to embed in an URL.
NSString* encodeToPercentEscapeString(NSString *string) {
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    
}

// Decode a percent escape encoded string.
NSString* decodeFromPercentEscapeString(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (CFStringRef) string,
                                                            CFSTR(" "),
                                                            kCFStringEncodingUTF8);
}

@end
