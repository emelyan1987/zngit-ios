//
//  ZNMainTabBarController.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNMainTabBarController.h"
#import "JMHoledView.h"
#import "ZNSettingsManager.h"
#import "ZNTooltipView.h"
#import "AppDelegate.h"

#define TOOLTIP_VIEW_WIDTH 245
#define TOOLTIP_VIEW_HEIGHT 116
@interface ZNMainTabBarController () <UITabBarDelegate, JMHoledViewDelegate>

@property (nonatomic, strong) JMHoledView *holedView;
@property (nonatomic, assign) NSInteger tutorialStepIndex;

@property (nonatomic, strong) UIView *selectedTabLineView;
@property (nonatomic, assign) NSInteger selectedTabIndex;

@property ZNTooltipView *tooltipView;
@end

@implementation ZNMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedTabIndex = 0;
    _selectedTabLineView = [[UIView alloc] init];
    _selectedTabLineView.backgroundColor = ZNGIT_MAIN_COLOR;
    _selectedTabLineView.hidden = YES;
    [self.view addSubview:_selectedTabLineView];
    [self performSelector:@selector(updateLineView) withObject:nil afterDelay:.1];
    
    if(![[ZNSettingsManager sharedInstance] getTutorialHaveBeenShowed])
        [self performSelector:@selector(showTutorialView) withObject:nil afterDelay:.1];

    [[AppDelegate sharedInstance] setMainTabBarController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationNeedLogin:) name:ZN_NOTIFICATION_NEED_LOGIN object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNotificationNeedLogin:(NSNotification*)notification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Need to login again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if([AppDelegate sharedInstance].pushedWelcomeNC)
        {
            [[AppDelegate sharedInstance].mainTabBarController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *welcomeNC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeNC"];
            
            [[AppDelegate sharedInstance].mainTabBarController presentViewController:welcomeNC animated:YES completion:^{
                [AppDelegate sharedInstance].pushedWelcomeNC = YES;
            }];
        }
        [[ZNSettingsManager sharedInstance] setAccessToken:nil];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateLineView
{

    _selectedTabLineView.hidden = NO;
    
    CGRect tabbarFrame = self.tabBar.frame;
    
    [UIView animateWithDuration:.3 animations:^{
        _selectedTabLineView.frame = CGRectMake(tabbarFrame.size.width/3*_selectedTabIndex, tabbarFrame.origin.y, tabbarFrame.size.width/3, 3);
        
    }];
}

- (void)selectTab:(NSInteger)tabIndex
{
    [self setSelectedIndex:tabIndex];
    _selectedTabIndex = tabIndex;
    [self updateLineView];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    _selectedTabIndex = [[tabBar items] indexOfObject:item];
    
    [self updateLineView];    
    
}

- (void)showTutorialView
{
    CGRect windowFrame = self.view.window.frame;
    _holedView = [[JMHoledView alloc] initWithFrame:windowFrame];
    [self.view addSubview:_holedView];
    _holedView.holeViewDelegate = self;
    
    _tutorialStepIndex = 1;
    
    
    [_holedView addHoleCircleCenteredOnPosition:CGPointMake(windowFrame.size.width-25, [[UIApplication sharedApplication] statusBarFrame].size.height+20) andDiameter:40.0f];
    
    _tooltipView = [ZNTooltipView createView];
    _tooltipView.title = @"SEARCH FOR AN ITEM";
    _tooltipView.message = @"Search for any item you want to rent my clicking here";
    _tooltipView.frameImage = [UIImage imageNamed:@"tutorial_frame1.png"];
    
    [_holedView addHCustomView:_tooltipView onRect:CGRectMake(windowFrame.size.width-TOOLTIP_VIEW_WIDTH-3, [[UIApplication sharedApplication] statusBarFrame].size.height+46, TOOLTIP_VIEW_WIDTH, TOOLTIP_VIEW_HEIGHT)];
    
}

#pragma mark - JMHoledViewDelegate

- (void)holedView:(JMHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index
{
    //[_tooltipView removeFromSuperview];
    CGRect windowFrame = self.view.window.frame;
    [_tooltipView removeFromSuperview];
    [_holedView removeHoles];
    
    _tutorialStepIndex ++;
    
    if(_tutorialStepIndex == 2)
    {
        [_holedView addHoleCircleCenteredOnPosition:CGPointMake(windowFrame.size.width/2, windowFrame.size.height-15) andDiameter:70.0f];
        
        
        _tooltipView.title = @"SEE YOUR BOOKINGS";
        _tooltipView.message = @"See all of your rental item bookings here";
        _tooltipView.frameImage = [UIImage imageNamed:@"tutorial_frame2.png"];
        [_holedView addHCustomView:_tooltipView onRect:CGRectMake((windowFrame.size.width-TOOLTIP_VIEW_WIDTH)/2, windowFrame.size.height-TOOLTIP_VIEW_HEIGHT-57, TOOLTIP_VIEW_WIDTH, TOOLTIP_VIEW_HEIGHT)];
    }
    else if(_tutorialStepIndex == 3)
    {
        [_holedView addHoleRoundedRectOnRect:CGRectMake((windowFrame.size.width-163)/2, [[UIApplication sharedApplication] statusBarFrame].size.height-3, 163, 56) withCornerRadius:5.0f];
        
        _tooltipView.title = @"CHANGE YOUR CITY";
        _tooltipView.message = @"Change the city your looking for any time";
        _tooltipView.frameImage = [UIImage imageNamed:@"tutorial_frame3.png"];
        
        [_holedView addHCustomView:_tooltipView onRect:CGRectMake((windowFrame.size.width-TOOLTIP_VIEW_WIDTH)/2, [[UIApplication sharedApplication] statusBarFrame].size.height+56+3, TOOLTIP_VIEW_WIDTH, TOOLTIP_VIEW_HEIGHT)];
    }
    else
    {
        [_holedView removeFromSuperview];
        
        [[ZNSettingsManager sharedInstance] setTutorialHaveBeenShowed:@(YES)];
    }
}

@end
