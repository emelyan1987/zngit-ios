//
//  ZNSignupPageVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSignupPageVC.h"
#import "ZNSignupEnterEmailVC.h"
#import "ZNSignupCreatePasswordVC.h"
#import "ZNSignupEnterNameVC.h"

@interface ZNSignupPageVC () <UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) ZNSignupEnterEmailVC *emailVC;
@property (nonatomic, strong) ZNSignupCreatePasswordVC *passwordVC;
@property (nonatomic, strong) ZNSignupEnterNameVC *nameVC;
@property (nonatomic, strong) NSArray *contentVCs;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ZNSignupPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _emailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSignupEnterEmailVC"];
    _emailVC.index = 0;
    _passwordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSignupCreatePasswordVC"];
    _passwordVC.index = 1;
    _nameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSignupEnterNameVC"];
    _nameVC.index = 2;
    
    self.contentVCs = @[_emailVC, _passwordVC, _nameVC];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:@[_emailVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ([self.contentVCs count] == 0 || index >= [self.contentVCs count])
        return nil;
    
    
    // Create a new view controller and pass suitable data.
    if(index==0) return _emailVC;
    else if(index==1) return _passwordVC;
    else if(index==2) return _nameVC;
    else return nil;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[ZNSignupEnterEmailVC class]]) return nil;
    else if([viewController isKindOfClass:[ZNSignupCreatePasswordVC class]]) return _emailVC;
    else if([viewController isKindOfClass:[ZNSignupEnterNameVC class]]) return _passwordVC;
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if([viewController isKindOfClass:[ZNSignupEnterEmailVC class]]) return _passwordVC;
    else if([viewController isKindOfClass:[ZNSignupCreatePasswordVC class]]) return _nameVC;
    else if([viewController isKindOfClass:[ZNSignupEnterNameVC class]]) return nil;
    
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.contentVCs count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
@end
