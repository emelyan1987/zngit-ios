//
//  ZNRentalItemCell.h
//  ZNGIT
//
//  Created by LionStar on 3/5/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNRentalItem.h"

@interface ZNRentalItemCell : UICollectionViewCell

- (void)bindModel:(ZNRentalItem*)model;
@end
