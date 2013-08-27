//
//  RUUBackendScrapingCardapioTask.h
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 26/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFJSONRequestOperation.h>
#import "RUUCardapio.h"

#define kSERVER_URL @"http://ruufmt-agiratec.rhcloud.com/api/v1/cardapio.json"

@interface RUUBackendScrapingCardapioTask : NSObject{
    AFJSONRequestOperation *operation;
    NSURLRequest *request;
}

typedef void (^CardapioScrapingSuccessBlock)(RUUCardapio *cardapioLunch, RUUCardapio *cardapioDinner,NSDate *date);
typedef void (^CardapioScrapingFailedBlock)(NSError *error);

@property (strong) CardapioScrapingSuccessBlock successBlock;
@property (strong) CardapioScrapingFailedBlock failedBlock;

-(void) setSuccesBlock:(void (^)(RUUCardapio *cardapioLunch,RUUCardapio *cardapioDinner,NSDate *date))success
               failure:(void (^)(NSError *error))failure;

-(void)start;
-(void)stop;
@end
