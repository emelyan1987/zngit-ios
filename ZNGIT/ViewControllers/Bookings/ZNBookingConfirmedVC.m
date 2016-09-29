//
//  ZNBookingConfirmedVC.m
//  ZNGIT
//
//  Created by LionStar on 3/9/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNBookingConfirmedVC.h"

@interface ZNBookingConfirmedVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnGotit;

@end

@implementation ZNBookingConfirmedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _btnGotit.layer.cornerRadius = _btnGotit.frame.size.height/2;
    
    _bgView.layer.cornerRadius = 5.0f;
    _bgView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGotitClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(btnGotitClickedOnConfirmDlg)])
        [self.delegate btnGotitClickedOnConfirmDlg];
}


@end
