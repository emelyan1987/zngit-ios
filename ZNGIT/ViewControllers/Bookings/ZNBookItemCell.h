//
//  ZNBookItemCell.h
//  ZNGIT
//
//  Created by LionStar on 3/9/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNBookItem.h"

@interface ZNBookItemCell : UITableViewCell

- (void)bindModel:(ZNBookItem*)model;
@end
