//
//  ZNChangeEmailVC.h
//  ZNGIT
//
//  Created by LionStar on 4/17/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNRootVC.h"

@protocol ZNChangeEmailVCDelegate <NSObject>
- (void)userEmailChanged:(NSString*)email;
@end
@interface ZNChangeEmailVC : ZNRootVC

@property (nonatomic, strong) id<ZNChangeEmailVCDelegate> delegate;
@end
