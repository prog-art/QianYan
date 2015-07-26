//
//  QY_QRCodeReaderDelegater.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QRCodeReaderDelegate.h"
#import "QY_QRCodeScanerDelegate.h"
#import <UIKit/UIKit.h>

@interface QY_QRCodeReaderDelegater : NSObject<QRCodeReaderDelegate>

@property (weak) id<QY_QRCodeScanerDelegate>delegate ;

- (instancetype)initWithDelegate:(id<QY_QRCodeScanerDelegate>)delegate ;

- (instancetype)initWithNavigationController:(UINavigationController *)nav Delegate:(id<QY_QRCodeScanerDelegate>)delegate ;

@end
