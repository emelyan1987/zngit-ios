//
//  ZNSettingsManager.h
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNSettingsManager : NSUserDefaults
+ (ZNSettingsManager*)sharedInstance;

- (void)setAccessToken:(NSString*)accessToken;
- (NSString*)getAccessToken;

- (void)setUserData:(NSDictionary*)userData;
- (NSDictionary*)getUserData;

- (void)setCategories:(NSArray*)categories;
- (NSArray*)getCategories;

- (void)addCreditCard:(NSDictionary*)cardData;
- (void)removeCreditCard:(NSString*)cardNumber;
- (void)setPrimaryCreditCard:(NSDictionary*)cardNumber;
- (NSArray*)getCreditCards;
- (NSDictionary*)getPrimaryCreditCard;

- (void)setTutorialHaveBeenShowed:(BOOL)showed;
- (BOOL)getTutorialHaveBeenShowed;
@end
