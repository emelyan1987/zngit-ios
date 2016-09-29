//
//  ZNUtils.m
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNUtils.h"
#import "AppDelegate.h"

@implementation ZNUtils

+ (BOOL)isYelpInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp:"]];
}

+ (BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isNumeric:(NSString *)text
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphaNums isSupersetOfSet:inStringSet];
}

+ (BOOL)isValidExpireDateFormat:(NSString*)dateString month:(out NSNumber**)month year:(out NSNumber**)year
{
    if(!dateString) return NO;
    
    NSArray *tokens = [dateString componentsSeparatedByString:@" / "];
    
    if(tokens.count != 2) return NO;
    
    NSString *monthString = tokens[0];
    if(![self isNumeric:monthString]) return NO;
    
    NSString *yearString = tokens[0];
    if(![self isNumeric:yearString]) return NO;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    *(month) = [f numberFromString:monthString];
    *(year) = [f numberFromString:yearString];
    
    return YES;
}
@end
