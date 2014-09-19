//
//  RUUTracker.m
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 22/08/14.
//  Copyright (c) 2014 UFMT. All rights reserved.
//

#import "RUUTracker.h"

@implementation RUUTracker

+ (void) sendCreateView:(NSString *) viewName{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:viewName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
