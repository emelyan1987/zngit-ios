//
//  ZNChangeEmailVC.m
//  ZNGIT
//
//  Created by LionStar on 4/17/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNChangeEmailVC.h"
#import "ZNUser.h"
#import "AppDelegate.h"
#import "ZNAlertManager.h"
#import "ZNUtils.h"
#import "ZNAPIManager.h"



@interface ZNChangeEmailVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSaveClicked:(id)sender;

@property (nonatomic, strong) ZNUser *user;
@end

@implementation ZNChangeEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackButtonItem];
    [self setNavigationBarTitle:@"CHANGE EMAIL"];
    
    _btnSave.layer.cornerRadius = _btnSave.frame.size.height/2;
    
    _user = [AppDelegate sharedInstance].currentUser;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnSaveClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSString *email = _emailTextField.text;
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
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] changeEmail:[_user.id integerValue] email:_user.email completion:^(id result, BOOL success)
    {
        if(success) {
            [ZNAlertManager hideProgressBar];
            
            [AppDelegate sharedInstance].currentUser = _user;
            
            
            if([_delegate respondsToSelector:@selector(userEmailChanged:)])
                [_delegate userEmailChanged:_user.email];
            
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
