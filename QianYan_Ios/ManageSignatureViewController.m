//
//  ManageSignatureViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ManageSignatureViewController.h"

#import "QY_Common.h"

@interface ManageSignatureViewController ()

@property (weak, nonatomic) IBOutlet UITextView *signTextView;

@end

@implementation ManageSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    QY_user *user = [QYUser currentUser].coreUser ;
    self.signTextView.text = user.signature ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark -- Actions

- (IBAction)doneBtnClicked:(id)sender {
    
    QY_user *user = [QYUser currentUser].coreUser ;
    
    if ( [user.signature isEqualToString:self.signTextView.text]) {
        [self.navigationController popViewControllerAnimated:YES] ;
        return ;
    }
    //不一致
   user.signature = self.signTextView.text ;

    [SVProgressHUD show] ;
    [[QYUser currentUser].coreUser saveUserInfoComplection:^(id object, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( object && !error ) {
            QYDebugLog(@"设置签名成功") ;
            [QYUtils alert:@"设置签名成功"] ;
            [[QY_Notify shareInstance] postUserInfoNotify] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            QYDebugLog(@"设置签名失败") ;
            [QYUtils alertError:error] ;
        }
    }] ;
}

@end
