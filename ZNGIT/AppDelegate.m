//
//  AppDelegate.m
//  ZNGIT
//
//  Created by Reflect Apps on 3/2/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "ZNAPIManager.h"
#import "ZNWelcomeVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *candidateVC;
@end

@implementation AppDelegate

+(instancetype)sharedInstance
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ZNLocationManager sharedInstance] startLocationService];
    
    [self loadCategories];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setUpCustomDesign];
    
    
    
    
    NSDictionary *userData = [[ZNSettingsManager sharedInstance] getUserData];
    
    if(userData)
        _currentUser = [ZNUser initWithDictionary:userData];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *accessToken = [[ZNSettingsManager sharedInstance] getAccessToken];
    if(accessToken)
    {
        //if([AppDelegate sharedInstance].currentUser)
        {
            [[ZNAPIManager sharedInstance] loginByAccessToken:accessToken completion:^(id result, BOOL success)
             {
                 if(success)
                 {
                     [AppDelegate sharedInstance].currentUser = [ZNUser initWithDictionary:result[@"user"]];
                 }
                 else
                 {
                     [AppDelegate sharedInstance].currentUser = nil;
                     [[ZNSettingsManager sharedInstance] setAccessToken:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_NEED_LOGIN object:nil];
                 }
             }];
        }
        
        ZNMainTabBarController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"ZNMainTabBarController"];
        
        
        self.window.rootViewController = mainVC;
        self.pushedWelcomeNC = NO;
    }
    else
    {
        UINavigationController *welcomeNC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeNC"];
        self.window.rootViewController = welcomeNC;
        self.pushedWelcomeNC = YES;
    }
    
    [self.window makeKeyAndVisible];
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)setUpCustomDesign {
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:ZNGIT_MAIN_COLOR
                                                           }];
    [[UINavigationBar appearance] setTintColor:ZNGIT_MAIN_COLOR];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBar appearance] setTintColor:ZNGIT_MAIN_COLOR];
}

- (void)loadCategories
{
    self.categories = [[ZNAPIManager sharedInstance] getCategories:^(id result, BOOL success) {
        if(success)
        {
            self.categories = result;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_CATEGORIES_UPDATED object:nil];
    }];
}
- (void)setCurrentUser:(ZNUser *)currentUser
{
    _currentUser = currentUser;
    [[ZNSettingsManager sharedInstance] setUserData:[currentUser toDictionary]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_CURRENT_USER_CHANGED object:nil];
}

- (void)setMainTabBarController:(ZNMainTabBarController *)mainTabBarController
{
    _mainTabBarController = mainTabBarController;
    _mainTabBarController.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ( viewController == [tabBarController.viewControllers objectAtIndex:0])
    {
        return YES;
    }
    else if(viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        ZNUser *currentUser = [AppDelegate sharedInstance].currentUser;
        if(!currentUser.id)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"NeedLoginNC"];
            
            [tabBarController presentViewController:nc animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInCanceled:) name:ZN_NOTIFICATION_SIGN_IN_CANCELED object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInSucceeded:) name:ZN_NOTIFICATION_SIGN_IN_SUCCEEDED object:nil];
            
            _candidateVC = viewController;
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (void)handleSignInSucceeded:(NSNotification*)notification
{
    _mainTabBarController.selectedViewController = _candidateVC;
}

- (void)handleSignInCanceled:(NSNotification*)notification
{
    [_mainTabBarController selectTab:0];
}

@end
