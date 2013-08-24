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
#import <FlatUIKit/UIToolbar+FlatUI.h>
#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import <FlatUIKit/UITableViewCell+FlatUI.h>
#import <FlatUIKit/FUIAlertView.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>

@interface RUUViewController (){
    RUUCardapio *cardapioLunch;
    RUUCardapio *cardapioDinner;
    RUUCardapio *actualCardapio;
    NSDate *lastDate;
    NSDate *cardapioDate;
}

@end

@implementation RUUViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view = [self tableView];
    cardapioLunch = [[RUUCardapio alloc] init];
    cardapioDinner = [[RUUCardapio alloc] init];
    lastDate = nil;
    actualCardapio = cardapioLunch;
    
    /*
    //Dados de Teste
    [cardapioLunch addSection:@"Salada" withItens:@[@"Couve",@"Cenoura"]];
    [cardapioLunch addSection:@"Acompanhamento" withItens:@[@"Arroz",@"Feijão"]];
    
    [cardapioDinner addSection:@"Salada" withItens:@[@"Couve-Flor",@"Beterraba"]];
    [cardapioDinner addSection:@"Acompanhamento" withItens:@[@"Macarrão",@"Batata"]];
    [cardapioDinner addSection:@"Sobremesa" withItens:@[@"Pudim"]];
    */
     
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor cloudsColor],UITextAttributeTextColor, nil];
    self.navigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor peterRiverColor]];
    
    
    [self.navigationController.toolbar configureFlatToolbarWithColor:[UIColor peterRiverColor]];
        
    self.segControlCardapio.selectedFont = [UIFont boldFlatFontOfSize:16];
    self.segControlCardapio.selectedFontColor = [UIColor cloudsColor];
    self.segControlCardapio.deselectedFont = [UIFont flatFontOfSize:16];
    self.segControlCardapio.deselectedFontColor = [UIColor cloudsColor];
    self.segControlCardapio.selectedColor = [UIColor midnightBlueColor];
    self.segControlCardapio.deselectedColor = [UIColor silverColor];
    self.segControlCardapio.dividerColor = [UIColor midnightBlueColor];
    self.segControlCardapio.cornerRadius = 5.0;
    
    self.tableView.backgroundColor = [UIColor cloudsColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self updateRefreshText:NO];
    [self.refreshControl addTarget:self
                         action:@selector(refreshControlActivated)
                         forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor peterRiverColor]];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RUUFMTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor cloudsColor];
        /*
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor cloudsColor]
                                             selectedColor:[UIColor midnightBlueColor]
                                                     style:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier];
        
        cell.cornerRadius = 5.0f;
        cell.separatorHeight = 2.0f;
        */
    }
    cell.textLabel.text = [actualCardapio itenAtSectionIndex:indexPath.section andIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor midnightBlueColor];
    cell.textLabel.font = [UIFont boldFlatFontOfSize:16.0f];
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if(sectionTitle == nil){
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldFlatFontOfSize:18];
    label.frame = CGRectMake(8,8, 320, 20);
    label.backgroundColor = [UIColor peterRiverColor];
    label.textColor = [UIColor cloudsColor];
    label.text = sectionTitle;
    label.textAlignment = NSTextAlignmentLeft;
    
    UIView *view = [[UIView alloc]init];
    [view addSubview:label];
    view.backgroundColor = [UIColor peterRiverColor];
    
    return view;
}

-(void) refreshControlActivated{
    [self setUpdatingState];
    RUUScrapingCardapioTask *task = [[RUUScrapingCardapioTask alloc] init];
    [task setSuccesBlock:^(RUUCardapio *cLunch,RUUCardapio *cDinner,NSDate *date){
        cardapioLunch = cLunch;
        cardapioDinner = cDinner;
        
        lastDate = [NSDate new];
        cardapioDate = date;
        [self updateRefreshText:YES];
        [self segControlOnChange:self.segControlCardapio];
        
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Ocorreu algum erro"
                                                        message:@"Provavelmente sua internet está ruim"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];

        alert.titleLabel.textColor = [UIColor cloudsColor];
        alert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        alert.messageLabel.textColor = [UIColor cloudsColor];
        alert.messageLabel.font = [UIFont boldFlatFontOfSize:16];
        alert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        alert.alertContainer.backgroundColor = [UIColor peterRiverColor];
        alert.defaultButtonColor = [UIColor midnightBlueColor];
        alert.defaultButtonShadowColor = [UIColor asbestosColor];
        alert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        alert.defaultButtonTitleColor = [UIColor cloudsColor];
        
        [alert show];        
        [self updateRefreshText:NO];
        
        [self.refreshControl endRefreshing];
    }];
    [task start];
}

-(void) setUpdatingState{
    
    NSString *text = @"Atualizando";
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:text];
    NSInteger stringLength= [text length];    
    UIColor *black =[UIColor midnightBlueColor];
    UIFont *font =[UIFont boldFlatFontOfSize:14.0f];
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:black range:NSMakeRange(0, stringLength)];
    [self.refreshControl setAttributedTitle:attString];

}

-(void) updateRefreshText:(BOOL) updated{
    
    NSString *output = @"";
    NSString *text = nil;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if(updated){
        text = @"Atualizado";        
        [df setDateFormat:@"   dd/MM/yyyy HH:mm"];
        output = [text stringByAppendingString:[df stringFromDate:lastDate]];
    }else{
        if(lastDate != nil){
            text = @"Ultima Atualização";
            [df setDateFormat:@"   dd/MM/yyyy HH:mm"];
            output = [text stringByAppendingString:[df stringFromDate:lastDate]];
        }else{
            text = @"Não Atualizado";
            output = text;
        }
    }
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:output];
    NSInteger stringLength= [text length];
    
    UIColor *black =[UIColor midnightBlueColor];
    UIFont *font =[UIFont boldFlatFontOfSize:14.0f];
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:black range:NSMakeRange(0, stringLength)];
    
    if(cardapioDate != nil){
        [df setDateFormat:@" dd/MM EEEE"];
        [self.navigationItem setTitle:[NSString stringWithFormat:@"RU UFMT - %@",[df stringFromDate:cardapioDate]]];
    }else{
        [self.navigationItem setTitle:@"RU UFMT"];
    }
    [self.refreshControl setAttributedTitle:attString];
    
}

- (IBAction)segControlOnChange:(UISegmentedControl *)sender {
    int index = [sender selectedSegmentIndex];
    if(index == 0){
        actualCardapio = cardapioLunch;
    }else{
        actualCardapio = cardapioDinner;
    }
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    //NSLog(@"Encoding");
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:cardapioLunch forKey:@"cardapioLunch"];
    [coder encodeObject:cardapioDinner forKey:@"cardapioDinner"];
    [coder encodeObject:lastDate forKey:@"lastDate"];
    [coder encodeObject:cardapioDate forKey:@"cardapioDate"];
    
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    //NSLog(@"Decoding");
    [super decodeRestorableStateWithCoder:coder];
    
    cardapioLunch = [coder decodeObjectForKey:@"cardapioLunch"];
    cardapioDinner = [coder decodeObjectForKey:@"cardapioDinner"];
    lastDate = [coder decodeObjectForKey:@"lastDate"];
    cardapioDate = [coder decodeObjectForKey:@"cardapioDate"];
    
    //NSLog(@" %@ ",[cardapioLunch sectionAtIndex:0]);
    
    [self updateRefreshText:NO];
    [self segControlOnChange:self.segControlCardapio];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
