//
//  WifiListTableViewController.m
//  Wi-Fi列表
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "WifiListTableViewController.h"
#import "WifiListTableViewCell.h"
#import "AppDelegate.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "QY_Common.h"

#import "QRCodeDetailViewController.h"

@interface WifiListTableViewController () <UIAlertViewDelegate> {
    NSDictionary *_wifiInfo ;
}

@end

@implementation WifiListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self getWifiInfo] ;
}

- (void)getWifiInfo {
    _wifiInfo = [self fetchSSIDInfo] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    if ( !_wifiInfo ) {
        [QYUtils alert:@"wifi 未连接"] ;
    } else {
        QYDebugLog(@"wifi info = %@",_wifiInfo) ;
    }
}


/**
 *  @{
 *    BSSID : "a8:15:4d:51:7a:56",
 *    SSID : "HUMAO-WIFI",
 *    SSIDDATA : <48554d41 4f2d5749 4649>
 *    }
 *
 *  @return
 */
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _wifiInfo ? 1 : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WifiListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    cell.wifiTitle = _wifiInfo[WIFI_SSID_KEY] ;
    cell.subTitle = @"" ;
//    cell.subTitle = @"通过WPA2进行保护(受保护的网络可用)";
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入Wi-Fi密码"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil] ;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alert show] ;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0 : {
            break ;
        }
            
        case 1 : {
            NSString *password = [alertView textFieldAtIndex:0].text ;
            QYDebugLog(@"password = %@",password) ;
            
            if ( password.length != 0 ) {
                NSDictionary *info = @{WIFI_SSID_KEY:_wifiInfo[WIFI_SSID_KEY],
                                       WIFI_PSD_KEY:password} ;
                
                QRCodeDetailViewController *vc = [QRCodeDetailViewController viewControllerWith:info] ;
                
                [self.navigationController pushViewController:vc animated:YES] ;
            } else {
                [QYUtils alert:@"密码有误"] ;
            }

            break ;
        }
            
        default:
            break ;
    }
}

@end
