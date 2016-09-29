//
//  ZNAddress.h
//  ZNGIT
//
//  Created by LionStar on 4/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZNAddress : NSObject
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, assign) CLLocationCoordinate2D location;
+(instancetype)initWithData:(NSDictionary *)data;
@end
