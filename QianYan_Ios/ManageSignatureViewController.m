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
    [QYUser currentUser].coreUser.signature = self.signTextView.text ;
    
    [[QYUser currentUser].coreUser saveUserInfoComplection:^(id object, NSError *error) {
        if ( object && !error ) {
            QYDebugLog(@"设置签名成功") ;
            [QYUtils alert:@"设置签名成功"] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            QYDebugLog(@"设置签名失败") ;
            [QYUtils alertError:error] ;
        }
    }] ;
}

@end
