//
//  ViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ViewController.h"

#import "QY_Common.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "QY_QRCode.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *wifiIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifiPsdLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - IBAction

- (IBAction)getWifiQRImage:(id)sender {
    NSDictionary *info = [self fetchSSIDInfo] ;
    
    NSString *SSID = info[@"SSID"] ;
    self.wifiIdLabel.text = SSID ;
    
    UIImage *wifiInfoQRImg = [QY_QRCodeUtils QY_generateQRImageOfWifiWithESSID:SSID Password:self.wifiPsdLabel.text UserId:@"10000133"] ;
    self.imageView.image = wifiInfoQRImg ;
}

#pragma mark -

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

@end