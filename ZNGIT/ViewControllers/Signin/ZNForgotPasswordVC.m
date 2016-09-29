//
//  ZNForgotPasswordVC.m
//  ZNGIT
//
//  Created by LionStar on 3/4/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNForgotPasswordVC.h"
#import "ZNPasswordSentVC.h"
#import "KGModal.h"
#import "ZNUtils.h"
#import "ZNAPIManager.h"
#import "ZNAlertManager.h"


@interface ZNForgotPasswordVC () <ZNPasswordSentVCDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation ZNForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBackButtonItem];

    _btnSubmit.layer.cornerRadius = _btnSubmit.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSubmitClicked:(id)sender {
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
    
    [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
    [[ZNAPIManager sharedInstance] resetPassword:email completion:^(id result, BOOL success) {
        NSDictionary *accessToken = (NSDictionary*)result;
        if(success)
        {
            [ZNAlertManager hideProgressBar];
            
            ZNPasswordSentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNPasswordSentVC"];
            vc.delegate = self;
            [[KGModal sharedInstance] showWithContentViewController:vc andAnimated:YES];
        }
        else
        {
            [ZNAlertManager hideProgressBar];
            [ZNAlertManager showErrorMessage:@"Request failed. Please try again later!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - ZNPasswordSentVCDelegate
- (void)btnGotitClickedOnConfirmDlg
{
    [[KGModal sharedInstance] hideAnimated:YES];
}



#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
