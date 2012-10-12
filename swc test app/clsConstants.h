//
//  clsConstants.h
//  
//
//  Created by Yiannis Pipertzis on 11/08/11.
//
// Connection constants
#import <Foundation/Foundation.h>

typedef enum errorMsg{
    INVALID_TOKEN = 2000,
    SERVER_UNAVAILABLE,
    USERID_TAKEN,
    IMPROPER_JSON_FORMAT,
    USER_EXISTS,
    NO_EMAIL,
    INVALID_EMAIL,
    NO_SMTP,
    UNKNOWN_ERROR = 3000
} ErrorMessage;

@interface NSObject (clsConstants)

@end
