//
//  ZNPaymentMethodCell.m
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNPaymentMethodCell.h"
#import "ZNSettingsManager.h"

@interface ZNPaymentMethodCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end
@implementation ZNPaymentMethodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(NSDictionary *)data
{
    NSString *cardNumber = data[@"number"];
    NSString *last4 = [cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)];
    
    _cardNumberLabel.text = [NSString stringWithFormat:@"••••%@", last4];
    
    
    NSDictionary *primaryCard = [[ZNSettingsManager sharedInstance] getPrimaryCreditCard];
    
    if(primaryCard!=nil && [primaryCard[@"number"] isEqualToString:cardNumber])
    {
        _commentLabel.text = @"Primary Payment Method";
        _checkImageView.hidden = NO;
    }
    else
    {
        _commentLabel.text = @"Secondary Payment Method";
        _checkImageView.hidden = YES;
    }
    
}
@end
