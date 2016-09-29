//
//  ZNRentalItemCell.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRentalItemCell.h"

#import "FXBlurView.h"
#import "ZNRoundLabel.h"

#import <AFNetworking/UIImageView+AFNetworking.h>


@interface ZNRentalItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *pricePerDayLabel;
@property (weak, nonatomic) IBOutlet ZNRoundLabel *pricePerHourLabel;
@end
@implementation ZNRentalItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    
    _blurView.tintColor = [UIColor whiteColor];
}

- (void)bindModel:(ZNRentalItem *)model
{
    _nameLabel.text = model.name;
    
    
    _pricePerDayLabel.text = [NSString stringWithFormat:@"$%.2f per day", [model.pricePerDay doubleValue]];
    _pricePerHourLabel.text = [NSString stringWithFormat:@"$%.2f per hour", [model.pricePerHour doubleValue]];
    
    UIImage *placeholder = [UIImage imageNamed:@"placeholder.png"];
    [_imageView setImage:placeholder];
    if(model.imageUrls && model.imageUrls.count)
    {
        NSString* imageUrl = model.imageUrls[0];
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
    }
    
}
@end
