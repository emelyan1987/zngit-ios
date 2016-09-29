//
//  NSDictionary+JSON.m
//  ZNGIT
//
//  Created by LionStar on 4/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary(JSON)
- (NSString *)toJSONString
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
@end
