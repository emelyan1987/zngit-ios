//
//  ZNSubCategory.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNSubCategory : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *imageUrls;

-(instancetype)initWithData:(NSDictionary *)data;
@end
