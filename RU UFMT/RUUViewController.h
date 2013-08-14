//
//  RUUViewController.h
//  RUUFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUUViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlCardapio;
- (IBAction)segControlOnChange:(UISegmentedControl *)sender;

@end
