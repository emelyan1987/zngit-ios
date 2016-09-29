//
//  ZNChangePasswordVC.m
//  ZNGIT
//
//  Created by LionStar on 4/17/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNChangePasswordVC.h"
#import "ZNUser.h"
#import "AppDelegate.h"
#import "ZNAlertManager.h"
#import "ZNUtils.h"
#import "ZNAPIManager.h"

@interface ZNChangePasswordVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSaveClicked:(id)sender;

@property (nonatomic, strong) ZNUser *user;
@end

@implementation ZNChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigationBackButtonItem];
    [self setNavigationBarTitle:@"CHANGE PASSWORD"];
    
    
    _btnSave.layer.cornerRadius = _btnSave.frame.size.height/2;
    
    _user = [AppDelegate sharedInstance].currentUser;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSaveClicked:(id)sender {
    NSString *password = _passwordTextField.text;
    if(!password || password.length==0)
    {
        [ZNAlertManager showErrorMessage:@"The password required"];
        return;
    }
    
    _user.password = password;
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] changePassword:[_user.id integerValue] password:_user.password completion:^(id result, BOOL success)
     {
         if(success) {
             [ZNAlertManager hideProgressBar];
             
             [AppDelegate sharedInstance].currentUser = _user;
             
             
             if([_delegate respondsToSelector:@selector(userPasswordChanged:)])
                 [_delegate userPasswordChanged:_user.password];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [ZNAlertManager hideProgressBar];
             [ZNAlertManager showErrorMessage:result[@"message"]];
         }
     }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
