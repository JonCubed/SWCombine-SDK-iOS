//
//  AppDelegate.h
//  swc test app
//
//  Created by Lion User on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

#import "SWC.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, SCSessionDelegate> {
    
    SWC *swc;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) LoginViewController *loginScreen;
@property (nonatomic, retain) SWC *swc;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
