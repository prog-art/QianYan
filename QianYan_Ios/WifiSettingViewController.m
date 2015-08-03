//
//  WifiSettingViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/7/1.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "AppDelegate.h"

@interface WifiSettingViewController ()

@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;

@property (strong, nonatomic) IBOutlet UIButton *autoSearchBtn;

@property BOOL agree;

@end

@implementation WifiSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _agree = NO;
}

#pragma mark -- Actions

- (IBAction)autoSearchBtnClicked:(id)sender {
    [self.navigationController pushViewController:[[AppDelegate globalDelegate] WifiListViewController] animated:YES];
}

- (IBAction)agreeBtnClicked:(id)sender {
    if (_agree) {
        [_agreeBtn setImage:[UIImage imageNamed:@"二维码配置wifi-同意"] forState:UIControlStateNormal];
        [_autoSearchBtn setEnabled:YES];
        _agree = NO;
    } else {
       [_agreeBtn setImage:[UIImage imageNamed:@"二维码配置wifi-不同意"] forState:UIControlStateNormal];
        [_autoSearchBtn setEnabled:NO];
        _agree = YES;
    }
}

#pragma mark - back

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end
