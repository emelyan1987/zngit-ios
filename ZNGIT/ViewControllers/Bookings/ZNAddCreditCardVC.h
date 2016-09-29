//
//  ZNAddCreditCardVC.h
//  ZNGIT
//
//  Created by LionStar on 3/7/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRootVC.h"

@protocol ZNAddCreditCardVCDelegate <NSObject>
-(void)didAddCreditCardData;
@end
@interface ZNAddCreditCardVC : ZNRootVC

@property (nonatomic, strong) id<ZNAddCreditCardVCDelegate> delegate;
@end
