//
//  FeedbackViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "FeedbackViewController.h"
#import "QYUtils.h"

@interface FeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_feedbackTextView becomeFirstResponder];
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

- (IBAction)doneBtnClicked:(id)sender {
    [QYUtils alert:@"意见反馈接口。"] ;
}

@end
