//
//  ZNAPIManager.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNNetworkManager.h"
#import "ZNUser.h"
#import "ZNBookItem.h"

typedef void (^ZNAPICompletionHandler)(id result, BOOL success);

@interface ZNAPIManager : NSObject

@property (nonatomic, strong) ZNNetworkManager *networkManager;

+ (ZNAPIManager *)sharedInstance;

- (void)createUser:(ZNUser*)user completion:(ZNAPICompletionHandler)handler;
- (void)signupWithFacebook:email name:(NSString*)name completion:(ZNAPICompletionHandler)handler;
- (void)changeEmail:(NSInteger)userId email:(NSString*)email completion:(ZNAPICompletionHandler)handler;
- (void)changePassword:(NSInteger)userId password:(NSString*)password completion:(ZNAPICompletionHandler)handler;
- (void)login:(NSString *)email password:(NSString*)password completion:(ZNAPICompletionHandler)handler;
- (void)loginWithFacebook:(NSString *)email completion:(ZNAPICompletionHandler)handler;
- (void)loginByAccessToken:(NSString *)accessToken completion:(ZNAPICompletionHandler)handler;
- (void)resetPassword:(NSString *)email completion:(ZNAPICompletionHandler)handler;
- (void)logout:(ZNAPICompletionHandler)handler;
- (void)requestBook:(ZNBookItem*)bookItem completion:(ZNAPICompletionHandler)handler;

- (NSArray*)getCategories:(ZNAPICompletionHandler)handler;


- (void)getRentalItemsWithParams:(NSDictionary*)params completion:(ZNAPICompletionHandler)handler;

- (void)validateCardData:(NSDictionary*)cardData completion:(ZNAPICompletionHandler)handler;

- (void)getMyBookingItems:(NSDictionary*)params completion:(ZNAPICompletionHandler)handler;

- (void)getCitiesFromGoogleWithKeyword:(NSString*)keyword completion:(ZNAPICompletionHandler)handler;
@end
