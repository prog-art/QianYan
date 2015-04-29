//
//  QianYan_IosTests.m
//  QianYan_IosTests
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <CocoaAsyncSocket/AsyncSocket.h>

#import "QYUtils.h"
#import "QY_SocketService.h"

@interface QianYan_IosTests : XCTestCase

@end

@implementation QianYan_IosTests

- (void)setUp {
    [super setUp];
    
    //    Byte test[] = {0x00 , 0x08 , 0x00 , 0x00 ,0x00 ,0x28 , 0x00 ,0x00,0x00 ,0x1e } ;
    
    //    NSLog(@"test byte = !@#!#!@#  ======== %x",test[1]) ;
    NSError *error ;
    [[QY_SocketService shareInstance] connectToHost:&error] ;
    
}

- (void)tearDown {
    [super tearDown];
}

- (void)testQY_SocketService_sendMessage {
    XCTestExpectation *exception = [self expectationWithDescription:@"High Exceptions"] ;
    [[QY_SocketService shareInstance] sendMessage] ;
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        NSLog(@"test") ;
    }] ;
}

// ok
//- (void)testQY_SocketService_connectToHost {
//    NSError *error ;
//    BOOL Successed = [[QY_SocketService shareInstance] connectToHost:&error] ;
//
//    if (Successed) {
//        NSLog(@"成功") ;
//    } else {
//        NSLog(@"失败 %@",error) ;
//    }
//
//    XCTAssert(Successed) ;
//}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
