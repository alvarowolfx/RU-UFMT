//
//  RUUViewController.h
//  RUUFMT
//
//  Created by Alvaro Viebrantz on 12/08/13.
//  Copyright (c) 2013 UFMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FUISegmentedControl.h>
#import <iAd/iAd.h>

@interface RUUViewController : UITableViewController <ADBannerViewDelegate>{
    ADBannerView *_adBannerView;
    BOOL _adBannerViewIsVisible;
}

@property (weak, nonatomic) IBOutlet FUISegmentedControl *segControlCardapio;
- (IBAction)segControlOnChange:(FUISegmentedControl *)sender;

@end
