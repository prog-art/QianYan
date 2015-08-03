//
//  ViewController.h
//  二维码详情
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIFI_SSID_KEY @"SSID"
#define WIFI_PSD_KEY @"PASSWORD"

@interface QRCodeDetailViewController : UIViewController

+ (QRCodeDetailViewController *)viewControllerWith:(NSDictionary *)wifiInfo ;

@end

