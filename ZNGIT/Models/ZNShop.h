//
//  ZNShop.h
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNAddress.h"

@interface ZNShop : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *routingNumber;

@property (nonatomic, strong) NSNumber *openTimeMon;    // minutes from 00:00 AM
@property (nonatomic, strong) NSNumber *closeTimeMon;
@property (nonatomic, strong) NSNumber *openTimeTue;
@property (nonatomic, strong) NSNumber *closeTimeTue;
@property (nonatomic, strong) NSNumber *openTimeWed;
@property (nonatomic, strong) NSNumber *closeTimeWed;
@property (nonatomic, strong) NSNumber *openTimeThu;
@property (nonatomic, strong) NSNumber *closeTimeThu;
@property (nonatomic, strong) NSNumber *openTimeFri;
@property (nonatomic, strong) NSNumber *closeTimeFri;
@property (nonatomic, strong) NSNumber *openTimeSat;
@property (nonatomic, strong) NSNumber *closeTimeSat;
@property (nonatomic, strong) NSNumber *openTimeSun;
@property (nonatomic, strong) NSNumber *closeTimeSun;

@property (nonatomic, strong) NSString *timezone;

@property (nonatomic, strong) ZNAddress *address;

+(instancetype)initWithData:(NSDictionary *)data;
@end
