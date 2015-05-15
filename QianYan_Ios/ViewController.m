//
//  ViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ViewController.h"

#import "QY_Socket.h"

#import "QYUtils.h"
#import "QYNotify.h"
#import <SystemConfiguration/CaptiveNetwork.h>

//二维码
#import "QY_QRCode.h"

@interface ViewController () <QY_SocketServiceDelegate,QY_QRCodeScanerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak) QYNotify *notify ;
@property (weak) QY_SocketService *socketService ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _notify = [QYNotify shareInstance] ;
    _socketService = [QY_SocketService shareInstance] ;
    _socketService.delegate = self ;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_notify removeJDASObserver:self] ;
    [_notify addJDASObserver:self selector:@selector(getIpandPort:)] ;
}

- (void)dealloc {
    [_notify removeJDASObserver:self] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notify 

-(void)getIpandPort:(NSNotification *)notification {
//    QYDebugLog(@"info = %@",notification.object) ;
    NSError *error = nil ;
    [_socketService connectToJRMHost:&error] ;
    [_socketService deviceLoginRequest] ;
    
//    if (notification.object[JDAS_DATA_JRM_IP_KEY] != nil) {
//        [_socketService connectToJRMHost:&error] ;
//        [_socketService sendMessage] ;
//    } else {
//        QYDebugLog(@"无效的Host") ;
//    }
}

#pragma mark -

- (NSDictionary *)fetchSSIDInfo {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

#pragma mark -

//- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
//    QYDebugLog(@"result %@",result) ;
//    [reader.navigationController popViewControllerAnimated:YES] ;
//}
//
//- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
//    QYDebugLog() ;
//    [reader.navigationController popViewControllerAnimated:YES] ;
//}

#pragma mark - IBAction

- (IBAction)testRegiste:(id)sender {
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 8, 15, 75)] ;
    pickerView.showsSelectionIndicator = TRUE ;
    pickerView.backgroundColor = [UIColor blackColor] ;
    pickerView.delegate = self ;
    pickerView.dataSource = self ;
    [self.view addSubview:pickerView] ;
    
    
//    [[QY_SocketService shareInstance] userRegisteRequestWithName:@"793951780" Psd:@"123456"] ;
}
- (IBAction)testLogin:(id)sender {
//    [[QY_SocketService shareInstance] userLoginRequestWithName:@"793951780" Psd:@"123456"] ;
}
- (IBAction)testSocket:(id)sender {
    NSError *error = nil ;
    [_socketService connectToJDASHost:&error] ;
    [_socketService getJRMIPandJRMPORT] ;
    //    [_socketService connectToJRMHost:&error] ;
    //    [_socketService sendMessage] ;
}


- (IBAction)testQRCodeReader:(id)sender {
    //    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    //    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    //    reader.delegate = self;
    //    [self.navigationController pushViewController:reader animated:YES];
    [QY_QRCodeUtils startWithDelegater:self] ;
}

#pragma mark - QY_SocketServiceDelegate

- (void)QY_deviceLoginSuccessed:(BOOL)successed {
    QYDebugLog(@"\n %@",successed?@"成功":@"失败") ;
}

- (void)QY_userRegisteSuccessed:(BOOL)successed userId:(NSString *)userId {
    QYDebugLog(@"\n %@",successed?@"成功":@"失败") ;
}

- (void)QY_userLoginSuccessed:(BOOL)successed {
    QYDebugLog(@"\n %@",successed?@"成功":@"失败") ;
}

#pragma mark - QY_QRCodeScanerDelegate

/**
 *  成功扫描二维码
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr {
    QYDebugLog(@"result = %@",resultStr) ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan {
    QYDebugLog() ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3 ;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1 ;
}


@end
