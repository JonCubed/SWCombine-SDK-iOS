//
//  SocketViewController.h
//  swc test app
//
//  Created by Lion User on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocketViewController : UIViewController <UIWebViewDelegate>{
  
    IBOutlet UIWebView *uiSocketView;
}


@property (nonatomic, strong) IBOutlet UIWebView *uiSocketView;


@end
