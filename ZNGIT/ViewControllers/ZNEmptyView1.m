//
//  ZNEmptyView.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNEmptyView1.h"

@interface ZNEmptyView1()


@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
- (IBAction)continueButtonClicked:(id)sender;
@end
@implementation ZNEmptyView1

+ (instancetype)createView {
    ZNEmptyView1 *lView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyView1" owner:self options:nil] lastObject];
    if ([lView isKindOfClass:[self class]]){
        return lView;
    } else {
        return nil;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _continueButton.layer.cornerRadius = _continueButton.frame.size.height/2;
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

- (IBAction)continueButtonClicked:(id)sender {
}
@end
