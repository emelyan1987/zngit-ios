//
//  ZNParentCategory.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNParentCategory.h"
#import "ZNSubCategory.h"
@implementation ZNParentCategory

-(instancetype)initWithData:(NSDictionary *)data
{
    self = [[ZNParentCategory alloc] init];
    if(data[@"id"]) self.id = data[@"id"];
    if(data[@"name"]) self.name = notNullValue(data[@"name"]);
    if(data[@"text"]) self.text = notNullValue(data[@"text"]);
    
    if(data[@"images"])
    {
        NSMutableArray *imageUrls = [NSMutableArray new];
        for(NSDictionary *image in data[@"images"])
        {
            [imageUrls addObject:[NSString stringWithFormat:@"%@%@", ZNGIT_BASE_URL, [image[@"url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        }
        self.imageUrls = imageUrls;
    }
    if(data[@"subCategories"])
    {
        NSMutableArray *subCategories = [NSMutableArray new];
        for(NSDictionary *subCategoryItem in data[@"subCategories"])
        {
            [subCategories addObject:[[ZNSubCategory alloc] initWithData:subCategoryItem]];
        }
        self.subCategories = subCategories;
    }
    
    if(data[@"updated_time"]) self.updatedTime = notNullValue(data[@"updated_time"]);
    return self;
    
}
@end
