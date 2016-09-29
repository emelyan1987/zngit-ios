//
//  ZNTooltipView.h
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNTooltipView : UIView

+ (instancetype)createView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *frameImage;
@end
