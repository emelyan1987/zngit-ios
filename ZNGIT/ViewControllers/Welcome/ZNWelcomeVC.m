//
//  ViewController.m
//  ZNGIT
//
//  Created by Reflect Apps on 3/2/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNWelcomeVC.h"
#import "ZNSigninVC.h"
#import "ZNSettingsManager.h"
#import "ZNAPIManager.h"
#import "ZNMainTabBarController.h"
#import "AppDelegate.h"

#define PAGE_COUNT 3

@interface ZNWelcomeVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnExploreApp;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;

@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ZNWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.pageControl.numberOfPages = PAGE_COUNT;
    self.pageControl.currentPage = 0;
    [self performSelector:@selector(initScrollView) withObject:nil afterDelay:0.1];
    
    self.btnSignUp.layer.cornerRadius = self.btnSignUp.frame.size.height / 2;
    self.btnLogIn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogIn.layer.borderWidth = 2;
    self.btnLogIn.layer.cornerRadius = 4;
    
    self.currentPage = 0;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                  target:self
//                                                selector:@selector(handlerTimer:)
//                                                userInfo:nil
//                                                 repeats:YES];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if([self.timer isValid])
        [self.timer invalidate];
}

- (void)initScrollView
{
    CGSize scrollViewSize = self.scrollView.frame.size;
    [self.scrollView setContentSize:CGSizeMake(scrollViewSize.width*3, scrollViewSize.height)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)handlerTimer:(id)sender
{
    self.currentPage ++;
    self.currentPage %= 3;
    
    
    CGFloat x = self.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (IBAction)btnLogInClicked:(id)sender {
    ZNSigninVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSigninVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnExploreAppClicked:(id)sender {
    
    ZNMainTabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNMainTabBarController"];
    
    //[[AppDelegate sharedInstance] setMainTabBarController:tabBarController];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        
        CGPoint offset = scrollView.contentOffset;
        
        
        self.currentPage = offset.x / self.scrollView.frame.size.width;
        
        self.pageControl.currentPage = self.currentPage;
    }
}
@end
