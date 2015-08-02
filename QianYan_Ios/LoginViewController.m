//
//  LoginViewController.m
//  Login
//
//  Created by WardenAllen on 15/5/10.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "LoginViewController.h"

#define ENGLISH_AND_NUMBERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.\n"

#import "QYUtils.h"
#import "QYUser.h"

@interface LoginViewController ()<UITextFieldDelegate>{
}

@property (weak, nonatomic) IBOutlet UITextField *inputEmailOrPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicatorView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.inputEmailOrPhoneNumberTextField.delegate = self ;
    self.inputPasswordTextField.delegate = self ;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_loginIndicatorView stopAnimating];
}

#pragma mark - IBAction

- (IBAction)toRegisteBtnClicked:(id)sender {
    [QYUtils toRegiste] ;
}

- (IBAction)loginBtnClicked:(id)sender {
    //这里检测密码长度
    
    [_loginIndicatorView startAnimating];
    
    NSString *username = self.inputEmailOrPhoneNumberTextField.text ;
    NSString *password = self.inputPasswordTextField.text ;
    
//#warning 测试用
//    username = @"18817870386" ;
//    password = @"1234567" ;

    if ( [self isPasswordAvailable:password] && ![username isEqualToString:@""]) {
        
        [QYUser loginName:username Password:password complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"登陆成功") ;
                [QYUtils toMain] ;
            } else {
                QYDebugLog(@"登陆失败 error = %@",error) ;
                [QYUtils alertError:error] ;
            }
        }] ;
    }
    
}

- (IBAction)retrievePasswordBtnClicked:(id)sender {
}

- (IBAction)QQLoginBtnClicked:(id)sender {
}

- (IBAction)WeixinLoginBtnClicked:(id)sender {
}

- (IBAction)WeiboLoginBtnClicked:(id)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //判断是否是中文，是中文不能输入
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
    [textField resignFirstResponder];  //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.inputEmailOrPhoneNumberTextField resignFirstResponder];
    [self.inputPasswordTextField resignFirstResponder];
}

#pragma mark - other method 

- (BOOL)isPasswordAvailable:(NSString *)password {
    
    if ( password.length < 6 ) {
        //如果输入框内容小于6则弹出警告
        [QYUtils alert:@"密码不能少于6位"] ;
        return FALSE ;
    }
    
    
    if ( password.length > 20 ) {
        self.inputPasswordTextField.text = [self.inputPasswordTextField.text substringToIndex:20];
        [QYUtils alert:@"密码不能多于20位"] ;
        return FALSE ;
    }
    
    return TRUE ;
}


@end
