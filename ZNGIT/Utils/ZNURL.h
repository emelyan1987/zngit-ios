//
//  ZNURL.h
//  ZNGIT
//
//  Created by LionStar on 4/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNURL : NSObject

+ (NSString*)SearchCity;
+ (NSString*)CreateUser;
+ (NSString*)SignupWithFacebook;
+ (NSString*)UpdateUserAttributes:(NSInteger)userId;
+ (NSString*)Login;
+ (NSString*)LoginWithFacebook;
+ (NSString*)ResetPassword;
+ (NSString*)LoginByAccessToken;
+ (NSString*)Logout;
+ (NSString*)ParentCategories;
+ (NSString*)SubCategories;
+ (NSString*)RentalItemsByLocation;
+ (NSString*)RequestBook;
+ (NSString*)MyBookingItems;
+ (NSString*)CreateStripeToken;
@end
