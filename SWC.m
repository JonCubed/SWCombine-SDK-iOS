//
//  SWC.m
//  swc test app
//
//  Created by Yian on 27/09/12.
//
//
#import "URLCoder.h"
#import "NSObject+SBJson.h"
#import "NSObject+SBJSON.h"
#import "SWC.h"
@end
@implementation SWC
@synthesize client_Secret;
@synthesize client_ID;
@synthesize urlSchemeSuffix;
@synthesize appId;
@synthesize code;
@synthesize accessToken;
@synthesize refreshToken;
@synthesize charName;
@synthesize receivedData;

//Init the object with clientID and Secret
- (id)initWithAppId:(NSString *)clientID:(NSString *)clientSecret{
    self = [super init];
    if (self) {
        self.client_ID = clientID;
        self.client_Secret = clientSecret;
    }
    return self;
}

/*
 *Login open url using safari callback
 *
 */
-(void)attemptLogin {
    BOOL didOpenOtherApp = NO;
    
     didOpenOtherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dev.swcombine.net/ws/oauth2/auth/?scope=character_read&redirect_uri=swcbf25fa7a4cf54ed9138f55964b207fede60dd03f://authorize/&response_type=code&client_id=bf25fa7a4cf54ed9138f55964b207fede60dd03f"]];
    
    
}

/*
 *Get results from allowing access on webpage
 *
 */
- (BOOL)parseURL:(NSURL *)url {
    if (![[url absoluteString] hasPrefix:[self getOwnBaseUrl]]) {
        return NO;
    }
 
    //our return query with code
    NSString *query = [url fragment];
    
    if (!query) {
        query = [url query];
    }
    
    //Get our parameters from query, should be "code" and "state"
    NSDictionary *params = [self parseURLParams:query];
    NSString *strCode = [params objectForKey:@"code"];
    
    //get "name" token from state
    NSString *strNameToken = [decodeFromPercentEscapeString([params objectForKey:@"state"]) stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSArray *tokenItems = [strNameToken componentsSeparatedByString:@";"];

    //store char name in property
    NSString *strName = [tokenItems objectAtIndex:1];
    self.charName = strName;
    
    
    
    // If the URL doesn't contain the access token, an error has occurred.
    if (!strCode) {
        NSString *errorReason = [params objectForKey:@"error"];
        if (errorReason && [errorReason isEqualToString:@"service_disabled_use_browser"]) {
        
            return YES;
        }
        if (errorReason && [errorReason isEqualToString:@"service_disabled"]) {
       
            return YES;
        }
        NSString *errorCode = [params objectForKey:@"error_code"];
        
        BOOL userDidCancel =
        !errorCode && (!errorReason || [errorReason isEqualToString:@"access_denied"]);
     
        return YES;
    }

    //store our code
    self.code = strCode;
    
    //get tokens from code
    [self getTokens:client_ID :client_Secret];
    
    return YES;

    
}


/*
 *Get tokens from clientID and clientSecret
 *
 */
-(void)getTokens:(NSString *)clientID:(NSString *)clientSecret {
    
    //Set up our request information such as url and header information
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dev.swcombine.net/ws/oauth2/token/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //Set up strings for our data
    NSString *strCode = [@"code=" stringByAppendingFormat:@"%@", self.code];
    NSString *strClient = [@"&client_id=" stringByAppendingString:clientID];
    NSString *strClientSecret = [@"&client_secret=" stringByAppendingString:clientSecret];
    NSString *sendData = [NSString stringWithFormat:@"%@%@&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code&access_type=offline",strClient, strClientSecret];
    
    //Data string
    NSString *strData = [NSString stringWithFormat:@"%@%@", strCode, sendData];
    
    //Request data
    NSData *requestData = [NSData dataWithBytes:[strData UTF8String] length:[strData length]];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    NSURLResponse* response;
    NSError* error = nil;
    
#warning using synchronous request for testing, change to async later
    
    //Send data with synchronous request
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    //Json string response
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    
    //Dictionary of return elements
    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue];
    
    //set access and refresh tokens
    self.accessToken = [Results objectForKey:@"access_token"];
    self.refreshToken = [Results objectForKey:@"refresh_token"];
    
    //successful login callback
    [self.delegate scDidLogin];
    
}


/**
 * Get base url function.
 */
- (NSString *)getOwnBaseUrl {
    return [NSString stringWithFormat:@"swc%@%@://authorize",
            client_ID,
            _urlSchemeSuffix ? _urlSchemeSuffix : @""];
}


//Breaks down url and gets parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}




#pragma mark Resources

/**
 *
 *Web Services hub
 *
*/


/*
 *Character Account resource
 *
 */

-(NSString *)CharacterAccount {
    NSString *strUrlCharacterAccount;
    
    
    strUrlCharacterAccount = [NSString stringWithFormat:@"%@%@%@%@", @"http://dev.swcombine.net/ws/v0.1/character/",encodeToPercentEscapeString(self.charName),@"/?access_token=", self.accessToken];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrlCharacterAccount]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"utf-8; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]; // release later
    
    return @"";
    
    /*
    NSString *strUrlCharacterAccount;
    
    
    strUrlCharacterAccount = [NSString stringWithFormat:@"%@%@%@", @"http://dev.swcombine.net/ws/v0.1/character/",encodeToPercentEscapeString(self.charName),@"/?access_token="];

    
    NSString *urlrequeststring = [NSString stringWithFormat:@"%@%@", strUrlCharacterAccount, self.accessToken];
    
    NSURL *myURL = [NSURL URLWithString: urlrequeststring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: myURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"utf-8; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:1];
    NSError* error = nil;
    NSURLResponse* response;
    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
     NSLog([error userInfo]);
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue];
    
   */
    
    
    
    
}



/*
 *Character Skills
 *
 */

-(NSString *)Ships {
    NSString *getShips;
    
    getShips = @"http://dev.swcombine.net/ws/v0.1/rules/ships/";
    
    NSURL *myURL = [NSURL URLWithString: getShips];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:myURL];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

/*
 *Character SkillGroup
 *
 */
-(NSString *)CharacterSkillGroup {
  
    
}


/*
 *Time
 *
 */

-(NSString *)Time {
    NSString *strUrlCharacterAccount;
    
    NSString *urlrequeststring = @"http://dev.swcombine.net/ws/v0.1/time/CGT/";
    
    NSURL *myURL = [NSURL URLWithString: urlrequeststring];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: myURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError* error = nil;
    NSURLResponse* response;
    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue];
    
}


/*
 *Type - classes
 *
 */
-(NSString *)ClassType {
    
    NSString *urlrequeststring = @"http://dev.swcombine.net/ws/v0.1/types/classes";
    
    NSURL *myURL = [NSURL URLWithString: urlrequeststring];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: myURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError* error = nil;
    NSURLResponse* response;
    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue];
    
}




/*
 *Type - Inventory
 *
 */

-(NSString *)InventoryClass {
    NSString *strUrlCharacterInventory;
       
    strUrlCharacterInventory= [NSString stringWithFormat:@"%@%@%@", @"http://dev.swcombine.net/ws/v0.1/inventory/",encodeToPercentEscapeString(self.charName),@"/?access_token="];
    
   
    
    NSString *urlrequeststring = [NSString stringWithFormat:@"%@%@", strUrlCharacterInventory, self.accessToken];
    
     NSURL *myURL = [NSURL URLWithString: urlrequeststring];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: myURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError* error = nil;
    NSURLResponse* response;
    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue];
    
    
}

/*
 *Async connection callbacks
 *
 */

#pragma mark Async NSUrlConnection callback
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    receivedData = [[NSMutableData alloc] init]; // _data being an ivar
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receivedData appendData:data];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // Handle the error properly
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSString *jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //NSDictionary* responseData;
    //responseData = (NSDictionary*)[jsonString JSONValue];
    
    //NSDictionary *Error = [responseData objectForKey:@"Error"];
    
    NSDictionary *Error = (NSDictionary*)[jsonString JSONValue];
    
    NSInteger errorCode = 0;
    NSString *strDisplayError = [[NSString alloc] init];
    
    if(Error != (id)[NSNull null])
    {
        // NSString* message = [Error objectForKey:@"Message"];
        NSString* msgType = [Error objectForKey:@"Type"];
        
        errorCode = [msgType intValue];
    }
    
    if(errorCode > 0)
    {
        switch(errorCode)
        {
            case INVALID_TOKEN :
                strDisplayError = @"Wrong user name or password.";
                break;
            case SERVER_UNAVAILABLE :
                strDisplayError = @"The server is not available. Please try again later.";
                break;
                
            case IMPROPER_JSON_FORMAT :
                strDisplayError = @"The server is not available. Please try again later.";
                break;
                
            case USERID_TAKEN :
                strDisplayError = @"That user name already exists, please try another one.";
                break;
                
            case NO_EMAIL:
            case INVALID_EMAIL:
                strDisplayError = @"Please provide a valid email address.";
                break;
                
            case  NO_SMTP:
                strDisplayError = @"SMTP server failure.";
                break;
                
            case UNKNOWN_ERROR :
                strDisplayError = @"Type: Unknown error.";
                break;
                
            default:
                strDisplayError = @"Type: Unrecognised error.";
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Could Not Create Account."
                              message:strDisplayError
                              delegate:self
                              cancelButtonTitle:@"Close."
                              otherButtonTitles:nil];
        [alert show];
        //  [spinner stopAnimating];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Success."
                              message:@"Your account has been saved."
                              delegate:self
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];
        
        
        // self.blnCreateNewAccount = NO;
        // [spinner stopAnimating];
        
        //[self.delegate settingsScreenDidFinish:self];
        //[self cancelPressed];
    }
}


@end
