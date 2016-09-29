//
//  ZNURL.m
//  ZNGIT
//
//  Created by LionStar on 4/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNURL.h"


@implementation ZNURL

+ (NSString*)SearchCity
{
    return @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
}
+ (NSString*)CreateUser
{
    return [NSString stringWithFormat:@"%@/api/Actors", ZNGIT_BASE_URL];
}
+ (NSString*)SignupWithFacebook
{
    return [NSString stringWithFormat:@"%@/api/Actors/signupWithFacebook", ZNGIT_BASE_URL];
}

+ (NSString*)UpdateUserAttributes:(NSInteger)userId
{
    return [NSString stringWithFormat:@"%@/api/Actors/%i", ZNGIT_BASE_URL, (int)userId];
}
+ (NSString*)Login
{
    return [NSString stringWithFormat:@"%@/api/Actors/login?include=user", ZNGIT_BASE_URL];
}
+ (NSString*)LoginWithFacebook
{
    return [NSString stringWithFormat:@"%@/api/Actors/loginWithFacebook", ZNGIT_BASE_URL];
}

+ (NSString*)ResetPassword
{
    return [NSString stringWithFormat:@"%@/api/Actors/reset", ZNGIT_BASE_URL];
}
+ (NSString*)LoginByAccessToken
{
    return [NSString stringWithFormat:@"%@/api/Actors/loginByAccessToken", ZNGIT_BASE_URL];
}
+ (NSString*)Logout
{
    return [NSString stringWithFormat:@"%@/api/Actors/logout", ZNGIT_BASE_URL];
}
+ (NSString*)ParentCategories
{
    return [NSString stringWithFormat:@"%@/api/ParentCategories", ZNGIT_BASE_URL];
}
+ (NSString*)SubCategories
{
    return [NSString stringWithFormat:@"%@/api/SubCategories", ZNGIT_BASE_URL];
}
+ (NSString*)RentalItemsByLocation
{
    return [NSString stringWithFormat:@"%@/api/RentalItems/listByLocation", ZNGIT_BASE_URL];
}
+ (NSString*)RequestBook
{
    return [NSString stringWithFormat:@"%@/api/BookItems/request", ZNGIT_BASE_URL];
}
+ (NSString*)MyBookingItems
{
    return [NSString stringWithFormat:@"%@/api/BookItems/myBookingItems", ZNGIT_BASE_URL];
}
+ (NSString*)CreateStripeToken
{
    return [NSString stringWithFormat:@"%@/api/BookItems/createStripeToken", ZNGIT_BASE_URL];
}
@end
