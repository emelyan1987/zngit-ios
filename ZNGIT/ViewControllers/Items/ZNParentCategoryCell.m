//
//  ZNParentCategoryCell.m
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNParentCategoryCell.h"
#import "FXBlurView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+Network.h"

@interface ZNParentCategoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
@implementation ZNParentCategoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    
    _blurView.tintColor = [UIColor whiteColor];
}

- (void)bindModel:(ZNParentCategory *)model
{
    _nameLabel.text = model.name;
    _textLabel.text = model.text;
    
    UIImage *placeholder = [UIImage imageNamed:@"placeholder.png"];
    [_imageView setImage:placeholder];
    if(model.imageUrls && model.imageUrls.count)
    {
        NSString* imageUrl = model.imageUrls[0];
        //[_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
        [_imageView loadImageFromURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder cachingKey:[imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    }
}
@end
