//
//  ZNSignupEnterEmailVC.h
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZNRootVC.h"
#import "ZNUser.h"


@interface ZNSignupVC : ZNRootVC

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZNUser *user;

@property (nonatomic, assign) BOOL isNeedLogin;

@end
