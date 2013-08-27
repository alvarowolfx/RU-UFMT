//
//  RUUScrapingCardapioTask.h
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 13/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFHTTPRequestOperation.h>
#import "RUUCardapio.h"

#define kUFMT_RU_URL @"http://www.ufmt.br/ufmt/unidade/index.php/secao/visualizar/3793/RU"
typedef void (^CardapioScrapingSuccessBlock)(RUUCardapio *cardapioLunch, RUUCardapio *cardapioDinner,NSDate *date);
typedef void (^CardapioScrapingFailedBlock)(NSError *error);

@interface RUUScrapingCardapioTask : NSObject{
    AFHTTPRequestOperation *operation;
    NSURLRequest *request;
}
@property (strong) CardapioScrapingSuccessBlock successBlock;
@property (strong) CardapioScrapingFailedBlock failedBlock;


-(void) setSuccesBlock:(void (^)(RUUCardapio *cardapioLunch,RUUCardapio *cardapioDinner,NSDate *date))success
             failure:(void (^)(NSError *error))failure;

-(void)start;
-(void)stop;

@end
