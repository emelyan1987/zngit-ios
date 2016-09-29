//
//  ZNBookItemCell.m
//  ZNGIT
//
//  Created by LionStar on 3/9/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNBookItemCell.h"
#import "NSDate+DateTools.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+Network.h"

@interface ZNBookItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCityLabel;

@end

@implementation ZNBookItemCell

- (void)awakeFromNib {
    // Initialization code
    
    _priceView.layer.borderWidth = 1.0f;
    _priceView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _priceView.layer.cornerRadius = 5.0f;
    
    _dateView.layer.borderWidth = 1.0f;
    _dateView.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
    _dateView.layer.cornerRadius = 5.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(ZNBookItem *)model
{
    NSArray *imageUrls = model.rentalItem.imageUrls;
    UIImage *placeholder = [UIImage imageNamed:@"placeholder.png"];
    [_photoImageView setImage:placeholder];
    if(imageUrls && imageUrls.count)
    {
        NSString* imageUrl = imageUrls[0];
        //[_photoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
        [_photoImageView loadImageFromURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder cachingKey:[imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    }

    _nameLabel.text = model.rentalItem.name;
    _priceLabel.text = [NSString stringWithFormat:@"$%.2f    ", [model getTotalPrice]];
    
    NSString *pickupDateString = [model.pickupDate formattedDateWithFormat:@"MMM d  "];
    _dateLabel.text = pickupDateString;
    _shopNameLabel.text = model.rentalItem.shop.name;
    
    _pickupTimeLabel.text = [NSString stringWithFormat:@"Pickup on %@ at %@ at:", [model.pickupDate formattedDateWithFormat:@"M/d"], [NSDate formattedTimeFromMinutes:[model.pickupTime intValue]]];
    
    ZNShop *shop = model.rentalItem.shop;
    _shopStreetLabel.text = shop.address.street;
    _shopCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", shop.address.city, shop.address.state, shop.address.zip];
    
}
@end
