//
//  ZNPasswordSent.h
//  ZNGIT
//
//  Created by LionStar on 3/4/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNRootVC.h"

@protocol ZNPasswordSentVCDelegate <NSObject>

- (void)btnGotitClickedOnConfirmDlg;

@end
@interface ZNPasswordSentVC : ZNRootVC

@property (nonatomic, strong) id<ZNPasswordSentVCDelegate> delegate;
@end
