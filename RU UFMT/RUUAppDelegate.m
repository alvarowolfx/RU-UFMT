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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

@end
