//
//  AppDelegate.h
//  ZNGIT
//
//  Created by Reflect Apps on 3/2/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNLocationManager.h"
#import "ZNMainTabBarController.h"
#import "ZNUser.h"
#import "ZNSettingsManager.h"
#import "ZNAPIManager.h"
#import "ZNStartNC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(instancetype)sharedInstance;

@property (nonatomic, strong) ZNStartNC *startNC;
@property (nonatomic, strong) ZNMainTabBarController *mainTabBarController;

@property (nonatomic, strong) ZNUser *currentUser;
@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, assign) BOOL pushedWelcomeNC;

@end

