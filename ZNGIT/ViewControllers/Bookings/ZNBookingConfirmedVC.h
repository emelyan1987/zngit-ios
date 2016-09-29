//
//  ZNBookingConfirmedVC.h
//  ZNGIT
//
//  Created by LionStar on 3/9/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRootVC.h"

@protocol ZNBookingConfirmedVCDelegate <NSObject>

- (void)btnGotitClickedOnConfirmDlg;

@end
@interface ZNBookingConfirmedVC : ZNRootVC

@property (nonatomic, strong) id<ZNBookingConfirmedVCDelegate> delegate;
@end
