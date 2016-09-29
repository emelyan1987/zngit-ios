//
//  ZNParentCategory.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNParentCategory : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *subCategories;
@property (nonatomic, strong) NSNumber *updatedTime;


- (instancetype)initWithData:(NSDictionary*)data;
@end
