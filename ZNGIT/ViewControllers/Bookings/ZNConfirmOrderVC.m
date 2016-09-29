//
//  ZNConfirmOrderVC.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNConfirmOrderVC.h"
#import "TTTAttributedLabel.h"
#import "ZNTrackImageView.h"
#import "KGModal.h"
#import "ZNBookingConfirmedVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZNAPIManager.h"
#import "ZNAlertManager.h"
#import "ZNRoundLabel.h"

#define TITLE @"CONFIRM ORDER"

#define TRACKER_START_POINT CGPointMake(12, 10)

@interface ZNConfirmOrderVC () <TTTAttributedLabelDelegate, ZNTrackImageViewDelegate, ZNBookingConfirmedVCDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet ZNTrackImageView *patternImageView;
@property (weak, nonatomic) IBOutlet UIImageView *trackerImageView;

@property (weak, nonatomic) IBOutlet UIView *pickupLocationView;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCityLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *reminder1Label;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (nonatomic, assign) BOOL tracking;
@end

@implementation ZNConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:TITLE withIcon:[UIImage imageNamed:@"step4_4.png"] iconPosition:ZNNavTitleIconDown];
    [self setNavigationBackButtonItem];
    
    _totalLabel.layer.borderWidth = 1.0f;
    _totalLabel.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    
    _pickupLocationView.layer.borderWidth = 1.0f;
    _pickupLocationView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _pickupLocationView.layer.cornerRadius = 5.0f;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:_reminder1Label.attributedText];
    
    NSString *normalString = [attString string];
    NSRange tosRange = [normalString rangeOfString:@"Terms of Service"];
    NSRange ppRange = [normalString rangeOfString:@"Privacy Policy"];
    
    
    [_reminder1Label addLinkToURL:[NSURL URLWithString:@"http://www.zngit.com/terms-of-service"] withRange:tosRange];
    [_reminder1Label addLinkToURL:[NSURL URLWithString:@"http://www.zngit.com/privacy-policy"] withRange:ppRange];

    UIColor *color = UIColorFromRGB(0x00BCB6);
    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[color CGColor] range:tosRange];
    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[color CGColor] range:ppRange];
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:12];
    [attString addAttribute:NSFontAttributeName value:font range:tosRange];
    [attString addAttribute:NSFontAttributeName value:font range:ppRange];
    
    [_reminder1Label setAttributedText:attString];
    [_reminder1Label setDelegate:self];
    
    [self updateData];
    
    _btnConfirm.layer.cornerRadius = _btnConfirm.frame.size.height/2;
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
        [_photoImageView setImageWithURL:[NSURL URLWithString:imageUrls[0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    _nameLabel.text = _item.rentalItem.name;
    _totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", [_item getTotalPrice]];
    ZNShop *shop = _item.rentalItem.shop;
    _shopNameLabel.text = shop.name;
    _shopStreetLabel.text = shop.address.street;
    _shopCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", shop.address.city, shop.address.state, shop.address.zip];
    
    
    [_patternImageView setDelegate:self];
    [self setTrackPath];
    [self setTrackerPosition:TRACKER_START_POINT];
}

- (void)setTrackerPosition:(CGPoint)point
{
    CGRect trackerRect = _trackerImageView.frame;
    CGRect newRect = CGRectMake(_patternImageView.frame.origin.x + point.x - _trackerImageView.frame.size.width/2, _patternImageView.frame.origin.y + point.y - _trackerImageView.frame.size.height/2, trackerRect.size.width, trackerRect.size.height);
    
    _trackerImageView.frame = newRect;
}
- (void)setTrackPath
{
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(19, 140)];
    [path addLineToPoint:CGPointMake(111, 140)];
    [path addLineToPoint:CGPointMake(35, 22)];
    [path addLineToPoint:CGPointMake(106, 22)];
    [path addLineToPoint:CGPointMake(106, 1)];
    [path addLineToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(74, 118)];
    [path addLineToPoint:CGPointMake(7, 118)];
    [path addLineToPoint:CGPointMake(19, 140)];
    [path closePath];
    [_patternImageView setTrackPath:path];
    
    [_patternImageView setTrackStartPoint:TRACKER_START_POINT];
    
    NSArray *lines = @[
                       @[[NSValue valueWithCGPoint:CGPointMake(12, 130)], [NSValue valueWithCGPoint:CGPointMake(94, 130)]],
                       @[[NSValue valueWithCGPoint:CGPointMake(94, 130)], [NSValue valueWithCGPoint:CGPointMake(14, 10)]],
                       @[[NSValue valueWithCGPoint:CGPointMake(14, 10)], [NSValue valueWithCGPoint:CGPointMake(104, 10)]]
                       ];
    
    [_patternImageView setBoneLines:lines];
}
#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}
#pragma mark - ZNTrackImageViewDelegate

- (void)beginTrackAtPoint:(CGPoint)point
{
    _scrollView.scrollEnabled = NO;
    
    //[self moveTrackerToPoint:point];
}
- (void)endTrack:(BOOL)success
{
    _scrollView.scrollEnabled = YES;
    
    
    //NSLog(@"Confirm Success:%d", success);
    
    if(success)
    {
        // Request booking to SERVER
        [ZNAlertManager showProgressBarWithTitle:@"Requesting your book..." view:self.view];
        [[ZNAPIManager sharedInstance] requestBook:_item completion:^(id result, BOOL success) {
            [ZNAlertManager hideProgressBar];
            if(success)
            {
                ZNBookingConfirmedVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNBookingConfirmedVC"];
                vc.delegate = self;
                [[KGModal sharedInstance] showWithContentViewController:vc andAnimated:YES];
            }
            else
            {
                [ZNAlertManager showErrorMessage:@"Sorry but your request failed. please try again later"];
            }
        }];
    }
//    else
//    {
//        [self moveTrackerToPoint:TRACKER_START_POINT];
//    }
}
- (void)moveTrackerToPoint:(CGPoint)point
{
    _scrollView.scrollEnabled = NO;
    
    [self setTrackerPosition:point];
}

- (IBAction)btnConfirmClicked:(id)sender {
    // Request booking to SERVER
    [ZNAlertManager showProgressBarWithTitle:@"Requesting your book..." view:self.view];
    [[ZNAPIManager sharedInstance] requestBook:_item completion:^(id result, BOOL success) {
        [ZNAlertManager hideProgressBar];
        if(success)
        {
            ZNBookingConfirmedVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNBookingConfirmedVC"];
            vc.delegate = self;
            [[KGModal sharedInstance] showWithContentViewController:vc andAnimated:YES];
        }
        else
        {
            [ZNAlertManager showErrorMessage:@"Sorry but your request failed. please try again later"];
        }
    }];
}

#pragma mark - ZNBookingConfirmedVCDelegate
- (void)btnGotitClickedOnConfirmDlg
{
    [[KGModal sharedInstance] hideAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
