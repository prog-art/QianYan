//
//  ManageNicknameViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "PhoneNumberIdentifyViewController.h"

#import "QY_Common.h"

#define NUMBERS @"0123456789\n"

@interface PhoneNumberIdentifyViewController () <UITextFieldDelegate> {
    NSString *_valiedateCode ;
}

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *idenCodeTextField;

@property (strong, nonatomic) IBOutlet UIButton *getCodeButton;

@property (assign) int time;

@end

@implementation PhoneNumberIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberTextField.delegate = self;
    self.idenCodeTextField.delegate = self;
    _time = 59;
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

- (IBAction)getCodeBtnClicked:(id)sender {
    if ([self.phoneNumberTextField.text length] != 11) {
        //[QYUtils alert:@"请输入正确的手机号"];
    }
    
    [self.getCodeButton setEnabled:NO];
    [self.getCodeButton setTitle:@"60" forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateButtonName:) userInfo:nil repeats:NO];

    _valiedateCode = [QYUtils getAValidateCodeLength:6] ;
    
    [[QYUser currentUser].coreUser applyValidateCodeForTelephone:self.phoneNumberTextField.text validateCode:_valiedateCode complection:nil] ;
}

- (IBAction)validateBtnClicked:(id)sender {
    
    if ( [_valiedateCode isEqualToString:self.idenCodeTextField.text] ) {
        //验证成功
        _valiedateCode = nil ;
        [[QYUser currentUser].coreUser saveTelephone:self.phoneNumberTextField.text Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"绑定成功") ;
                [QYUtils alert:@"绑定成功"] ;
                [self.navigationController popViewControllerAnimated:YES] ;
            } else {
                QYDebugLog(@"绑定失败 error = %@",error) ;
                [QYUtils alertError:error] ;
            }

        }] ;
        
    } else {
        [QYUtils alert:@"请输入正确的验证码"] ;
    }
}

- (void)UpdateButtonName:(NSTimer *)timer {
    if (_time == 0) {
        _time = 59;
        [_getCodeButton setEnabled:YES];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _valiedateCode = nil ;
    } else {
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%d", _time] forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _time --;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateButtonName:) userInfo:nil repeats:NO];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
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


@end
