//
//  ZNEmptyView.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNEmptyView : UIView

+(instancetype)createView;

@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, strong) NSString *message;
@end
