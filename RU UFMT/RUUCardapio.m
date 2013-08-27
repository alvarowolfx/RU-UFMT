//
//  RUUCardapio.m
//  RUUFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import "RUUCardapio.h"

@implementation RUUCardapio

- (id)init
{
    self = [super init];
    if (self) {
        sections = [[NSMutableArray alloc] init];
        itens = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (RUUCardapio *) cardapioFromArrayOfDictionary: (NSArray *) dicts{
    RUUCardapio *cardapio = [[RUUCardapio alloc] init];
    for (NSDictionary *d in dicts) {
        [d enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSArray *value, BOOL *stop) {
            if([value count] > 0)
                [cardapio addSection:key withItens:value];
        }];
    }
    return cardapio;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:sections forKey:@"sections"];
    [aCoder encodeObject:itens forKey:@"itens"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        sections = [aDecoder decodeObjectForKey:@"sections"];
        itens = [aDecoder decodeObjectForKey:@"itens"];
    }
    
    return self;
}

-(void) addSection:(NSString *) section withItens:(NSArray *) sectionItens{
    
    int index = [sections indexOfObject:section];
    if( index == NSNotFound){
        [sections addObject:section];
        [itens setValue:sectionItens forKey:section];
    }else{
        [itens setValue:sectionItens forKey:section];
    }
    
}

-(void) removeSection:(NSString *) section{
    [sections removeObject:section];
    [itens removeObjectForKey:section];
}

-(NSString *)sectionAtIndex:(NSInteger)index{
    return [sections objectAtIndex:index];
}

-(NSInteger)sectionsCount{
    return sections.count;
}

-(NSString *) itenAtSectionIndex:(NSInteger) section andIndex:(NSInteger) iten{
    return [[itens objectForKey:[sections objectAtIndex:section]] objectAtIndex:iten];
}

-(NSInteger)itenCountInSection:(NSString *)section{
    return [[itens objectForKey:section] count];
}

-(NSInteger)itenCountInSectionIndex:(NSInteger)section{
    return [[itens objectForKey:[sections objectAtIndex:section]] count];
}

@end
