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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.inputEmailOrPhoneNumberTextField.delegate = self ;
    self.inputPasswordTextField.delegate = self ;
    
//    _socketService = [QY_SocketService shareInstance] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
//    _socketService.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - IBAction

- (IBAction)toRegisteBtnClicked:(id)sender {
    [QYUtils toRegiste] ;
}

- (IBAction)loginBtnClicked:(id)sender {
    //这里检测密码长度
    
    NSString *username = self.inputEmailOrPhoneNumberTextField.text ;
    NSString *password = self.inputPasswordTextField.text ;

    [QYUtils toMain] ;
    
#warning 测试完，下面代码注释去掉。
//    if ( [self isPasswordAvailable:password] && ![username isEqualToString:@""]) {
//        [QYUser loginName:username Password:password complection:^(BOOL success, NSError *error) {
//            if ( success ) {
//                QYDebugLog(@"登陆成功") ;
//                [QYUtils toMain] ;
//            } else {
//                QYDebugLog(@"登陆失败 error = %@",error) ;
//                [QYUtils alert:@"登陆失败"] ;
//            }
//        }] ;
//    }
    
    if ([self.inputPasswordTextField.text length] < 6) {
        //如果输入框内容小于6则弹出警告
        [QYUtils alert:@"密码不能少于6位"] ;
    }else if ([self.inputPasswordTextField.text length] > 20) { //如果输入框内容大于20则弹出警告
        self.inputPasswordTextField.text = [self.inputPasswordTextField.text substringToIndex:20];
        [QYUtils alert:@"密码不能多于20位"] ;
    }else {
        [QYUtils toMain];
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

//#pragma mark - QY_SocketServiceDelegate
//
///**
// *  252 用户登录结果
// *
// *  @param successed
// */
//- (void)QY_userLoginSuccessed:(BOOL)successed {
//    if ( successed ) {
//        [QYUtils toMain] ;
//    } else {
//        [QYUtils alert:@"登录失败"] ;
//    }
//}

@end
