//
//  WEAppDelegate.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import <Parse/Parse.h>
#import "WEUser.h"
#import "WEAppDelegate.h"
#import "WERegistrationViewController.h"
#import "WEWeeeeiViewController.h"
#import "WESecrets.h"

@implementation WEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_ID];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([WEUser currentUser]) {
        WEWeeeeiViewController *weeeeiViewController = [[WEWeeeeiViewController alloc] initWithNibName:@"WEWeeeeiViewController" bundle:nil];
        self.window.rootViewController = weeeeiViewController;
    }else{
        WERegistrationViewController *viewControlelr = [[WERegistrationViewController alloc] initWithNibName:@"WERegistrationViewController" bundle:nil];
        self.window.rootViewController = viewControlelr;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    WEUser *user = [WEUser currentUser];
    if (!user) {
        return;
    }
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:user.userName forKey:@"channels"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
