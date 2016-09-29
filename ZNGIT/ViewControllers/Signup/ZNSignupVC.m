//
//  ZNSignupEnterEmailVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSignupVC.h"
#import "ZNAlertManager.h"
#import "ZNUtils.h"
#import "AppDelegate.h"
#import "ZNAPIManager.h"
#import "ZNSettingsManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ZNSignupVC() <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;

@property (nonatomic, assign) NSInteger currentPage;

@end
@implementation ZNSignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBackButtonItem];
    
    _btnContinue.layer.cornerRadius = _btnContinue.frame.size.height/2;
    [self performSelector:@selector(initScrollView) withObject:nil afterDelay:0.1];
    _currentPage = 0;
    
    _user = [[ZNUser alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    //[self setNavigationBackButtonItem];
}


- (void)initScrollView
{
    CGSize scrollViewSize = self.scrollView.frame.size;
    [self.scrollView setContentSize:CGSizeMake(scrollViewSize.width*3, scrollViewSize.height)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.scrollView setContentInset:UIEdgeInsetsZero];
}


- (void)onBack
{
    if(_currentPage == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_currentPage == 1)
    {
        _currentPage --;
        
        CGFloat x = _currentPage * self.scrollView.frame.size.width;
        [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        [_stepImageView setImage:[UIImage imageNamed:@"step1_3"]];
    }
    else if(_currentPage == 2)
    {
        _currentPage --;
        
        CGFloat x = _currentPage * self.scrollView.frame.size.width;
        [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        [_stepImageView setImage:[UIImage imageNamed:@"step2_3"]];
    }
}
- (IBAction)btnContinueClicked:(id)sender {
    [self.view endEditing:YES];
    
    if(_currentPage == 0)
    {
        NSString *email = _textFieldEmail.text;
        if(!email || email.length==0)
        {
            [ZNAlertManager showErrorMessage:@"The email required"];
            return;
        }
        if(![ZNUtils isValidEmail:email])
        {
            [ZNAlertManager showErrorMessage:@"Invalid email format"];
            return;
        }
        
        _user.email = email;
        
        _currentPage ++;
        
        CGFloat x = _currentPage * self.scrollView.frame.size.width;
        [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        [_stepImageView setImage:[UIImage imageNamed:@"step2_3"]];
    }
    else if(_currentPage == 1)
    {
        NSString *password = _textFieldPassword.text;
        if(!password || password.length==0)
        {
            [ZNAlertManager showErrorMessage:@"The password required"];
            return;
        }
        
        _user.password = password;
        
        _currentPage ++;
        
        CGFloat x = _currentPage * self.scrollView.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        
        [_btnContinue setTitle:@"Sign Up" forState:UIControlStateNormal];
        [_stepImageView setImage:[UIImage imageNamed:@"step3_3"]];
    }
    else if(_currentPage == 2)
    {
        NSString *fullname = _textFieldName.text;
        if(!fullname || fullname.length==0)
        {
            [ZNAlertManager showErrorMessage:@"The name required"];
            return;
        }
        
        _user.fullname = fullname;
        _user.type = @"C";
        
        
        [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
        [[ZNAPIManager sharedInstance] createUser:_user completion:^(id result, BOOL success) {
            if(success) {
                [[ZNAPIManager sharedInstance] login:_user.email password:_user.password completion:^(id result, BOOL success) {
                    [ZNAlertManager hideProgressBar];
                    if(success)
                    {
                        NSDictionary *accessToken = (NSDictionary*)result;
                        NSString *accessTokenId = accessToken[@"id"];
                        [[ZNSettingsManager sharedInstance] setAccessToken:accessTokenId];
                        [AppDelegate sharedInstance].currentUser = [ZNUser initWithDictionary:accessToken[@"user"]];
                        
                        if(self.isNeedLogin)
                        {
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_SIGN_IN_SUCCEEDED object:nil];
                        }
                        else
                        {
                            [self gotoMainController];
                        }
                    }
                    else
                    {
                        [ZNAlertManager showErrorMessage:@"Login failed. Please try again later!"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
            else
            {
                [ZNAlertManager hideProgressBar];
                [ZNAlertManager showErrorMessage:@"Could not create new user. Please try again later!"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}


- (IBAction)btnFacebookSignupClicked:(id)sender {
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.navigationController.view];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [loginManager
     logInWithReadPermissions: @[@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             DLog(@"Process failed with the error:%@", error);
             [ZNAlertManager showErrorMessage:@"Facebook process error"];
             
             [ZNAlertManager hideProgressBar];
         } else if (result.isCancelled) {
             DLog(@"Cancelled");
             [ZNAlertManager showErrorMessage:@"Facebook process cancelled"];
             
             [ZNAlertManager hideProgressBar];
         } else {
             DLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name,email"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          DLog(@"fetched user:%@", result);
                          NSString *email = result[@"email"];
                          NSString *name = result[@"name"];
                          
                          [[ZNAPIManager sharedInstance] signupWithFacebook:email name:name completion:^(id result, BOOL success) {
                              [ZNAlertManager hideProgressBar];
                              if(success)
                              {
                                  NSDictionary *accessToken = (NSDictionary*)result;
                                  NSString *accessTokenId = accessToken[@"id"];
                                  [[ZNSettingsManager sharedInstance] setAccessToken:accessTokenId];
                                  [AppDelegate sharedInstance].currentUser = [ZNUser initWithDictionary:accessToken[@"user"]];
                                  
                                  if(self.isNeedLogin)
                                  {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_SIGN_IN_SUCCEEDED object:nil];
                                  }
                                  else
                                  {
                                      [self gotoMainController];
                                  }
                              }
                              else
                              {
                                  [ZNAlertManager showErrorMessage:@"Login failed. Please try again later!"];
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }
                          }];
                      } else {
                          [ZNAlertManager hideProgressBar];
                          [ZNAlertManager showErrorMessage:@"Failed to sign up with facebook. Please try again later"];
                      }
                  }];
             }
         }
     }];
}



- (void)gotoMainController
{
    
    ZNMainTabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNMainTabBarController"];
    //[[AppDelegate sharedInstance] setMainTabBarController:tabBarController];
    
    [self presentViewController:tabBarController animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
