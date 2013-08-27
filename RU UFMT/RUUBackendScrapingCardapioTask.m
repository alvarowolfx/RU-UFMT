//
//  RUUBackendScrapingCardapioTask.m
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 26/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import "RUUBackendScrapingCardapioTask.h"

@implementation RUUBackendScrapingCardapioTask

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:kSERVER_URL];
        request = [NSURLRequest requestWithURL:url];
        operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    }
    return self;
}

-(void) setSuccesBlock:(void (^)(RUUCardapio *cardapioLunch,RUUCardapio *cardapioDinner,NSDate *date))success
               failure:(void (^)(NSError *error))failure{
    self.successBlock = success;
    self.failedBlock = failure;
}

-(void)start{
    operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                  success:^(NSURLRequest *request,
                                            NSHTTPURLResponse *response,
                                            id JSON) {
                                      NSString *data = [JSON valueForKey:@"date"];
                                      NSError* error = nil;
                                      NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@".*([0-9]{1,2}[/][0-9]{1,2}[/][0-9]{2,4}).*"            options:0 error:&error];
                                      
                                      NSDate *dateFromSite = nil;
                                      NSArray *matches = [regex matchesInString:data options:0 range:NSMakeRange(0, [data length])];
                                      if([matches count] > 0){
                                          int idx = [data rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location;
                                          NSString* matchText = [data substringWithRange:NSMakeRange(0, idx)];
                                          NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                          [df setDateFormat:@"dd/MM/yy"];
                                          dateFromSite = [df dateFromString:matchText];
                                          //NSLog(@" %@, %@ " ,searchedString,matchText);
                                      }
                                      
                                      NSDictionary *cardapioAlmoco = [JSON valueForKey:@"almoco"];
                                      NSDictionary *cardapioJantar = [JSON valueForKey:@"jantar"];
                                      
                                      RUUCardapio *c1 = [RUUCardapio cardapioFromArrayOfDictionary:cardapioAlmoco];
                                      RUUCardapio *c2 = [RUUCardapio cardapioFromArrayOfDictionary:cardapioJantar];
                                      if(self.successBlock != NULL){
                                          //NSLog(@" chamndo sucesso !!!");
                                          self.successBlock(c1,c2,dateFromSite);
                                      }else{
                                          //NSLog(@" sucesso não setado =/ ");
                                          if(self.failedBlock != NULL){
                                              self.failedBlock(nil);
                                          }
                                      }
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {        
                                      if(self.failedBlock != nil){
                                          self.failedBlock(error);
                                      }
                                  }];
    [operation start];
}

-(void)stop{
    [operation cancel];
}

@end
