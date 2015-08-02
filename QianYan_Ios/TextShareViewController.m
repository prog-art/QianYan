//
//  TextShareViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "TextShareViewController.h"

#import "QY_Common.h"

@interface TextShareViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textShareTextView;

@end

@implementation TextShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_textShareTextView becomeFirstResponder];
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
    NSString *str = self.textShareTextView.text ;
    [QYUtils alert:str] ;
}

@end
