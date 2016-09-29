//
//  ZNRootVC.h
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZNNavTitleIconPosition) {
    ZNNavTitleIconRight              = 0,
    ZNNavTitleIconDown
};

@interface ZNRootVC : UIViewController
- (void)setNavigationBackButtonItem;
- (void)setNavigationBackButtonItemAsDismiss;
- (void)setNavigationBarTitle:(NSString*)title;
- (void)setNavigationBarTitle:(NSString*)title withIcon:(UIImage*)icon iconPosition:(ZNNavTitleIconPosition)position;

- (void)onBack;
@end
