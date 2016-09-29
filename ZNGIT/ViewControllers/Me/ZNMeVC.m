//
//  ZNMeVC.m
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNMeVC.h"
#import "ZNAlertManager.h"
#import "ZNAPIManager.h"
#import "AppDelegate.h"
#import "ZNUser.h"
#import "ZNSettingsManager.h"
#import "ZNPaymentMethodsVC.h"
#import "ZNChangeEmailVC.h"
#import "ZNChangePasswordVC.h"
#import <MessageUI/MessageUI.h>
#import "ZNWelcomeVC.h"

#define TITLE @"MY ACCOUNT"

@interface ZNMeVC () <UITextFieldDelegate, MFMailComposeViewControllerDelegate, ZNChangeEmailVCDelegate, ZNChangePasswordVCDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (nonatomic, strong) UITapGestureRecognizer *recognizerForKeyboardDismiss;
- (IBAction)paymentButtonClicked:(id)sender;
- (IBAction)emailButtonClicked:(id)sender;
- (IBAction)passwordButtonClicked:(id)sender;

- (IBAction)contactPhoneButtonClicked:(id)sender;
- (IBAction)contactEmailButtonClicked:(id)sender;

- (IBAction)actionButtonClicked:(id)sender;
@end

@implementation ZNMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:TITLE];
    
    
    [self loadData];
    
    // Add tap gesture recognizer for dismissing keyboard when touch other places.
    _recognizerForKeyboardDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _recognizerForKeyboardDismiss.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_recognizerForKeyboardDismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrimaryCardChanged:) name:ZN_NOTIFICATION_PRIMARY_CREDIT_CARD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentUserChanged:) name:ZN_NOTIFICATION_CURRENT_USER_CHANGED object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    ZNUser *user = [AppDelegate sharedInstance].currentUser;
    
    _nameTextField.text = user.fullname;
    _emailLabel.text = user.email;
    
    
    [self updateCardData];
}

- (void)updateCardData
{
    NSDictionary *cardData = [[ZNSettingsManager sharedInstance] getPrimaryCreditCard];
    
    NSString *cardNumber = cardData[@"number"];
    NSString *cardLast4 = cardNumber ? [cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)] : nil;
    NSString *cardBrand = cardData[@"brand"] ? cardData[@"brand"] : nil;
    
    if(cardBrand && cardLast4)
    {
        _cardNumberLabel.text = [NSString stringWithFormat:@"%@•%@", cardBrand, cardLast4];
    }
    else
    {
        _cardNumberLabel.text = @"Add a Payment Method";
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)handlePrimaryCardChanged:(NSNotification*)notification
{
    [self updateCardData];
}
- (void)handleCurrentUserChanged:(NSNotification*)notification
{
    [self loadData];
}

- (IBAction)paymentButtonClicked:(id)sender {
    ZNPaymentMethodsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNPaymentMethodsVC"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)emailButtonClicked:(id)sender {
    ZNChangeEmailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNChangeEmailVC"];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)passwordButtonClicked:(id)sender {
    ZNChangePasswordVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNChangePasswordVC"];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)contactPhoneButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", ZNGIT_CONTACT_PHONE]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)contactEmailButtonClicked:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        [ZNAlertManager showErrorMessage:@"Your device doesn't support SMS!"];
        return;
    }
    // Email Subject
    NSString *emailTitle = @"Need Help Support";
    // Email Content
    NSString *messageBody = @"Hi ZNGIT Support Team!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:ZNGIT_CONTACT_EMAIL];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)actionButtonClicked:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([AppDelegate sharedInstance].currentUser.id)
    {
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [ZNAlertManager showProgressBarWithTitle:nil view:self.view];
            
            [[ZNAPIManager sharedInstance] logout:^(id result, BOOL success) {
                [ZNAlertManager hideProgressBar];
                if(success)
                {
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
                    [AppDelegate sharedInstance].currentUser = nil;
                }
                else
                {
                    [ZNAlertManager showErrorMessage:@"Logout failed. Please try again later"];
                }
            }];
        }];
        [alert addAction:logoutAction];
    }
    else
    {
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
        }];
        
        [alert addAction:loginAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancelAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ZNChangeEmailVCDelegate

- (void)userEmailChanged:(NSString *)email
{
    [self loadData];
}


#pragma mark ZNChangePasswordVCDelegate

- (void)userPasswordChanged:(NSString *)password
{
    [self loadData];
}
@end
