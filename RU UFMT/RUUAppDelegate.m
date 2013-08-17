//
//  RUUAppDelegate.m
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 13/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import "RUUAppDelegate.h"

@implementation RUUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
#ifdef __IPHONE_7_0
    application.statusBarStyle = UIStatusBarStyleLightContent;
#endif
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

@end
