//
//  ZNBookItem.h
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNRentalItem.h"
#import "ZNUser.h"

typedef NS_ENUM(NSInteger, BookingType) {
    Hourly = 0,
    Daily
};

@interface ZNBookItem : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) ZNRentalItem *rentalItem;

@property (nonatomic, assign) BookingType type;
@property (nonatomic, assign) NSNumber *quantity;

@property (nonatomic, strong) NSDate *pickupDate;
@property (nonatomic, strong) NSNumber *pickupTime; // minutes from 00:00 AM

@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, assign) NSNumber *rentalHours;

@property (nonatomic, strong) ZNUser *renter;


@property (nonatomic, strong) NSDictionary *cardData;   // "number": card number, "exp_month": expire month,
                                                        // "exp_year": expire year, "cvc": cvc

@property (nonatomic, strong) NSString *cardBrand;      // Visa, MasterCard, American Express, ....
@property (nonatomic, strong) NSString *cardLast4;      // Last 4 digit for card number ,etc 4242



+ (instancetype)initWithRentalItem:(ZNRentalItem *)rentalItem;
+ (instancetype)initWithData:(NSDictionary*)data;

- (double)getSubTotalPrice;
- (double)getTotalPrice;

- (NSDictionary*)toDictionary;
@end
