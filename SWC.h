//
//  SWC.h
//  swc test app
//
//  Created by Yian on 27/09/12.
//
//

#import <Foundation/Foundation.h>
#import "clsConstants.h"
@protocol SCSessionDelegate;

@interface SWC : NSObject{
    
    NSString* _appId;
    NSString* _urlSchemeSuffix;
    
    
}

//Properties
@property (nonatomic, strong) NSString *client_ID;
@property (nonatomic, strong) NSString *client_Secret;
@property (nonatomic, strong) id<SCSessionDelegate> delegate;
@property(nonatomic, copy) NSString* urlSchemeSuffix;
@property(nonatomic, copy) NSString* appId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *charName;
@property (nonatomic, strong) NSMutableData *receivedData;

//Methods
-(id)initWithAppId:(NSString *)clientID:(NSString *)clientSecret;
-(void)attemptLogin;
-(BOOL)parseURL:(NSURL *)url;

//Web services hub
-(NSString *)CharacterAccount;
-(NSString *)Ships;
-(NSString *)Time;
-(NSString *)ClassType;
-(NSString *)InventoryClass;

@end




////////////////////////////////////////////////////////////////////////////////

/**
 * Delegate for receiving callbacks.
 */
@protocol SCSessionDelegate <NSObject>

/**
 * User logs in.
 */
- (void)scDidLogin;

/**
 * User did not log in.
 */
- (void)scDidNotLogin:(BOOL)cancelled;

