//
//  ZNStartNC.m
//  ZNGIT
//
//  Created by LionStar on 4/22/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNStartNC.h"
#import "AppDelegate.h"
#import "ZNWelcomeVC.h"

@interface ZNStartNC ()

@end

@implementation ZNStartNC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Checking whether the app has the right access token already
    NSString *accessToken = [[ZNSettingsManager sharedInstance] getAccessToken];
    if(accessToken)
    {
        if([AppDelegate sharedInstance].currentUser)
        {
            [[ZNAPIManager sharedInstance] loginByAccessToken:accessToken completion:^(id result, BOOL success)
             {
                 if(success)
                 {
                     [AppDelegate sharedInstance].currentUser = [ZNUser initWithDictionary:result[@"user"]];
                 }
             }];
        }
        
        ZNMainTabBarController *mainTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNMainTabBarController"];
        [AppDelegate sharedInstance].mainTabBarController = mainTVC;
        
        [self pushViewController:mainTVC animated:YES];
    }
    else
    {
        ZNWelcomeVC *welcomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZNWelcomeVC"];
        [self pushViewController:welcomeVC animated:YES];
    }
    
    [AppDelegate sharedInstance].startNC = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
