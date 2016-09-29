//
//  ZNRootVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRootVC.h"

#define TITLE_LABEL_HEIGHT 14

@interface ZNRootVC ()

@end

@implementation ZNRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBackButtonItem
{
    [self.navigationController setNavigationBarHidden:NO];
    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
//     setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor blackColor],
//       NSFontAttributeName:[UIFont fontWithName:@"MuseoSans-900" size:13.0f]
//       } forState:UIControlStateNormal];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    [self.navigationItem setLeftBarButtonItem:btnBack animated:NO];
}

- (void)setNavigationBackButtonItemAsDismiss
{
    [self.navigationController setNavigationBarHidden:NO];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onDismiss)];
    [self.navigationItem setLeftBarButtonItem:btnBack animated:NO];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setNavigationBarTitle:(NSString*)title
{
    title = [title uppercaseString];
    [self.navigationController setNavigationBarHidden:NO];
    
    CGFloat navWidth = self.navigationController.navigationBar.frame.size.width;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Black" size:11.0f];
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setFont:font];
    lblTitle.textColor = ZNGIT_MAIN_COLOR;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [title length])];
    lblTitle.attributedText = attributedString;
    
    
    [lblTitle sizeToFit];
    CGFloat maximumLabelWidth = lblTitle.frame.size.width>navWidth-150?navWidth-150:lblTitle.frame.size.width;
    lblTitle.frame = CGRectMake(0, (navHeight-TITLE_LABEL_HEIGHT)/2, maximumLabelWidth, TITLE_LABEL_HEIGHT);
    
    
    CGRect headerFrame = CGRectMake(0, 0, maximumLabelWidth, navHeight);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    [headerView addSubview:lblTitle];
    
    self.navigationItem.titleView = headerView;
}

- (void)setNavigationBarTitle:(NSString*)title withIcon:(UIImage*)icon iconPosition:(ZNNavTitleIconPosition)position
{
    title = [title uppercaseString];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    CGFloat navWidth = self.navigationController.navigationBar.frame.size.width;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Black" size:11.0f];
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setFont:font];
    lblTitle.textColor = ZNGIT_MAIN_COLOR;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [title length])];
    lblTitle.attributedText = attributedString;
    
    
    [lblTitle sizeToFit];
    CGFloat maximumLabelWidth = lblTitle.frame.size.width>navWidth-150?navWidth-150:lblTitle.frame.size.width;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
    
    CGRect headerFrame, labelFrame, iconFrame;
    if(position == ZNNavTitleIconRight)
    {
        headerFrame = CGRectMake(0, 0, maximumLabelWidth + icon.size.width + 10, navHeight);
        labelFrame = CGRectMake(0, (navHeight-lblTitle.frame.size.height)/2, maximumLabelWidth, lblTitle.frame.size.height);
        iconFrame = CGRectMake(maximumLabelWidth+5, (navHeight-icon.size.height)/2-1, icon.size.width, icon.size.height);
    }
    else
    {
        headerFrame = CGRectMake(0, 0, maximumLabelWidth, navHeight);
        labelFrame = CGRectMake(0, (navHeight-lblTitle.frame.size.height)/2-3, maximumLabelWidth, lblTitle.frame.size.height);
        iconFrame = CGRectMake((maximumLabelWidth-icon.size.width)/2, labelFrame.origin.y+labelFrame.size.height+5, icon.size.width, icon.size.height);
    }
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    lblTitle.frame = labelFrame;
    imageView.frame = iconFrame;
    [headerView addSubview:lblTitle];
    [headerView addSubview:imageView];
    
    self.navigationItem.titleView = headerView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
