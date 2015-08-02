//
//  PasswordManageViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "PasswordManageViewController.h"
#import "QY_Common.h"

#define ENGLISH_AND_NUMBERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.\n"

@interface PasswordManageViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *showPasswordBtn;

@property (assign) BOOL isShowPassword;

@end

@implementation PasswordManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isShowPassword = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark -- IBAction

- (IBAction)doneBtnClicked:(id)sender {
    //判断是否时我们想要限定的那个输入框
    if ([self.oldPasswordTextField.text length] < 6 || [self.passwordTextField.text length] < 6) {
        //如果输入框内容小于6则弹出警告
        [QYUtils alert:@"密码不能少于6位"];
    }
    if ([self.oldPasswordTextField.text length] > 20 || [self.passwordTextField.text length] > 20) {
        //如果输入框内容大于20则弹出警告
        self.passwordTextField.text = [self.passwordTextField.text substringToIndex:20];
        [QYUtils alert:@"密码不能多于20位"];
    }
    
    if ([self.oldPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        [QYUtils alert:@"新密码不能与旧密码相同"];
    }
}

- (IBAction)showPasswordBtnClicked:(id)sender {
    if (_isShowPassword) {
        [_showPasswordBtn setImage:[UIImage imageNamed:@"显示密码.png"] forState:UIControlStateNormal];
        _isShowPassword = NO;
        _oldPasswordTextField.secureTextEntry = YES;
        _passwordTextField.secureTextEntry = YES;
    } else {
        [_showPasswordBtn setImage:[UIImage imageNamed:@"显示密码（选中）.png"] forState:UIControlStateNormal];
        _isShowPassword = YES;
        _oldPasswordTextField.secureTextEntry = NO;
        _passwordTextField.secureTextEntry = NO;
    }
}

- (IBAction)changeBtnClicked:(id)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH_AND_NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"]) {
        //按回车可以改变
        return YES;
    }
    
    return canChange;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
    
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.oldPasswordTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
