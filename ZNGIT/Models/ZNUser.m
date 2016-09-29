//
//  ZNUser.m
//  ZNGIT
//
//  Created by LionStar on 4/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNUser.h"

@implementation ZNUser

+ (instancetype)initWithDictionary:(NSDictionary *)dict
{
    ZNUser *user = [[ZNUser alloc] init];
    
    user.id = dict[@"id"];
    user.fullname = dict[@"fullname"];
    user.email = dict[@"email"];
    user.password = dict[@"password"];
    user.type = dict[@"type"];
    
    return user;
}
- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if(self.fullname) [dict setObject:self.fullname forKey:@"fullname"];
    if(self.email) [dict setObject:self.email forKey:@"email"];
    if(self.password) [dict setObject:self.password forKey:@"password"];
    if(self.type) [dict setObject:self.type forKey:@"type"];
    
    return dict;
    
}

@end
