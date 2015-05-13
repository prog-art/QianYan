//
//  ViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ViewController.h"

#import "QY_Socket.h"

#import "QRCodeReaderViewController.h"

#import "QRCodeGenerator.h"

#import "QYUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "QYNotify.h"

@interface ViewController () <QRCodeReaderDelegate,QY_SocketServiceDelegate>

@property (weak) QYNotify *notify ;
@property (weak) QY_SocketService *socketService ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _notify = [QYNotify shareInstance] ;
    _socketService = [QY_SocketService shareInstance] ;
    _socketService.delegate = self ;
//    [self testQREncode] ;
//    WEAKSELF
//    [QYUtils runAfterSecs:10 block:^{
//        [weakSelf fetchSSIDInfo] ;
//    }] ;
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

- (void)testQREncode {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)] ;
    imageView.image = [QRCodeGenerator qrImageForString:@"Hello, world!" imageSize:imageView.bounds.size.width] ;
    [self.view addSubview:imageView] ;
}

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

- (IBAction)testSocket:(id)sender {
    NSError *error = nil ;
    [_socketService connectToJDASHost:&error] ;
    [_socketService getJRMIPandJRMPORT] ;
//    [_socketService connectToJRMHost:&error] ;
//    [_socketService sendMessage] ;
}


- (IBAction)testQRCodeReader:(id)sender {
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
//    __weak typeof (self) wSelf = self;
//    [reader setCompletionWithBlock:^(NSString *resultAsString) {
//        [wSelf.navigationController popViewControllerAnimated:YES];
//        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
//    }];
    
    [self.navigationController pushViewController:reader animated:YES];
}

#pragma mark -

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    QYDebugLog(@"result %@",result) ;
    [reader.navigationController popViewControllerAnimated:YES] ;
}

/**
 * @abstract Tells the delegate that the user wants to stop scanning QRCodes.
 * @param reader The reader view controller that the user wants to stop.
 * @since 1.0.0
 */
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    QYDebugLog() ;
    [reader.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark -

- (IBAction)testRegiste:(id)sender {
    [[QY_SocketService shareInstance] userRegisteRequestWithName:@"793951780" Psd:@"123456"] ;
}
- (IBAction)testLogin:(id)sender {
    [[QY_SocketService shareInstance] userLoginRequestWithName:@"793951780" Psd:@"123456"] ;
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

@end
