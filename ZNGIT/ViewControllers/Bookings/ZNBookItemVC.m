//
//  ZNBookItemVC.m
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNBookItemVC.h"
#import "NSDate+DateTools.h"
#import "ZNOrderDetailsVC.h"
#import "ZNSettingsManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZNRoundLabel.h"
#import "AppDelegate.h"

#define TITLE @"BOOK ITEM"

@interface ZNBookItemVC ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityUnitLabel;

@property (weak, nonatomic) IBOutlet UIView *hourlySelectionView;
@property (weak, nonatomic) IBOutlet UIImageView *hourlyImageView;
@property (weak, nonatomic) IBOutlet UILabel *hourlyLabel;
@property (weak, nonatomic) IBOutlet UIView *dailySelectionView;
@property (weak, nonatomic) IBOutlet UIImageView *dailyImageView;
@property (weak, nonatomic) IBOutlet UILabel *dailyLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateDecreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *dateIncreaseButton;
@property (weak, nonatomic) IBOutlet UILabel *weakDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *returnDateView;
@property (weak, nonatomic) IBOutlet UILabel *returnWeekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (weak, nonatomic) IBOutlet UIView *rentalHoursView;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursUnitLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;


- (IBAction)quantityIncreaseButtonClicked:(id)sender;
- (IBAction)quantityDecreaseButtonClicked:(id)sender;
- (IBAction)dateDecreaseButtonClicked:(id)sender;
- (IBAction)dateIncreaseButtonClicked:(id)sender;
- (IBAction)returnDateDecreaseButtonClicked:(id)sender;
- (IBAction)returnDateIncreaseButtonClicked:(id)sender;
- (IBAction)rentalHoursDecreaseButtonClicked:(id)sender;
- (IBAction)rentalHoursIncreaseButtonClicked:(id)sender;

- (IBAction)hourlyButtonClicked:(id)sender;
- (IBAction)dailyButtonClicked:(id)sender;


@property (nonatomic, assign) BookingType selectedType;
@property (nonatomic, strong) NSDate *originPickupDate;
@end

@implementation ZNBookItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:TITLE withIcon:[UIImage imageNamed:@"step1_4.png"] iconPosition:ZNNavTitleIconDown];
    [self setNavigationBackButtonItem];

    _subtotalLabel.layer.borderWidth = 1.0f;
    _subtotalLabel.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _hourlySelectionView.layer.cornerRadius = 5.0f;
    _dailySelectionView.layer.cornerRadius = 5.0f;
    _continueButton.layer.cornerRadius = _continueButton.frame.size.height/2;
    
    _originPickupDate = _item.pickupDate;
    [self updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateData
{
    NSArray *imageUrls = _item.rentalItem.imageUrls;
    if(imageUrls && imageUrls.count)
    {
        NSString* imageUrl = imageUrls[0];
        [_photoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    _nameLabel.text = _item.rentalItem.name;
    //_subtotalLabel.text = [NSString stringWithFormat:@"$%.2f", [_item.rentalItem.pricePerDay doubleValue]];
    _shopNameLabel.text = _item.rentalItem.shop.name;
    _quantityLabel.text = [NSString stringWithFormat:@"%@", _item.quantity];
    _quantityUnitLabel.text = [_item.quantity integerValue]>1 ? @"Items" : @"Item";
    
    _weakDayLabel.text = [_item.pickupDate formattedDateWithFormat:@"EEEE"];
    _dateLabel.text = [_item.pickupDate formattedDateWithFormat:@"MMM d, YYYY"];
    
    _returnWeekDayLabel.text = [_item.returnDate formattedDateWithFormat:@"EEEE"];
    _returnDateLabel.text = [_item.returnDate formattedDateWithFormat:@"MMM d, YYYY"];
    
    _rentalHoursLabel.text = [NSString stringWithFormat:@"%@", _item.rentalHours];
    _rentalHoursUnitLabel.text = [_item.rentalHours integerValue]>1 ? @"Hours" : @"Hour";
    
    [self selectBookingType:_item.type];
}

- (void)selectBookingType:(BookingType)type
{
    _selectedType = type;
    
    if(_selectedType == Daily)
    {
        _hourlySelectionView.layer.borderWidth = 1.0f;
        _hourlySelectionView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
        _hourlySelectionView.backgroundColor = [UIColor whiteColor];
        _hourlyImageView.image = [UIImage imageNamed:@"clock_lightgray.png"];
        _hourlyLabel.textColor = UIColorFromRGB(0xCBCBCB);
        
        _dailySelectionView.layer.borderWidth = 0.0f;
        _dailySelectionView.backgroundColor = UIColorFromRGB(0xF5A623);
        _dailyImageView.image = [UIImage imageNamed:@"calendar_white.png"];
        _dailyLabel.textColor = [UIColor whiteColor];
        
        _rentalHoursView.hidden = YES;
        _returnDateView.hidden = NO;
    }
    else if(_selectedType == Hourly)
    {
        _hourlySelectionView.layer.borderWidth = 0.0f;
        _hourlySelectionView.backgroundColor = UIColorFromRGB(0xF5A623);
        _hourlyImageView.image = [UIImage imageNamed:@"clock_white.png"];
        _hourlyLabel.textColor = [UIColor whiteColor];
        
        _dailySelectionView.layer.borderWidth = 1.0f;
        _dailySelectionView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
        _dailySelectionView.backgroundColor = [UIColor whiteColor];
        _dailyImageView.image = [UIImage imageNamed:@"calendar_lightgray.png"];
        _dailyLabel.textColor = UIColorFromRGB(0xCBCBCB);
        
        _returnDateView.hidden = YES;
        _rentalHoursView.hidden = NO;
    }
    
    
    _subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: $%.2f", [_item getSubTotalPrice]];
}


- (IBAction)quantityIncreaseButtonClicked:(id)sender {
    NSInteger quantity = [_item.quantity integerValue];
    
    _item.quantity = @(++quantity);
    [self updateData];
}

- (IBAction)quantityDecreaseButtonClicked:(id)sender {
    NSInteger quantity = [_item.quantity integerValue];
    
    if(quantity == 1) return;
    
    _item.quantity = @(--quantity);
    
    [self updateData];

}

- (IBAction)dateDecreaseButtonClicked:(id)sender {
    NSInteger diff = [_item.pickupDate daysFrom:_originPickupDate];
    if(diff <= 0) return;
    _item.pickupDate = [_item.pickupDate dateBySubtractingDays:1];
    [self updateData];
}

- (IBAction)dateIncreaseButtonClicked:(id)sender {
    if([_item.returnDate daysFrom:_item.pickupDate]<=0) return;
    _item.pickupDate = [_item.pickupDate dateByAddingDays:1];
    [self updateData];
}

- (IBAction)returnDateDecreaseButtonClicked:(id)sender {
    if([_item.returnDate daysFrom:_item.pickupDate]<=0) return;
    _item.returnDate = [_item.returnDate dateBySubtractingDays:1];
    [self updateData];
}

- (IBAction)returnDateIncreaseButtonClicked:(id)sender {
    _item.returnDate = [_item.returnDate dateByAddingDays:1];
    [self updateData];
}

- (IBAction)rentalHoursDecreaseButtonClicked:(id)sender {
    NSInteger rentalHours = [_item.rentalHours integerValue];
    
    if(rentalHours==1) return;
    
    _item.rentalHours = @(--rentalHours);
    [self updateData];
}

- (IBAction)rentalHoursIncreaseButtonClicked:(id)sender {
    NSInteger rentalHours = [_item.rentalHours integerValue];
    
    _item.rentalHours = @(++rentalHours);
    [self updateData];
}

- (IBAction)hourlyButtonClicked:(id)sender {
    _item.type = Hourly;
    [self updateData];
}

- (IBAction)dailyButtonClicked:(id)sender {
    _item.type = Daily;
    [self updateData];

}


- (IBAction)btnContinueClicked:(id)sender
{
    ZNUser *currentUser = [AppDelegate sharedInstance].currentUser;
    if(currentUser.id)
    {
        ZNOrderDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNOrderDetailsVC"];
        
        vc.item = self.item;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"NeedLoginNC"];
        
        [self presentViewController:nc animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationSignInSucceeded:) name:ZN_NOTIFICATION_SIGN_IN_SUCCEEDED object:nil];
        }];
    }
}

- (void)handlerForNotificationSignInSucceeded:(NSNotification*)notification
{
    ZNOrderDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNOrderDetailsVC"];
    
    vc.item = self.item;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
