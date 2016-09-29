//
//  ZNShop.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNShop.h"

@implementation ZNShop

+(instancetype)initWithData:(NSDictionary *)data
{
    ZNShop *obj = [[ZNShop alloc] init];
    
    if(data[@"id"]) obj.id = data[@"id"];
    if(data[@"name"]) obj.name = data[@"name"];
    if(data[@"phone"]) obj.phone = notNullValue(data[@"phone"]);
    if(data[@"email"]) obj.email = notNullValue(data[@"email"]);
    
    if(data[@"account_number"]) obj.accountNumber = notNullValue(data[@"account_number"]);
    if(data[@"routing_number"]) obj.routingNumber = notNullValue(data[@"routing_number"]);
    
    if(data[@"open_time_mon"]) obj.openTimeMon = notNullValue(data[@"open_time_mon"]);
    if(data[@"close_time_mon"]) obj.closeTimeMon = notNullValue(data[@"close_time_mon"]);
    if(data[@"open_time_tue"]) obj.openTimeTue = notNullValue(data[@"open_time_tue"]);
    if(data[@"close_time_tue"]) obj.closeTimeTue = notNullValue(data[@"close_time_tue"]);
    if(data[@"open_time_wed"]) obj.openTimeWed = notNullValue(data[@"open_time_wed"]);
    if(data[@"close_time_wed"]) obj.closeTimeWed = notNullValue(data[@"close_time_wed"]);
    if(data[@"open_time_thu"]) obj.openTimeThu = notNullValue(data[@"open_time_thu"]);
    if(data[@"close_time_thu"]) obj.closeTimeThu = notNullValue(data[@"close_time_thu"]);
    if(data[@"open_time_fri"]) obj.openTimeFri = notNullValue(data[@"open_time_fri"]);
    if(data[@"close_time_fri"]) obj.closeTimeFri = notNullValue(data[@"close_time_fri"]);
    if(data[@"open_time_sat"]) obj.openTimeSat = notNullValue(data[@"open_time_sat"]);
    if(data[@"close_time_sat"]) obj.closeTimeSat = notNullValue(data[@"close_time_sat"]);
    if(data[@"open_time_sun"]) obj.openTimeSun = notNullValue(data[@"open_time_sun"]);
    if(data[@"close_time_sun"]) obj.closeTimeSun = notNullValue(data[@"close_time_sun"]);
    
    if(data[@"timezone"]) obj.timezone = notNullValue(data[@"timezone"]);
    
    if(data[@"_address"])
    {
        obj.address = [ZNAddress initWithData:data[@"_address"]];
    }
    
    return obj;
    
}
@end
