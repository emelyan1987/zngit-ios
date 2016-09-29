//
//  ZNOrderDetails.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNOrderDetailsViewVC.h"
#import "NSDate+DateTools.h"
#import "ZNAPIManager.h"
#import "ZNSettingsManager.h"
#import <MapKit/MapKit.h>
#import "ZNOrderDetailsViewNC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MessageUI/MessageUI.h>
#import "ZNAlertManager.h"

#define TITLE @"ORDER DETAILS"

@interface ZNOrderDetailsViewVC () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopEmailLabel;

@property (weak, nonatomic) IBOutlet UILabel *renterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalHoursMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalFeePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


- (IBAction)addressButtonClicked:(id)sender;

- (IBAction)actionButtonClicked:(id)sender;

@end

@implementation ZNOrderDetailsViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:TITLE];
    [self setNavigationBackButtonItemAsDismiss];
    
    _priceView.layer.borderWidth = 1.0f;
    _priceView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _priceView.layer.cornerRadius = 5.0f;
    
    _dateView.layer.borderWidth = 1.0f;
    _dateView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _dateView.layer.cornerRadius = 5.0f;
    
    
    _item = ((ZNOrderDetailsViewNC*)self.navigationController).item;
    
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
    _priceLabel.text = [NSString stringWithFormat:@"$%.2f    ", [_item getTotalPrice]];
    _dateLabel.text = [_item.pickupDate formattedDateWithFormat:@"MMM d"];
    
    ZNShop *shop = _item.rentalItem.shop;
    _shopNameLabel.text = shop.name;
    _shopNameLabel1.text = shop.name;
    _shopStreetLabel.text = shop.address.street;
    _shopCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", shop.address.city, shop.address.state, shop.address.zip];
    _shopPhoneLabel.text = shop.phone;
    _shopEmailLabel.text = shop.email;
    _renterNameLabel.text = _item.renter.fullname;
    
    
    _itemNameLabel.text = _item.rentalItem.name;
    
    _bookingTypeLabel.text = _item.type==Daily?@"Daily":@"Hourly";
    
    _pickupDateLabel.text = [_item.pickupDate formattedDateWithFormat:@"EEE, MMM d"];
    
    _returnDateLabel.text = [_item.returnDate formattedDateWithFormat:@"EEE, MMM d"];
    _rentalHoursLabel.text = _item.rentalHours && ![_item.rentalHours isEqual:[NSNull null]] ? [NSString stringWithFormat:@"%@ %@", _item.rentalHours, [_item.rentalHours integerValue]>1?@"hours":@"hour"] : @"";
    
    _returnDateMarkLabel.hidden = _returnDateLabel.hidden = _item.type==Hourly;
    
    _rentalHoursMarkLabel.hidden = _rentalHoursLabel.hidden = _item.type==Daily;
    
    if(_item.cardBrand && _item.cardLast4)
        _cardNumberLabel.text = [NSString stringWithFormat:@"%@•%@", _item.cardBrand, _item.cardLast4];
    
    double subTotalPrice = [_item getSubTotalPrice];
    _subtotalPriceLabel.text = [NSString stringWithFormat:@"$%.2f", subTotalPrice];
    _serviceFeePriceLabel.text = [NSString stringWithFormat:@"$%.2f", subTotalPrice*5/100];
    _rentalFeePriceLabel.text = [NSString stringWithFormat:@"$%.2f", RENTAL_SERVICE_FEE];
    _totalPriceLabel.text = [NSString stringWithFormat:@"$%.2f", [_item getTotalPrice]];
    
    [self loadMap];
}

- (void)loadMap
{
    // 1
    CLLocationCoordinate2D location = _item.rentalItem.shop.address.location;
    //location.latitude = 39.281516;
    //location.longitude= -76.580806;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    // 4 add annotation
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
    //annotation.title = @"Matthews Pizza";
    //annotation.subtitle = @"Best Pizza in Town";
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"annotation"];
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}
- (IBAction)addressButtonClicked:(id)sender
{
    _shopNameLabel1.alpha = 0; _shopStreetLabel.alpha = 0; _shopCityLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _shopNameLabel1.alpha = 1; _shopStreetLabel.alpha = 1; _shopCityLabel.alpha = 1;
                     }
                     completion:nil];
    
    CLLocationCoordinate2D location = _item.rentalItem.shop.address.location;
    //location.latitude = 39.281516;
    //location.longitude= -76.580806;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = _item.rentalItem.shop.name;
    [item openInMapsWithLaunchOptions:nil];

}

- (IBAction)actionButtonClicked:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *contactAction = [UIAlertAction actionWithTitle:@"Contact Support" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if(![MFMessageComposeViewController canSendText]) {
            [ZNAlertManager showErrorMessage:@"Your device doesn't support SMS!"];
            return;
        }
        // Email Subject
        NSString *emailTitle = @"Need Help Support";
        // Email Content
        NSString *messageBody = @"Hi ZNGIT Support Team!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:ZNGIT_SERVICE_EMAIL];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:contactAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
