//
//  URLCoder.h
//  swc test app
//
//  Created by Yian on 29/09/12.
//
// Made for properly encoding and decoding url strings

#import <Foundation/Foundation.h>

@interface URLCoder : NSObject

NSString* encodeToPercentEscapeString(NSString *string);

NSString* decodeFromPercentEscapeString(NSString *string);

@end
