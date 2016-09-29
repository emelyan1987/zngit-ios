//
//  ZNNeedLoginVC.m
//  ZNGIT
//
//  Created by LionStar on 4/30/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNNeedLoginVC.h"
#import "ZNSigninVC.h"
#import "ZNSignupVC.h"

@interface ZNNeedLoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation ZNNeedLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnSignUp.layer.cornerRadius = self.btnSignUp.frame.size.height / 2;
    self.btnLogIn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogIn.layer.borderWidth = 2;
    self.btnLogIn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];   
    
}
- (IBAction)btnCloseClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_SIGN_IN_CANCELED object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnLogInClicked:(id)sender
{
    ZNSigninVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSigninVC"];
    vc.isNeedLogin = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnSignUpClicked:(id)sender
{
    ZNSignupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNSignupVC"];
    vc.isNeedLogin = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
