//
//  ZNCityCell.m
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNCityCell.h"

@interface ZNCityCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation ZNCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(NSDictionary *)data selected:(BOOL)selected
{
    _nameLabel.text = data[@"name"];
    
    if(selected)
    {
        _selectedImageView.hidden = NO;
        _nameLabel.textColor = ZNGIT_MAIN_COLOR;
    }
    else
    {
        _selectedImageView.hidden = YES;
        _nameLabel.textColor = UIColorFromRGB(0x7B7B7B);
    }
}
@end
