//
//  ZNAPIManager.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNAPIManager.h"
#import "ZNParentCategory.h"
#import "ZNSubCategory.h"
#import "ZNRentalItem.h"
#import "ZNBookItem.h"
#import "NSDate+DateTools.h"
#import "ZNURL.h"
#import "ZNLocationManager.h"
#import "ZNUtils.h"
#import "ZNSettingsManager.h"



@implementation ZNAPIManager
+ (ZNAPIManager *)sharedInstance {
    static ZNAPIManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [ZNAPIManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkManager = [ZNNetworkManager sharedInstance];
    }
    return self;
}

- (void)createUser:(ZNUser *)user completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager POST:[ZNURL CreateUser]
                   parameters:[user toDictionary]
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
    {
         DLog(@"[ZNAPIManager] createUser succeeded with the result: %@", response);
         
         
         if(handler)
             handler(response, YES);
    }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] createUser failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}
- (void)signupWithFacebook:(id)email name:(NSString *)name completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager POST:[ZNURL SignupWithFacebook]
                   parameters:@{@"email":email,@"name":name}
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] singupWithFacebook succeeded with the result: %@", response);
         
         
         if([response isKindOfClass:[NSDictionary class]] && response[@"accessToken"])
         {
             NSDictionary *accessToken = response[@"accessToken"];
             
             [self.networkManager setAccessToken:accessToken[@"id"]];
             if(handler)
                 handler(accessToken, YES);
         }
         else
         {
             if(handler)
                 handler(nil, NO);
         }
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] singupWithFacebook failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}
- (void)changeEmail:(NSInteger)userId email:(NSString *)email completion:(ZNAPICompletionHandler)handler
{
    NSDictionary *params = @{@"email":email};
    
    [self.networkManager PUT:[ZNURL UpdateUserAttributes:userId]
                   parameters:params
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] changeEmail succeeded with the result: %@", response);
         
         
         if(handler)
             handler(response, YES);
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]
                                                               options:kNilOptions
                                                                 error:nil];
         
         DLog(@"[ZNAPIManager] changeEmail failed with the error: %@", result[@"error"]);
         if(handler)
             handler(result[@"error"], NO);
     }];
}

- (void)changePassword:(NSInteger)userId password:(NSString *)password completion:(ZNAPICompletionHandler)handler
{
    NSDictionary *params = @{@"password":password};
    
    [self.networkManager PUT:[ZNURL UpdateUserAttributes:userId]
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] changePassword succeeded with the result: %@", response);
         
         
         if(handler)
             handler(response, YES);
     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]
                                                                options:kNilOptions
                                                                  error:nil];
         
         DLog(@"[ZNAPIManager] changePassword failed with the error: %@", result[@"error"]);
         if(handler)
             handler(result[@"error"], NO);
     }];
}
- (void)login:(NSString *)email password:(NSString*)password completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager POST:[ZNURL Login]
                   parameters:@{@"email":email,@"password":password}
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] login succeeded with the result: %@", response);
         
         [self.networkManager setAccessToken:response[@"id"]];
         if(handler)
             handler(response, YES);
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] login failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}
- (void)loginWithFacebook:(NSString *)email completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager POST:[ZNURL LoginWithFacebook]
                   parameters:@{@"email":email}
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] loginWithFacebook succeeded with the result: %@", response);
         if([response isKindOfClass:[NSDictionary class]] && response[@"accessToken"])
         {
             NSDictionary *accessToken = response[@"accessToken"];
             
             [self.networkManager setAccessToken:accessToken[@"id"]];
             if(handler)
                 handler(accessToken, YES);
         }
         else
         {
             if(handler)
                 handler(nil, NO);
         }
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] loginWithFacebook failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}
- (void)loginByAccessToken:(NSString *)accessToken completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager setAccessToken:accessToken];
    [self.networkManager POST:[ZNURL LoginByAccessToken]
                   parameters:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] loginByAccessToken succeeded with the result: %@", response);
         
         if(handler)
             handler(response, YES);
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] loginByAccessToken failed with the error: %@", errorString);
         
         [self.networkManager setAccessToken:nil];
         if(handler)
             handler(nil, NO);
     }];
}
- (void)resetPassword:(NSString *)email completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager POST:[ZNURL ResetPassword]
                   parameters:@{@"email":email}
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] resetPassword succeeded with the result: %@", response);
         
         if(handler)
             handler(response, YES);
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] resetPassword failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}

- (void)logout:(ZNAPICompletionHandler)handler
{
    
    [self.networkManager POST:[ZNURL Logout]
                   parameters:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] logout succeeded with the result: %@", response);
         
         if(handler)
             handler(nil, YES);
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] logout failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}

- (void)requestBook:(ZNBookItem*)bookItem completion:(ZNAPICompletionHandler)handler
{
    NSDictionary *params = [bookItem toDictionary]; DLog(@"%@",params);
    [self.networkManager POST:[ZNURL RequestBook]
                   parameters:@{@"params":params}
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] requestBook succeeded with the result: %@", response);
         
         if(handler)
             handler(response, YES);
         
         [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_BOOKINGS_UPDATED object:nil];
     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         DLog(@"[ZNAPIManager] requestBook failed with the error: %@", errorString);
         
         if(handler)
             handler(nil, NO);
     }];
}

- (NSArray*)getCategories:(ZNAPICompletionHandler)handler
{
    NSDictionary *params = @{@"filter":@{@"include": @[@"images", @{@"subCategories":@"images"}]}};
    [self.networkManager GET:[ZNURL ParentCategories]
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] getCategories succeeded with the result: %@", response);
         NSArray *result = response;
         
         [[ZNSettingsManager sharedInstance] setCategories:result];
         
         NSMutableArray *categories = [NSMutableArray new];
         for(NSDictionary *item in result)
         {
             ZNParentCategory *category = [[ZNParentCategory alloc] initWithData:item];
             [categories addObject:category];
         }
         
         
         if(handler)
             handler(categories, YES);
     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] getCategories failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
    
    NSArray *result = [[ZNSettingsManager sharedInstance] getCategories];
    
    NSMutableArray *categories = [NSMutableArray new];
    for(NSDictionary *item in result)
    {
        ZNParentCategory *category = [[ZNParentCategory alloc] initWithData:item];
        [categories addObject:category];
    }
    
    return categories;
}




- (void)getRentalItemsWithParams:(NSDictionary *)params completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager GET:[ZNURL RentalItemsByLocation]
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] getRentalItemsWithParams succeeded with the result: %@", response);
         NSArray *result = response[@"items"];
         
         NSMutableArray *items = [NSMutableArray new];
         for(NSDictionary *item in result)
         {
             ZNRentalItem *rentalItem = [ZNRentalItem initWithData:item];
             [items addObject:rentalItem];
         }
         
         
         if(handler)
             handler(items, YES);
     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] getRentalItemsWithParams failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];    
}

- (void)validateCardData:(NSDictionary *)cardData completion:(ZNAPICompletionHandler)handler
{
    
    if(!cardData || !cardData[@"number"] || !cardData[@"exp_month"] || !cardData[@"exp_year"] || !cardData[@"cvc"])
    {
        if(handler)
            handler(nil, NO);
    }
    else
    {
        [self.networkManager POST:[ZNURL CreateStripeToken]
                       parameters:@{@"card":cardData}
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
         {
             DLog(@"[ZNAPIManager] validateCardData succeeded with the result: %@", response);
             
             if(handler)
                 handler(response, YES);
         }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
             
             DLog(@"[ZNAPIManager] validateCardData failed with the error: %@", errorString);
             if(handler)
                 handler(nil, NO);
         }];

    }
}

- (void)getMyBookingItems:(NSDictionary*)params completion:(ZNAPICompletionHandler)handler
{
    [self.networkManager GET:[ZNURL MyBookingItems]
                  parameters:@{@"params":params}
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         DLog(@"[ZNAPIManager] getMyBookingItems succeeded with the result: %@", response);
         NSArray *result = response[@"items"];
         
         NSMutableArray *items = [NSMutableArray new];
         for(NSDictionary *item in result)
         {
             ZNBookItem *booItem = [ZNBookItem initWithData:item];
             [items addObject:booItem];
         }
         
         
         if(handler)
             handler(items, YES);
     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *errorString = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         
         DLog(@"[ZNAPIManager] getMyBookingItems failed with the error: %@", errorString);
         if(handler)
             handler(nil, NO);
     }];
}

- (void)getCitiesFromGoogleWithKeyword:(NSString *)keyword completion:(ZNAPICompletionHandler)handler
{
    NSDictionary *params = @{
                             @"input": keyword,
                             @"types": @"geocode",
                             @"key": GOOGLE_API_KEY
                             };
    
    [self.networkManager GET:[ZNURL SearchCity]
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
    {
        DLog(@"[ZNAPIManager] getCitiesFromGoogleWithKeyword succeeded with the result: %@", response);
        NSArray *predictions = response[@"predictions"];
        
        NSMutableArray *result = [NSMutableArray new];
        for(NSDictionary *item in predictions)
        {
            [result addObject:item[@"description"]];
        }
        
        if(handler)
            handler(result, YES);
    }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DLog(@"[ZNAPIManager] getCitiesFromGoogleWithKeyword failed with the error: %@", error);
        if(handler)
            handler(nil, NO);
    }];
}
@end
