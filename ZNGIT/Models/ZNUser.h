//
//  ZNUser.h
//  ZNGIT
//
//  Created by LionStar on 4/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNUser : NSObject

@property NSNumber *id;
@property NSString *fullname;
@property NSString *email;
@property NSString *password;
@property NSString *type;

+ (instancetype)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;
@end
