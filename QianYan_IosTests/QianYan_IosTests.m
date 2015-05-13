//
//  QianYan_IosTests.m
//  QianYan_IosTests
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "QY_dataPacketFactor.h"
#import "QY_JRMDataPharser.h"
#import "NSString+QY_dataFormat.h"
#import "NSData+QY_dataFormat.h"

@interface QianYan_IosTests : XCTestCase

@end

#warning 快速跳转warning
@implementation QianYan_IosTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//- (void)testDeviceLoginData {
//    //ok
//    NSLog(@"device login data = %@",[QY_dataPacketFactor getDeviceLoginData]) ;
//}

- (void)testRegisteData {
    NSLog(@"registe data = %@",[QY_dataPacketFactor getUserRegisteDataWithUserName:@"123456" password:@"123456"]) ;
}

- (void)testLoginData {
    NSLog(@"login data = %@",[QY_dataPacketFactor getUserLoginDataWithUserName:@"123456" password:@"123456"]) ;
}

- (void)testPhraseData {
    NSData *testData = [QY_dataPacketFactor getDeviceLoginData] ;
    NSLog(@"test data = %@",testData) ;
    
    NSUInteger len = [QY_JRMDataPharser getLen:testData] ;
    NSLog(@"len = %lu",(unsigned long)len) ;
    JOSEPH_COMMAND cmd = [QY_JRMDataPharser getCmd:testData] ;
    NSLog(@"cmd = %d",cmd) ;
    
    NSRange range = NSMakeRange( JRM_DATA_LENGTH_Len + JRM_DATA_CMD_Len, 4) ;
    NSInteger value = [QY_JRMDataPharser getIngeterValue:testData range:range] ;
    NSLog(@"value = %ld",(long)value) ;
}

@end
