//
//  ZNSetPickupTimeVC.m
//  ZNGIT
//
//  Created by LionStar on 3/9/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSetPickupTimeVC.h"
#import "ZNConfirmOrderVC.h"
#import "NSDate+DateTools.h"

#define TITLE @"SET PICKUP TIME"

@interface ZNSetPickupTimeVC()


@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIView *pickupLocationView;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCityLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
- (IBAction)continueButtonClicked:(id)sender;
@end
@implementation ZNSetPickupTimeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle:TITLE withIcon:[UIImage imageNamed:@"step3_4.png"] iconPosition:ZNNavTitleIconDown];
    [self setNavigationBackButtonItem];
    
    _pickupLocationView.layer.borderWidth = 1.0f;
    _pickupLocationView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _pickupLocationView.layer.cornerRadius = 5.0f;
    
    _continueButton.layer.cornerRadius = _continueButton.frame.size.height/2;
    
    [self updateData];
}

- (void)updateData
{
    ZNShop *shop = _item.rentalItem.shop;
    _shopStreetLabel.text = shop.address.street;
    _shopCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", shop.address.city, shop.address.state, shop.address.zip];
    
}
- (IBAction)continueButtonClicked:(id)sender
{
    NSDate *midnight = [[NSDate date] getMidnight];
    
    _item.pickupTime = @([_timePicker.date minutesFrom:midnight]);
    ZNConfirmOrderVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNConfirmOrderVC"];
    
    vc.item = self.item;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
