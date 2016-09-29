//
//  ZNRoundLabel.m
//  ZNGIT
//
//  Created by LionStar on 3/8/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRoundLabel.h"

#define PADDING 10

@implementation ZNRoundLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
}
- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, PADDING, 0, PADDING))];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil], -PADDING-2, 0);
}


@end
