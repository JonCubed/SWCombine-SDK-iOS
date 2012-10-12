//
//  LoginViewController.h
//  swc test app
//
//  Created by Lion User on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWC.h"

@end
@interface LoginViewController : UIViewController <UIWebViewDelegate>{
    
    IBOutlet UIWebView *uiLoginView;
    IBOutlet UIButton *getCharAccount;
    NSMutableData *receivedData;
    NSString *code;
    NSString *accessToken;
    NSString *refreshToken;
}

@property (nonatomic, strong) IBOutlet UIWebView *uiLoginView;
@property (nonatomic, strong) IBOutlet UIButton *getCharAccount;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;


-(IBAction)GetCharacterAccount:(id)sender;
-(IBAction)GetShips:(id)sender;
-(IBAction)getTokens:(id)sender;

@property (nonatomic, strong) NSMutableData *receivedData;

@end
