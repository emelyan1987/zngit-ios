//
//  ZNBookItem.m
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNBookItem.h"
#import "NSDate+DateTools.h"

@implementation ZNBookItem

+ (instancetype)initWithRentalItem:(ZNRentalItem *)rentalItem
{
    ZNBookItem *item = [[ZNBookItem alloc] init];
    
    item.rentalItem = rentalItem;
    item.type = Daily;
    item.quantity = @(1);
    item.pickupDate = [NSDate date];
    item.returnDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:item.pickupDate];
    item.rentalHours = @(1);
    return item;
    
}
+ (instancetype)initWithData:(NSDictionary *)data
{
    //NSLog(@"ZNBookItemData: %@", data);
    ZNBookItem *bookItem = [[ZNBookItem alloc] init];
    
    if(data[@"id"]) bookItem.id = data[@"id"];
    if(data[@"type"]) bookItem.type = [data[@"type"] intValue];
    if(data[@"quantity"]) bookItem.quantity = data[@"quantity"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    if(data[@"pickup_date"] && ![data[@"pickup_date"] isEqual:[NSNull null]]) bookItem.pickupDate = [dateFormatter dateFromString:data[@"pickup_date"]];
    if(data[@"return_date"] && ![data[@"return_date"] isEqual:[NSNull null]]) bookItem.returnDate = [dateFormatter dateFromString:data[@"return_date"]];
    if(data[@"rental_hours"]) bookItem.rentalHours = data[@"rental_hours"];
    
    
    if(data[@"pickup_time"]) bookItem.pickupTime = data[@"pickup_time"];
    
    
    if(data[@"renter"])
    {
        bookItem.renter = [ZNUser initWithDictionary:data[@"renter"]];
    }
    
    if(data[@"card_last4"] && ![data[@"card_last4"] isEqual:[NSNull null]]) bookItem.cardLast4 = data[@"card_last4"];
    
    if(data[@"card_brand"] && ![data[@"card_brand"] isEqual:[NSNull null]]) bookItem.cardBrand = data[@"card_brand"];
    
    if(data[@"rentalItem"])
    {
        ZNRentalItem *rentalItem = [ZNRentalItem initWithData:data[@"rentalItem"]];
        bookItem.rentalItem = rentalItem;
    }
    
    return bookItem;
    
}

-(double)getSubTotalPrice
{
    NSInteger quantity = [self.quantity integerValue];
    if(self.type == Daily)
        return quantity * [self.rentalItem.pricePerDay doubleValue] * ([self.returnDate daysFrom:self.pickupDate]+1);
    else
        return quantity * [self.rentalItem.pricePerHour doubleValue] * [self.rentalHours intValue];
}

-(double)getTotalPrice
{
    double subTotalPrice = [self getSubTotalPrice];
    return subTotalPrice + subTotalPrice * 5 / 100 + RENTAL_SERVICE_FEE;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if(self.id) [dict setObject:self.id forKey:@"id"];
    [dict setObject:@(self.type) forKey:@"type"];
    if(self.quantity) [dict setObject:self.quantity forKey:@"quantity"];
    if(self.pickupDate) [dict setObject:[self.pickupDate formattedDateWithFormat:@"YYYY-MM-dd"] forKey:@"pickup_date"];
    if(self.pickupTime) [dict setObject:self.pickupTime forKey:@"pickup_time"];
    if(self.returnDate) [dict setObject:[self.returnDate formattedDateWithFormat:@"YYYY-MM-dd"] forKey:@"return_date"];
    if(self.rentalHours) [dict setObject:self.rentalHours forKey:@"rental_hours"];
    
    
    if(self.cardLast4) [dict setObject:self.cardLast4 forKey:@"card_last4"];
    if(self.cardBrand) [dict setObject:self.cardBrand forKey:@"card_brand"];
    
    if(self.cardData) [dict setObject:self.cardData forKey:@"card_data"];
    
    if(self.rentalItem) [dict setObject:self.rentalItem.id forKey:@"item_id"];
    
    return dict;
}
@end
