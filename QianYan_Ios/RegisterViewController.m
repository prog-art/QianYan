//
//  ViewController.m
//  Login
//
//  Created by WardenAllen on 15/5/10.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "RegisterViewController.h"

#define ENGLISH_AND_NUMBERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.\n"

#import "QY_Common.h"

@interface RegisterViewController ()<UITextFieldDelegate> {
    BOOL _isAgree ;
}

@property (weak, nonatomic) IBOutlet UITextField *emailOrPhoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAgree = TRUE ;
    [self.agreeButton setImage:[UIImage imageNamed:@"同意按钮.jpg"] forState:UIControlStateNormal] ;
    
    self.emailOrPhoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - IBAction

- (IBAction)agreeBtnClicked:(id)sender {
    static NSString *agreeImageName = @"同意按钮.jpg" ;
    static NSString *disagreeImageName = @"同意按钮（不同意）.jpg" ;
    
    if ( _isAgree ) {
        self.registerButton.enabled = NO;
    } else {
        self.registerButton.enabled = YES;
    }
    
    _isAgree = _isAgree ^ TRUE ;
    
    NSString *imageFileName = _isAgree ? agreeImageName : disagreeImageName ;
    UIImage *btnImage = [UIImage imageNamed:imageFileName] ;
    
    [self.agreeButton setImage:btnImage forState:UIControlStateNormal] ;
}

- (IBAction)serviceProtocolBtnClicked:(id)sender {
}

- (IBAction)privacyPolicyBtnClicked:(id)sender {
}

- (IBAction)enrollBtnClicked:(id)sender {
    //判断是否时我们想要限定的那个输入框
    if ([self.passwordTextField.text length] < 6) {
        //如果输入框内容小于6则弹出警告
        [QYUtils alert:@"密码不能少于6位"];
    }
    if ([self.passwordTextField.text length] > 20) {
        //如果输入框内容大于20则弹出警告
        self.passwordTextField.text = [self.passwordTextField.text substringToIndex:20];
        [QYUtils alert:@"密码不能多于20位"];
    }
}

- (IBAction)toLoginBtnClicked:(id)sender {
    [QYUtils toLogin] ;
}

- (IBAction)QQLoginBtnClicked:(id)sender {
}

- (IBAction)WeixinLoginBtnClicked:(id)sender {
}

- (IBAction)WeiboLoginBtnClicked:(id)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ENGLISH_AND_NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"]) {
        //按会车可以改变
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
    [self.emailOrPhoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end