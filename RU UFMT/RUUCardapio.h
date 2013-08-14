//
//  RUUCardapio.h
//  RUUFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUUCardapio : NSObject{
    NSMutableArray *sections;
    NSMutableDictionary *itens;
}

-(void) addSection:(NSString *) section withItens:(NSArray *) sectionItens;
-(void) removeSection:(NSString *) section;
-(NSInteger) sectionsCount;
-(NSString *) sectionAtIndex:(NSInteger) index;
-(NSInteger) itenCountInSectionIndex:(NSInteger) section;
-(NSInteger) itenCountInSection:(NSString *) section;
-(NSString *) itenAtSectionIndex:(NSInteger) section andIndex:(NSInteger) iten;

@end
