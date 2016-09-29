//
//  ZNOrderDetails.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNOrderDetailsVC.h"
#import "NSDate+DateTools.h"
#import "ZNPaymentMethodsVC.h"
#import "ZNSetPickupTimeVC.h"
#import "ZNAPIManager.h"
#import "ZNSettingsManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import "ZNRoundLabel.h"
#import "ZNAlertManager.h"

#define TITLE @"ORDER DETAILS"

@interface ZNOrderDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *renterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalFeePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continueButtonClicked:(id)sender;

@end

@implementation ZNOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:TITLE withIcon:[UIImage imageNamed:@"step2_4.png"] iconPosition:ZNNavTitleIconDown];
        
    
    [self setNavigationBackButtonItem];
    
    _totalLabel.layer.borderWidth = 1.0f;
    _totalLabel.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    
    _continueButton.layer.cornerRadius = _continueButton.frame.size.height/2;
    
    _item.renter = [AppDelegate sharedInstance].currentUser;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrimaryCardChanged:) name:ZN_NOTIFICATION_PRIMARY_CREDIT_CARD_CHANGED object:nil];
    
    
    
    [self updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePrimaryCardChanged:(NSNotification*)notification
{
    [self updateCardData];
}

- (void)updateCardData
{
    NSDictionary *cardData = [[ZNSettingsManager sharedInstance] getPrimaryCreditCard];
    
    _item.cardData = cardData;
    
    NSString *cardNumber = cardData[@"number"];
    _item.cardLast4 = cardNumber ? [cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)] : nil;
    _item.cardBrand = cardData[@"brand"] ? cardData[@"brand"] : nil;
    
    
    if(_item.cardBrand && _item.cardLast4)
    {
        _cardNumberLabel.text = [NSString stringWithFormat:@"%@•%@", _item.cardBrand, _item.cardLast4];
    }
    else
    {
        _cardNumberLabel.text = @"Add a Payment Method";
    }
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
    _totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", [_item getTotalPrice]];
    _shopNameLabel.text = _item.rentalItem.shop.name;
    
    _renterNameLabel.text = _item.renter.fullname;
    
    
    _itemNameLabel.text = _item.rentalItem.name;
    
    _bookingTypeLabel.text = _item.type==Daily?@"Daily":@"Hourly";
    
    _dateLabel.text = [_item.pickupDate formattedDateWithFormat:@"EEE, MMM d"];
    
    _returnDateLabel.text = [_item.returnDate formattedDateWithFormat:@"EEE, MMM d"];
    _rentalHoursLabel.text = [NSString stringWithFormat:@"%@ %@", _item.rentalHours, [_item.rentalHours integerValue]>1?@"hours":@"hour"];
    
    _returnDateMarkLabel.hidden = _returnDateLabel.hidden = _item.type==Hourly;
    
    _rentalHoursMarkLabel.hidden = _rentalHoursLabel.hidden = _item.type==Daily;
    
    if(_item.cardBrand && _item.cardLast4)
        _cardNumberLabel.text = [NSString stringWithFormat:@"%@•%@", _item.cardBrand, _item.cardLast4];
    
    double subTotalPrice = [_item getSubTotalPrice];
    _subtotalPriceLabel.text = [NSString stringWithFormat:@"$%.2f", subTotalPrice];
    _serviceFeePriceLabel.text = [NSString stringWithFormat:@"$%.2f", subTotalPrice*5/100];
    _rentalFeePriceLabel.text = [NSString stringWithFormat:@"$%.2f", RENTAL_SERVICE_FEE];
    _totalPriceLabel.text = [NSString stringWithFormat:@"$%.2f", [_item getTotalPrice]];
    
    [self updateCardData];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    if([segueIdentifier isEqualToString:@"PaymentMethodsSegue"])
    {
        ZNPaymentMethodsVC *vc = segue.destinationViewController;
    }
}

- (IBAction)continueButtonClicked:(id)sender
{
    if (_item.cardData == nil)
    {
        [ZNAlertManager showAlertWithTitle:nil message:@"Please add a payment method to confirm your order" btnTitle:@"Got it" controller:self];
        
        return;
    }
    
    ZNSetPickupTimeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSetPickupTimeVC"];
    
    vc.item = self.item;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
