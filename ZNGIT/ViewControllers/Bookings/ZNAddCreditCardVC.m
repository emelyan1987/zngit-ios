//
//  ZNAddCreditCardVC.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNAddCreditCardVC.h"
#import "ZNAlertManager.h"
#import "ZNSettingsManager.h"
#import "ZNAPIManager.h"

#import "LTHMonthYearPickerView.h"

#define TITLE @"ADD CREDIT CARD"

@interface ZNAddCreditCardVC () <LTHMonthYearPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;

@property (nonatomic, strong) LTHMonthYearPickerView *monthYearPicker;
- (IBAction)saveButtonClicked:(id)sender;

@property (nonatomic, assign) NSInteger expireYear;
@property (nonatomic, assign) NSInteger expireMonth;

@end

@implementation ZNAddCreditCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBackButtonItem];
    [self setNavigationBarTitle:TITLE];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM / yyyy"];
    NSDate *initialDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2015]];
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2115]];
    
    _monthYearPicker = [[LTHMonthYearPickerView alloc]
                        initWithDate: initialDate
                        shortMonths: YES
                        numberedMonths: YES
                        andToolbar: YES
                        minDate:[NSDate date]
                        andMaxDate:maxDate];
    _monthYearPicker.delegate = self;
    
    _expirationDateTextField.inputView = _monthYearPicker;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)saveButtonClicked:(id)sender
{
    NSString *cardNumber = _cardNumberTextField.text;
    if(cardNumber.length==0)
    {
        [ZNAlertManager showErrorMessage:@"Card Number Required!"];
        return;
    }
    else if(cardNumber.length!= 16)
    {
        [ZNAlertManager showErrorMessage:@"Card Number must be 16 digits!"];
        return;
    }
    
    if(_expireMonth==0 || _expireYear==0)
    {
        [ZNAlertManager showErrorMessage:@"Expiration Date Required!"];
        return;
    }
    
    NSString *cvc = _cvcTextField.text;
    if(cvc.length==0)
    {
        [ZNAlertManager showErrorMessage:@"CVC Required!"];
        return;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{
                           @"number": cardNumber,
                           @"exp_month": @(_expireMonth),
                           @"exp_year": @(_expireYear),
                           @"cvc": cvc
                           }];
    
    [ZNAlertManager showProgressBarWithTitle:@"Validating card data..." view:self.view];
    [[ZNAPIManager sharedInstance] validateCardData:data completion:^(id result, BOOL success) {
        [ZNAlertManager hideProgressBar];
        if(success)
        {
            NSDictionary *cardData = result[@"card"];
            
            [data setObject:cardData[@"brand"] forKey:@"brand"];
            
            [[ZNSettingsManager sharedInstance] addCreditCard:data];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if([self.delegate respondsToSelector:@selector(didAddCreditCardData)])
            {
                [self.delegate didAddCreditCardData];
            }
        }
        else
        {
            [ZNAlertManager showErrorMessage:@"Sorry but we could not identify your card data. Please try again correct card data"];
        }
    }];
    
    
}

#pragma mark - LTHMonthYearPickerView Delegate
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues {
    _expireYear = [initialValues[@"year"] intValue];
    
    _expireMonth = [initialValues[@"month"] intValue];
    
    _expirationDateTextField.text = [NSString stringWithFormat:
                           @"%i / %i",
                           (int)_expireMonth,
                           (int)(_expireYear-2000)];
    
    
    [_expirationDateTextField resignFirstResponder];
}


- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year {
    _expireMonth = [month intValue];
    _expireYear = [year intValue];
    
    _expirationDateTextField.text = [NSString stringWithFormat: @"%i / %i", (int)_expireMonth, (int)_expireYear-2000];
    [_expirationDateTextField resignFirstResponder];
}


- (void)pickerDidPressCancel {
    [_expirationDateTextField resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:_cardNumberTextField])
    {
        if (textField.text.length >= 16 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}
@end
