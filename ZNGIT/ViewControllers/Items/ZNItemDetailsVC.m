//
//  ZNItemDetailsVC.m
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNItemDetailsVC.h"
#import "HCSStarRatingView.h"
#import <MapKit/MapKit.h>
#import "JTSImageViewController.h"
#import "ZNUtils.h"
#import "ZNBookItemVC.h"
#import "NSDate+DateTools.h"
#import "ZNItemDetailsNC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZNRoundLabel.h"

#define TITLE @"ITEM DETAILS"

@interface ZNItemDetailsVC () <UIScrollViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *pricePerDayLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *pricePerHourLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *monOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *friOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *satOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopEmailLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)addressButtonClicked:(id)sender;
- (IBAction)reviewsButtonClicked:(id)sender;
@end

@implementation ZNItemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setNavigationBarTitle:TITLE];
    [self setNavigationBackButtonItemAsDismiss];
    
    _item = ((ZNItemDetailsNC*)self.navigationController).item;
    _imagePageControl.hidden = YES;
    
    _pricePerDayLabel.layer.borderWidth = 1.0f;
    _pricePerDayLabel.layer.borderColor = ZNGIT_MAIN_COLOR.CGColor;
    
    _pricePerHourLabel.layer.borderWidth = 1.0f;
    _pricePerHourLabel.layer.borderColor = ZNGIT_MAIN_COLOR.CGColor;
    
//    _ratingView.maximumValue = 5;
//    _ratingView.minimumValue = 0;
//    _ratingView.allowsHalfStars = YES;
//    _ratingView.value = 4.5;
//    _ratingView.tintColor = UIColorFromRGB(0xFFD42D);
    
    _continueButton.layer.cornerRadius = _continueButton.frame.size.height / 2;
    

    [self performSelector:@selector(loadImages) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [self loadMap];
    [self loadData];
}

- (void)loadData
{
    _nameLabel.text = _item.name;
    _pricePerDayLabel.text = [NSString stringWithFormat:@"$%.2f per day", [_item.pricePerDay doubleValue]];
    _pricePerHourLabel.text = [NSString stringWithFormat:@"$%.2f per hour", [_item.pricePerHour doubleValue]];
    
    
    ZNShop *shop = _item.shop;
    ZNAddress *address = shop.address;
    _shopNameLabel.text = shop.name;
    _shopStreetLabel.text = address.street;
    _shopCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", address.city, address.state, address.zip];
    
    _monOpenTimeLabel.text = shop.openTimeMon&&[shop.openTimeMon intValue]!=0&&shop.closeTimeMon&&[shop.closeTimeMon intValue]!=0?[NSString stringWithFormat:@"Mon: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeMon intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeMon intValue]]]:@"Mon: ";
    _tueOpenTimeLabel.text = shop.openTimeTue&&[shop.openTimeTue intValue]!=0&&shop.closeTimeTue&&[shop.closeTimeTue intValue]!=0?[NSString stringWithFormat:@"Tue: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeTue intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeTue intValue]]]:@"Tue: ";
    _wedOpenTimeLabel.text = shop.openTimeWed&&[shop.openTimeWed intValue]!=0&&shop.closeTimeWed&&[shop.closeTimeWed intValue]!=0?[NSString stringWithFormat:@"Wed: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeWed intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeWed intValue]]]:@"Wed: ";
    _thuOpenTimeLabel.text = shop.openTimeThu&&[shop.openTimeThu intValue]!=0&&shop.closeTimeThu&&[shop.closeTimeThu intValue]!=0?[NSString stringWithFormat:@"Thu: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeThu intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeThu intValue]]]:@"Thu: ";
    _friOpenTimeLabel.text = shop.openTimeFri&&[shop.openTimeFri intValue]!=0&&shop.closeTimeFri&&[shop.closeTimeFri intValue]!=0?[NSString stringWithFormat:@"Fri: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeFri intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeFri intValue]]]:@"Fri: ";
    _satOpenTimeLabel.text = shop.openTimeSat&&[shop.openTimeSat intValue]!=0&&shop.closeTimeSat&&[shop.closeTimeSat intValue]!=0?[NSString stringWithFormat:@"Sat: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeSat intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeSat intValue]]]:@"Sat: ";
    _sunOpenTimeLabel.text = shop.openTimeSun&&[shop.openTimeSun intValue]!=0&&shop.closeTimeSun&&[shop.closeTimeSun intValue]!=0?[NSString stringWithFormat:@"Sun: %@ - %@", [NSDate formattedTimeFromMinutes:[shop.openTimeSun intValue]], [NSDate formattedTimeFromMinutes:[shop.closeTimeSun intValue]]]:@"Sun: ";
    
    _shopPhoneLabel.text = shop.phone;
    _shopEmailLabel.text = shop.email;
    
}
- (void)loadMap
{
    // 1
    CLLocationCoordinate2D location = _item.shop.address.location;
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
- (void)loadImages
{
    NSArray *imageUrls = _item.imageUrls;
    
    CGRect workingFrame = _imageScrollView.frame;
    workingFrame.origin.x = workingFrame.origin.y = 0;
    
    for(NSString *url in imageUrls)
    {
        UIImage *placeholder = [UIImage imageNamed:@"placeholder.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:placeholder];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.frame = workingFrame;
        
        [_imageScrollView addSubview:imageView];
        
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        
        
        // Set tap gesture to image
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionOnImage:)];
        [imageView addGestureRecognizer:gestureRecognizer];
    }
    
    if(workingFrame.origin.x > 0)
    {
        [_imageScrollView setPagingEnabled:YES];
        [_imageScrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
        
        _imagePageControl.numberOfPages = workingFrame.origin.x / _imageScrollView.frame.size.width;
        _imagePageControl.currentPage = 0;
        _imagePageControl.hidden = imageUrls.count<=1;
        
    }
}

- (void)tapActionOnImage:(UITapGestureRecognizer*)gestureRecognizer
{
    UIImageView *imageView = (UIImageView*)gestureRecognizer.view;
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _imageScrollView) {
        
        
        CGFloat offset = scrollView.contentOffset.x;
        
        NSInteger index = offset / _imageScrollView.frame.size.width;
        
        _imagePageControl.currentPage = index;
    }
}

- (IBAction)addressButtonClicked:(id)sender {
    _shopNameLabel.alpha = 0; _shopStreetLabel.alpha = 0; _shopCityLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _shopNameLabel.alpha = 1; _shopStreetLabel.alpha = 1; _shopCityLabel.alpha = 1;
                     }
                     completion:nil];
    
    CLLocationCoordinate2D location = _item.shop.address.location;
    //location.latitude = 39.281516;
    //location.longitude= -76.580806;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = _item.shop.name;
    [item openInMapsWithLaunchOptions:nil];
}

- (IBAction)reviewsButtonClicked:(id)sender {
    if ([ZNUtils isYelpInstalled]) {
        // Call into the Yelp app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"yelp5.3:///biz/the-sentinel-san-francisco"]];
    } else {
        // Use the Yelp touch site
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yelp.com/biz/the-sentinel-san-francisco"]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    if([segueIdentifier isEqualToString:@"BookItemSegue"])
    {
        ZNBookItemVC *vc = segue.destinationViewController;
        
        vc.item = [ZNBookItem initWithRentalItem:self.item];
    }
}
@end
