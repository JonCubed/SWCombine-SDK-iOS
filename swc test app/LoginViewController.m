//
//  LoginViewController.m
//  swc test app
//
//  Created by Lion User on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "NSObject+SBJSON.h"
#import "clsConstants.h"
#import "NSObject+SBJson.h"
#import <QuartzCore/QuartzCore.h>
#import "SocketViewController.h"
#import "SWC.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize uiLoginView;
@synthesize getCharAccount;
@synthesize receivedData;
@synthesize code;
@synthesize refreshToken;
@synthesize accessToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    uiLoginView.delegate = self;
    
    
    [uiLoginView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.swcombine.net/ws/oauth2/login.php?scope=character_read&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=bf25fa7a4cf54ed9138f55964b207fede60dd03f"]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSRange match;
    
    match = [title rangeOfString:@"Success"];
    
    if (match.location == NSNotFound)
        NSLog(@"match not found");
    else {
        NSLog(@"match found at index %u  ", match.location);
        self.code = [title stringByReplacingOccurrencesOfString:@"Success,code=" withString:@""];
    
    }
    

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)GetShips:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *character = [appDelegate.swc Time];
    
    NSLog(character);
    
}


-(IBAction)GetCharacterAccount:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *character = [appDelegate.swc CharacterAccount];
    //
   // NSLog(character);

}

-(IBAction)getStuff:(id)sender {

    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *character = [appDelegate.swc InventoryClass];
    
    NSLog(character);
    
    
}
-(IBAction)getTokens:(id)sender {
    
    //SCRequest *request = [[SCRequest alloc] init];
   
    
    /*
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dev.swcombine.net/ws/oauth2/token/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *strCode = [@"code=" stringByAppendingFormat:self.code];
    NSString *sendData = @"&client_id=bf25fa7a4cf54ed9138f55964b207fede60dd03f&client_secret=491d54345ce4308bac9e9e9839587eaf431ebab6&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code&access_type=offline";
    
    NSString *strData = [NSString stringWithFormat:@"%@%@", strCode, sendData];
    NSData *requestData = [NSData dataWithBytes:[strData UTF8String] length:[strData length]];

    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    NSURLResponse* response;
    NSError* error = nil;
                    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];      
                    
    NSString *jsonString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];

    NSDictionary* Results = (NSDictionary*)[jsonString JSONValue]; 
 
        self.accessToken = [Results objectForKey:@"access_token"];
*/
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];  
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *strError = [[NSString alloc] initWithFormat:@"Unable to create account. %@", [error localizedDescription]];
    
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Connection problem" 
                          message:strError 
                          delegate:self 
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil];
    [alert show];

    
}

//did receive response for connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
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


-(IBAction)Newpage:(id)sender {
    SocketViewController *svc = [[SocketViewController alloc] initWithNibName:@"SocketViewController" bundle:nil];
    
    [self.navigationController pushViewController:svc animated:YES];
    
}


-(IBAction)showWebView:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
   
        [appDelegate.swc attemptLogin];
    
    
    
    
   // SWC *swc = [[SWC alloc] initWithAppId:@"bf25fa7a4cf54ed9138f55964b207fede60dd03f" :@"491d54345ce4308bac9e9e9839587eaf431ebab6"];
    
   // [swc attemptLogin];
    
}
@end
