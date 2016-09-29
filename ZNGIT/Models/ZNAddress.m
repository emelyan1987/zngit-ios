//
//  ZNAddress.m
//  ZNGIT
//
//  Created by LionStar on 4/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNAddress.h"

@implementation ZNAddress
+(instancetype)initWithData:(NSDictionary *)data
{
    ZNAddress *obj = [[ZNAddress alloc] init];
    
    
    if(data[@"street"]) obj.street = notNullValue(data[@"street"]);
    if(data[@"city"]) obj.city = notNullValue(data[@"city"]);
    if(data[@"state"]) obj.state = notNullValue(data[@"state"]);
    if(data[@"zip"]) obj.zip = notNullValue(data[@"zip"]);
    if(data[@"country"]) obj.country = notNullValue(data[@"country"]);
    
    if(data[@"location"])
    {
        CLLocationCoordinate2D location;
        location.latitude = [data[@"location"][@"lat"] doubleValue];
        location.longitude = [data[@"location"][@"lng"] doubleValue];
        
        obj.location = location;
    }
    
    return obj;
    
}
@end
