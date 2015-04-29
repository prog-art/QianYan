//
//  ViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ViewController.h"

#import "QY_SocketService.h"

#import <QRCodeReaderViewController/QRCodeReaderViewController.h>

@interface ViewController () <QRCodeReaderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)testSocket:(id)sender {
        NSError *error ;
        [[QY_SocketService shareInstance] connectToHost:&error] ;
        [[QY_SocketService shareInstance] sendMessage] ;
}


- (IBAction)testQRCodeReader:(id)sender {
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
    }];
    
    [self.navigationController pushViewController:reader animated:YES];
}

#pragma mark
/**
 * @abstract Tells the delegate that the reader did scan a QRCode.
 * @param reader The reader view controller that scanned a QRCode.
 * @param result The content of the QRCode as a string.
 * @since 1.0.0
 */
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    QYDebugLog() ;
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

/**
 * @abstract Tells the delegate that the user wants to stop scanning QRCodes.
 * @param reader The reader view controller that the user wants to stop.
 * @since 1.0.0
 */
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    QYDebugLog() ;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
