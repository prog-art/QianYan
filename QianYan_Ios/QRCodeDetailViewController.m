//
//  ViewController.m
//  二维码详情
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "QRCodeDetailViewController.h"

#import "AppDelegate.h"
#import "QY_Common.h"

@interface QRCodeDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *SSIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *PASSWORDLabel;

@property (nonatomic) NSString *SSID ;
@property (nonatomic) NSString *password ;

@end

@implementation QRCodeDetailViewController

+ (QRCodeDetailViewController *)viewControllerWith:(NSDictionary *)wifiInfo {
    QRCodeDetailViewController *vc = (id)[[AppDelegate globalDelegate] QRCodeDetailViewController] ;
    
    vc.SSID = wifiInfo[WIFI_SSID_KEY] ;
    vc.password = wifiInfo[WIFI_PSD_KEY] ;
    return vc ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.SSIDLabel.text = @"" ;
    self.PASSWORDLabel.text = @"" ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    if ( self.SSID && self.password && [QYUser currentUser].userId ) {
        UIImage *wifiInfoQRImg = [QY_QRCodeUtils QY_generateQRImageOfWifiWithESSID:self.SSID Password:self.password UserId:[QYUser currentUser].userId] ;
        [self.QRCodeImageView setImage:wifiInfoQRImg] ;
        self.SSIDLabel.text = self.SSID ;
        self.PASSWORDLabel.text = self.password ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (IBAction)backToListBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}
@end
