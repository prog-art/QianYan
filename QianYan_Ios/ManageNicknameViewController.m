//
//  ManageNicknameViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ManageNicknameViewController.h"

#import "QY_Common.h"

@interface ManageNicknameViewController ()

@property (strong, nonatomic) IBOutlet UITextField *changeNameTextfield;

@end

@implementation ManageNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (IBAction)doneBtnClicked:(id)sender {
    QY_user *user = [QYUser currentUser].coreUser ;
    
    user.nickname = self.changeNameTextfield.text ;
    
    [SVProgressHUD show] ;
    [user saveUserInfoComplection:^(id object, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( object && !error ) {
            QYDebugLog(@"设置昵称成功") ;
            [QYUtils alert:@"设置昵称成功"] ;
            [[QY_Notify shareInstance] postUserInfoNotify] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            QYDebugLog(@"设置昵称失败") ;
            [QYUtils alertError:error] ;
        }
    }] ;
}

@end
