//
//  RUUViewController.h
//  RUUFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FUISegmentedControl.h>

@interface RUUViewController : UITableViewController

@property (weak, nonatomic) IBOutlet FUISegmentedControl *segControlCardapio;
- (IBAction)segControlOnChange:(FUISegmentedControl *)sender;

@end
