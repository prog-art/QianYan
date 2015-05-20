//
//  QianYan_ChineseStringTests.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "QY_ChineseString.h"
#import "QY_Common.h"

@interface QianYan_ChineseStringTests : XCTestCase

@end

@implementation QianYan_ChineseStringTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testChineseStringDescription {
    ChineseString *cnStr = [[ChineseString alloc] initWithString:@"张睿33三"] ;
    QYDebugLog(@"%@",cnStr) ;
}

- (void)testQY_getChineseStringArrWithArray {
    QYDebugLog(@"%@",[QY_ChineseStringUtils QY_getChineseStringArrWithArray:@[@"张睿33",@"安妮2zr"]]) ;
}


@end