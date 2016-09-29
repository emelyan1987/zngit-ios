//
//  ZNRentalItem.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNShop.h"

@interface ZNRentalItem : NSObject

@property (nonatomic, strong) ZNShop *shop;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSNumber *pricePerDay;
@property (nonatomic, strong) NSNumber *pricePerHour;
@property (nonatomic, strong) NSString *categoryId;

+(instancetype)initWithData:(NSDictionary *)data;
@end
