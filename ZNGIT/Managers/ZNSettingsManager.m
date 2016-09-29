//
//  ZNSettingsManager.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSettingsManager.h"

#define TUTORIAL_HAVE_BEEN_SHOWED @"kTutorialHaveBeenShowed"
#define CREDIT_CARDS @"kCreditCards"
#define PRIMARY_CREDIT_CARD @"kPrimaryCreditCard"
#define ACCESS_TOKEN @"kAccessToken"
#define USER_DATA @"kUserData"
#define CATEGORIES @"kCategories"


@implementation ZNSettingsManager

+ (ZNSettingsManager*)sharedInstance
{
    static ZNSettingsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZNSettingsManager new];
    });
    return instance;
}

- (void)setAccessToken:(NSString *)accessToken
{
    [self setObject:accessToken forKey:ACCESS_TOKEN];
}
- (NSString*)getAccessToken
{
    return [self objectForKey:ACCESS_TOKEN];
}

- (void)setUserData:(NSDictionary *)userData
{
    [self setObject:userData forKey:USER_DATA];
}
- (NSDictionary*)getUserData
{
    return [self objectForKey:USER_DATA];
}

- (void)setCategories:(NSArray *)categories
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categories];
    
    [self setObject:data forKey:CATEGORIES];
}
- (NSArray*)getCategories
{
    NSData *data = [self objectForKey:CATEGORIES];
    
    NSArray *categories = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return categories;
}

- (void)setTutorialHaveBeenShowed:(BOOL)showed
{
    [self setObject:@(showed) forKey:TUTORIAL_HAVE_BEEN_SHOWED];
}

- (BOOL)getTutorialHaveBeenShowed
{
    NSNumber *obj = [self objectForKey:TUTORIAL_HAVE_BEEN_SHOWED];
    
    if(obj)
        return [[self objectForKey:TUTORIAL_HAVE_BEEN_SHOWED] boolValue];
    
    return NO;
}
- (void)addCreditCard:(NSDictionary *)cardData
{
    NSArray *cards = [self getCreditCards];
    
    NSMutableArray *mutableCards = [NSMutableArray new];
    
    if(cards!=nil && cards.count) [mutableCards addObjectsFromArray:cards];
    
    [mutableCards addObject:cardData];
    
    [self setValue:mutableCards forKey:CREDIT_CARDS];
    [self setPrimaryCreditCard:cardData];
}

- (void)removeCreditCard:(NSString *)cardNumber
{
    NSArray *cards = [self getCreditCards];
    
    NSMutableArray *mutableCards = [NSMutableArray new];
    
    if(cards!=nil && cards.count) [mutableCards addObjectsFromArray:cards];
    
    for(NSDictionary *data in mutableCards)
    {
        if([cardNumber isEqualToString:data[@"number"]])
        {
            [mutableCards removeObject:data]; break;
        }
    }
    
    [self setValue:mutableCards forKey:CREDIT_CARDS];
    
    NSDictionary *primaryCard = [self getPrimaryCreditCard];
    if(primaryCard!=nil && [primaryCard[@"number"] isEqualToString:cardNumber])
        [self setPrimaryCreditCard:nil];
}

- (void)setPrimaryCreditCard:(NSDictionary *)cardData
{
    [self setObject:cardData forKey:PRIMARY_CREDIT_CARD];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_PRIMARY_CREDIT_CARD_CHANGED object:nil];
}

- (NSArray*)getCreditCards
{
    return [self objectForKey:CREDIT_CARDS];
}

- (NSDictionary*)getPrimaryCreditCard
{
    return [self objectForKey:PRIMARY_CREDIT_CARD];
}

@end
