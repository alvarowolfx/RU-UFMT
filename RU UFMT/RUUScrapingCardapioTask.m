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
        
        NSError* error = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@".*([0-9]{1,2}[/][0-9]{1,2}[/][0-9]{2,4}).*"            options:0 error:&error];
        
        NSDate *dateFromSite = nil;
        for (TFHppleElement *element in ufmtNodes) {
            NSString *searchedString = [element text];
            NSArray *matches = [regex matchesInString:searchedString options:0 range:NSMakeRange(0, [searchedString length])];
            if([matches count] > 0){
                int idx = [searchedString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location;
                NSString* matchText = [searchedString substringWithRange:NSMakeRange(0, idx)];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd/MM/yy"];
                dateFromSite = [df dateFromString:matchText];
                //NSLog(@" %@, %@ " ,searchedString,matchText);

            }
            
        }        
        ufmtNodes = [ufmtParser searchWithXPathQuery:@"//div[@id='secao']//table"];
        
        if([ufmtNodes count] >= 1){
            //NSLog(@" pegou tabelas");
            RUUCardapio *c1 = [self_ cardapioFromTable:[ufmtNodes objectAtIndex:0]];
            RUUCardapio *c2 = [[RUUCardapio alloc] init];
            if([ufmtNodes count] >= 2){
                c2 = [self_ cardapioFromTable:[ufmtNodes objectAtIndex:1]];
            }
            if(self.successBlock != NULL){
                //NSLog(@" chamndo sucesso !!!");
                self.successBlock(c1,c2,dateFromSite);
            }else{
                //NSLog(@" sucesso não setado =/ ");
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
                //TFHppleElement *p = td.firstChild;
                //TFHppleElement *p = [td.children lastObject];
                if ([td.firstChild tagName] == nil) continue;
                NSMutableString *ctn = [[NSMutableString alloc] init];
                for (TFHppleElement *el in td.children) {
                    TFHppleElement *p = el;
                    if ([p tagName] == nil) continue;
                    while(p.hasChildren){
                        p = p.firstChild;
                    }
                    [ctn appendString:[p content]];
                }
                /*
                if ([p tagName] == nil) continue;
                cont++;
                while(p.hasChildren){
                    p = p.firstChild;
                }
                */
                cont++;
                if(cont == 1){
                    section = ctn;
                }else{
                    item = ctn;
                }

            }
            //NSLog(@"secao : %@ , item : %@ ",section,item );
            if([[section stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                continue;
            }
            
            section = [[section lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                     withString:[[section substringToIndex:1] uppercaseString]];
            
            if([[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                //[cardapio addSection:section withItens:[NSArray array]];
                continue;
            }
            
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
