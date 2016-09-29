//
//  ZNRentalItem.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRentalItem.h"

@implementation ZNRentalItem

+(instancetype)initWithData:(NSDictionary *)data
{
    ZNRentalItem *item = [[ZNRentalItem alloc] init];
    
    if(data[@"id"]) item.id = data[@"id"];
    if(data[@"category_id"]) item.categoryId = data[@"category_id"];
    if(data[@"name"]) item.name = data[@"name"];
    if(data[@"text"]) item.text = notNullValue(data[@"text"]);
    
    if(data[@"price_per_day"]) item.pricePerDay = data[@"price_per_day"];
    if(data[@"price_per_hour"]) item.pricePerHour = data[@"price_per_hour"];
    
    if(data[@"images"])
    {
        NSMutableArray *imageUrls = [NSMutableArray new];
        for(NSDictionary *image in data[@"images"])
        {
            [imageUrls addObject:[NSString stringWithFormat:@"%@%@", ZNGIT_BASE_URL, image[@"url"]]];
        }
        item.imageUrls = imageUrls;
    }
    
    if(data[@"shop"])
    {
        NSDictionary *shopData = data[@"shop"];
        
        ZNShop *shop = [ZNShop initWithData:shopData];
        item.shop = shop;
    }
    return item;
    
}
@end
