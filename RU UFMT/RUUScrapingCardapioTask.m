//
//  RUUScrapingCardapioTask.m
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 13/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import "RUUScrapingCardapioTask.h"
#import <TFHpple.h>

@implementation RUUScrapingCardapioTask

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:kUFMT_RU_URL];
        request = [NSURLRequest requestWithURL:url];
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    }
    return self;
}

-(void) setSuccesBlock:(void (^)(RUUCardapio *cardapioLunch,RUUCardapio *cardapioDinner,NSDate *date))success
                  failure:(void (^)(NSError *error))failure{
    self.successBlock = success;
    self.failedBlock = failure;
}

-(void)start{
    __weak RUUScrapingCardapioTask *self_ = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        
        NSData *ufmtHtmlData = [NSData dataWithData:responseObject];
        
        TFHpple *ufmtParser = [TFHpple hppleWithHTMLData:ufmtHtmlData];
        
        NSString *ufmtXpathQueryString = @"//div[@id='secao']/p/strong/span/span";
        NSArray *ufmtNodes = [ufmtParser searchWithXPathQuery:ufmtXpathQueryString];
        
        for (TFHppleElement *element in ufmtNodes) {
            
            NSLog(@" %@ " ,[element text]);
            
        }
        ufmtNodes = [ufmtParser searchWithXPathQuery:@"//div[@id='secao']//table"];
        
        if([ufmtNodes count] >= 2){
            NSLog(@" pegou tabelas");
            RUUCardapio *c1 = [self_ cardapioFromTable:[ufmtNodes objectAtIndex:0]];
            RUUCardapio *c2 = [self_ cardapioFromTable:[ufmtNodes objectAtIndex:1]];
            if(self.successBlock != NULL){
                NSLog(@" chamndo sucesso !!!");
                self.successBlock(c1,c2,nil);
            }else{
                NSLog(@" sucesso não setado =/ ");
            }
            
        }else{
            self_.failedBlock(nil);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(self.failedBlock != nil){
            self.failedBlock(error);
        }
     }];
    [operation start];
}

-(RUUCardapio *) cardapioFromTable:(TFHppleElement *) table{
    RUUCardapio *cardapio = [[RUUCardapio alloc] init];
    for(TFHppleElement *tr in [[table firstChildWithTagName:@"tbody"] children]){

        
        if([[tr children] count] >= 2){
            int cont = 0;
            NSString *section = nil;
            NSString *item = nil;
            for (TFHppleElement *td in [tr children]) {
                TFHppleElement *p = td.firstChild;
                if ([p tagName] == nil) continue;
                cont++;
                while(p.hasChildren){
                    p = p.firstChild;
                }
                if(cont == 1){
                    section = [p content];
                }else{
                    item = [p content];
                }

            }
            section = [[section lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                     withString:[[section substringToIndex:1] uppercaseString]];
            
            item = [item stringByReplacingOccurrencesOfString:@" " withString:@""];
            item = [item stringByReplacingOccurrencesOfString:@"/" withString:@","];
            NSMutableArray *itens = [[NSMutableArray alloc] init];
            for (NSString *i in [item componentsSeparatedByString:@","]) {
                
                NSString *trimmed = [i stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                trimmed = [[trimmed lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                           withString:[[trimmed substringToIndex:1] uppercaseString]];
                [itens addObject: trimmed];
            }
            [cardapio addSection:section withItens:itens];
            
        }
    }
    return cardapio;
}

-(void)stop{
    [operation cancel];
}

@end
