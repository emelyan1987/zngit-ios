//
//  ZNSubCategory.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNSubCategory.h"

@implementation ZNSubCategory

-(instancetype)initWithData:(NSDictionary *)data
{
    self = [[ZNSubCategory alloc] init];
    if(data[@"id"]) self.id = data[@"id"];
    if(data[@"parent_id"]) self.parentId = data[@"parent_id"];
    if(data[@"name"]) self.name = data[@"name"];
    if(data[@"images"])
    {
        NSMutableArray *imageUrls = [NSMutableArray new];
        for(NSDictionary *image in data[@"images"])
        {
            [imageUrls addObject:[NSString stringWithFormat:@"%@%@", ZNGIT_BASE_URL, [image[@"url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        }
        self.imageUrls = imageUrls;
    }
    
    return self;
    
}
@end
