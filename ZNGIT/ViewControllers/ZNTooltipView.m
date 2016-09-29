//
//  ZNTooltipView.m
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNTooltipView.h"

@interface ZNTooltipView()

@end
@implementation ZNTooltipView

+ (instancetype)createView
{
    ZNTooltipView *lView = [[[NSBundle mainBundle] loadNibNamed:@"TooltipView" owner:self options:nil] lastObject];
    if ([lView isKindOfClass:[self class]]){
        return lView;
    } else {
        return nil;
    }
}
- (void)awakeFromNib
{
    self.layer.cornerRadius = 5.0f;
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLabel.text = message;
}

- (void)setFrameImage:(UIImage *)frameImage
{
    _frameImage = frameImage;
    _frameImageView.image = frameImage;
}
@end
