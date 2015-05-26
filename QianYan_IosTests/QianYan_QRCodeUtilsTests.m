//
//  QianYan_QRCodeUtilsTests.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "QY_QRCode.h"

@interface QianYan_QRCodeUtilsTests : XCTestCase

@end

@implementation QianYan_QRCodeUtilsTests

- (void)setUp {
    [super setUp];
}


- (void)tearDown {
    [super tearDown];
}

// 测试请加上这句在几个方法了里
// NSLog(@"qr Str = %@",qrStr) ;
- (void)testFormatString1 {
    [QY_QRCodeUtils QY_generateQRImageOfWifiWithESSID:@"NJQYWIFI" Password:@"123456" UserId:@"15018"] ;
}

- (void)testFormatString3 {
    [QY_QRCodeUtils QY_generateQRImageOfPersonalCardWithUserId:@"10000001"];
}

@end
