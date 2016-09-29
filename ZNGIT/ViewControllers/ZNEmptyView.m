//
//  ZNEmptyView.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNEmptyView.h"

@interface ZNEmptyView()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
@implementation ZNEmptyView

+ (instancetype)createView {
    ZNEmptyView *lView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil] lastObject];
    if ([lView isKindOfClass:[self class]]){
        return lView;
    } else {
        return nil;
    }
}

- (void)setLogoImage:(UIImage *)image
{
    _logoImage = image;
    _logoImageView.image = image;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLabel.text = message;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
