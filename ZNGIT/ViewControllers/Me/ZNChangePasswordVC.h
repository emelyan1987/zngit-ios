//
//  ZNChangePasswordVC.h
//  ZNGIT
//
//  Created by LionStar on 4/17/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNRootVC.h"

@protocol ZNChangePasswordVCDelegate <NSObject>
- (void)userPasswordChanged:(NSString*)password;
@end
@interface ZNChangePasswordVC : ZNRootVC
@property (strong, nonatomic) id<ZNChangePasswordVCDelegate> delegate;
@end
