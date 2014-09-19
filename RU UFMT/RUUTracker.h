//
//  RUUTracker.h
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 22/08/14.
//  Copyright (c) 2014 UFMT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

@interface RUUTracker : NSObject

+ (void) sendCreateView:(NSString *) viewName;

@end
