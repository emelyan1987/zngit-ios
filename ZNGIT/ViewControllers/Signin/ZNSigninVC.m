//
//  ZNSigninVC.m
//  ZNGIT
//
//  Created by LionStar on 3/4/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSigninVC.h"
#import "ZNForgotPasswordVC.h"
#import "ZNMainTabBarController.h"
#import "AppDelegate.h"
#import "ZNAPIManager.h"
#import "ZNSettingsManager.h"
#import "ZNAlertManager.h"
#import "ZNUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ZNSigninVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;
@end

@implementation ZNSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBackButtonItem];
    
    _btnSignin.layer.cornerRadius = _btnSignin.frame.size.height/2;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnForgotPasswordClicked:(id)sender {
    ZNForgotPasswordVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNForgotPasswordVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnSigninClicked:(id)sender {
    [self.view endEditing:YES];
    
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
    NSString *password = _textFieldPassword.text;
    if(!password || password.length==0)
    {
        [ZNAlertManager showErrorMessage:@"The password required"];
        return;
    }
    
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] login:email password:password completion:^(id result, BOOL success) {
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
            [ZNAlertManager showErrorMessage:@"Could not identify user account. Please try again with correct email and password.!"];
            
        }
    }];
}

- (IBAction)btnFacebookSigninClicked:(id)sender {
    [ZNAlertManager showProgressBarWithTitle:nil view:self.navigationController.view];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [loginManager logInWithReadPermissions: @[@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             DLog(@"Failed with the error:%@", error);
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
                          
                          [[ZNAPIManager sharedInstance] loginWithFacebook:email completion:^(id result, BOOL success) {
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
