//
//  SocketViewController.m
//  swc test app
//
//  Created by Lion User on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocketViewController.h"


@interface SocketViewController ()

@end

@implementation SocketViewController
@synthesize uiSocketView;

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
    


                                      
    uiSocketView.delegate = self;
    
        [uiSocketView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.swcombine.net/ws/oauth2/localredirect.php"]]];

    
    
    // Do any additional setup after loading the view from its nib.
}


-(void)webViewDidStartLoad:(UIWebView *)webView {

}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    

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






@end
