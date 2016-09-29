//
//  ZNUtils.h
//  ZNGIT
//
//  Created by LionStar on 3/6/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNUtils : NSObject

+ (BOOL)isYelpInstalled;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isNumeric:(NSString *)text;
+ (BOOL)isValidExpireDateFormat:(NSString*)dateString month:(out NSNumber**)month year:(out NSNumber**)year;
@end
