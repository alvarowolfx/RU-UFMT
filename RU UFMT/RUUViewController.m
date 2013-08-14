//
//  RUUViewController.m
//  RU UFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import "RUUViewController.h"
#import "RUUCardapio.h"
#import "RUUScrapingCardapioTask.h"

@interface RUUViewController (){
    RUUCardapio *cardapioLunch;
    RUUCardapio *cardapioDinner;
    RUUCardapio *actualCardapio;
}

@end

@implementation RUUViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view = [self tableView];
    cardapioLunch = [[RUUCardapio alloc] init];
    cardapioDinner = [[RUUCardapio alloc] init];
    
    /*
    [cardapioLunch addSection:@"Salada" withItens:@[@"Couve",@"Cenoura"]];
    [cardapioLunch addSection:@"Acompanhamento" withItens:@[@"Arroz",@"Feijão"]];
    
    [cardapioDinner addSection:@"Salada" withItens:@[@"Couve-Flor",@"Beterraba"]];
    [cardapioDinner addSection:@"Acompanhamento" withItens:@[@"Macarrão",@"Batata"]];
    [cardapioDinner addSection:@"Sobremesa" withItens:@[@"Pudim"]];
    */
    
    [self setRefreshText:@"Não Atualizado"];
    [self.refreshControl addTarget:self
                         action:@selector(refreshControlActivated)
                         forControlEvents:UIControlEventValueChanged];
    
    actualCardapio = cardapioLunch;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RUUFMTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [actualCardapio itenAtSectionIndex:indexPath.section andIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [actualCardapio itenCountInSectionIndex:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [actualCardapio sectionsCount];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [actualCardapio sectionAtIndex:section];
}

-(void) refreshControlActivated{
    [self setRefreshText:@"Atualizando"];
    RUUScrapingCardapioTask *task = [[RUUScrapingCardapioTask alloc] init];
    [task setSuccesBlock:^(RUUCardapio *cLunch,RUUCardapio *cDinner,NSDate *date){
        cardapioLunch = cLunch;
        cardapioDinner = cDinner;
        
        [self setRefreshText:@"Atualizado" withDate:[NSDate new]];
        [self segControlOnChange:self.segControlCardapio];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        NSLog(@" Miooou %@ ",error);
    }];
    [task start];
}

-(void) setRefreshText:(NSString *) text withDate:(NSDate *) date{
    
    NSString *output = @"";
    if(date != nil){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"   dd/MM/yyyy hh:mm:ss"];
        output = [text stringByAppendingString:[df stringFromDate:date]];
    }else{
        output = text;
    }
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:output];
    NSInteger stringLength= [text length];
    
    UIColor *black =[UIColor blackColor];
    UIFont *font =[UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:black range:NSMakeRange(0, stringLength)];
    
    [self.refreshControl setAttributedTitle:attString];
    [self.refreshControl setTintColor:[UIColor blackColor]];
}

-(void) setRefreshText:(NSString *) text{
    [self setRefreshText:text withDate:nil];
}

- (IBAction)segControlOnChange:(UISegmentedControl *)sender {
    int index = [sender selectedSegmentIndex];
    if(index == 0){
        actualCardapio = cardapioLunch;
        //update view
    }else{
        actualCardapio = cardapioDinner;
        //update view
    }
    //[self.tableView reloadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
