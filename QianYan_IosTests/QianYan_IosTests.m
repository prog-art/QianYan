//
//  QianYan_IosTests.m
//  QianYan_IosTests
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

//#import "QY_dataPacketFactor.h"
//#import "QY_JRMDataPharser.h"
//#import "NSString+QY_dataFormat.h"
//#import "NSData+QY_dataFormat.h"
//#import "QY_FileService.h"
#import "QY_XMLService.h"
#import "QYUser.h"

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

- (void)testQYUser {
    QYUser *user = [QYUser instanceWithUserId:@"testUserId"
                                     username:@"zr233"
                                     nickname:@"小瑞瑞"
                                   remarkname:@"fuck you"
                                       follow:3
                                         fans:100
                                        black:50
                                       shield:3
                                         jpro:@"http://qycam.com:50551"] ;
    
    NSString *xmlStr = [user getUserIdXMLString] ;
    
    QYUser *user2 = (QYUser *)[QY_XMLService getUserFromUserIdXML:xmlStr] ;
    
    NSLog(@"%@",user2) ;
}

- (void)testQYUser2 {
    QYUser *user = [QYUser instanceWithUserId:@"123456"
                                     username:@"123456"
                                       gender:@"123456"
                                     location:@"123456"
                                     birthday:[NSDate date]
                                    signature:@"123456"] ;
    
    
    NSString *xmlStr = [user getProfileXMLString] ;

    QYUser *user2 = (QYUser *)[QY_XMLService getUserFromProfileXML:xmlStr] ;
    
    NSLog(@"%@",user2) ;
    
}

//- (void)testFilePathAndFileExtension {
//    NSString *urlStr = @"http://qycam.com:50551/files/upload/?path=user/10000001/profile.xml" ;
//    
//    NSString *fileName = [urlStr lastPathComponent] ;
//    NSString *fileExtension = [fileName pathExtension] ;
//    NSString *baseUrl = [urlStr stringByDeletingLastPathComponent] ;
//    NSLog(@"\n "
//          "fileName = %@\n"
//          "fileExtension = %@\n"
//          "baseUrl = %@\n",fileName,fileExtension,baseUrl) ;
//    
//}
//
//- (void)testFilePath {
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
//    
//    NSString *path = [docPath stringByAppendingString:@"profile.xml"] ;
//    
//}
//
//- (void)testFileService {
//    NSLog(@"\n doc path = %@ \n",[QY_FileService getDocPath]) ;
//    
//    NSLog(@"\n userId path = %@ \n",[QY_FileService getUserPathByUserId:@"testUserId"]) ;
//}

//- (void)testInt2NSData {
//#warning 为什么啊
////    int i = 18 ;
////    NSData *data = [NSData dataWithBytes:&i length:2] ;
////    
////    NSLog(@"zrzrzrzr = %@ %lu",data,sizeof(i)) ;
////    
//    [self ttt:18] ;
//    [self ttt:171] ;
//    [self ttt:1601] ;
//    [self ttt:16] ;
//    [self ttt:256] ;
//    [self ttt:4096] ;
//    [self ttt:65536] ;
//}
//
//- (void)ttt:(int)i {
//    NSData *data = [NSData dataWithBytes:&i length:4] ;
//    NSLog(@"zrzrzrzr = %@ i = %d",data,i) ;
//}
//
//- (void)testNSdata2Int {
//    int testByte = 20 ;
//    NSData *data = [NSData dataWithBytes:&testByte length:sizeof(testByte)] ;
//    
//    int j ;
//    [data getBytes:&j length:sizeof(j)] ;
//    NSLog(@"zrzrzrzr = %d ",j) ;
//}

//- (void)testDeviceLoginData {
//    //ok
//    NSLog(@"device login data = %@",[QY_dataPacketFactor getDeviceLoginData]) ;
//}

//- (void)testFormatString {
//    NSString *ESSID = @"" ;
//    NSString *str = [NSString stringWithFormat:@"%02tu", ESSID.length];
//    NSLog(@"str = %@",str) ;
//    
//    ESSID = @"tes" ;
//    NSString *str2 = [NSString stringWithFormat:@"%02tu", ESSID.length];
//    NSLog(@"str2 = %@",str2) ;
//    
//}

//- (void)testRegisteData {
//    NSLog(@"registe data = %@",[QY_dataPacketFactor getUserRegisteDataWithUserName:@"123456" password:@"123456"]) ;
//}
//
//- (void)testLoginData {
//    NSLog(@"login data = %@",[QY_dataPacketFactor getUserLoginDataWithUserName:@"123456" password:@"123456"]) ;
//}
//
//- (void)testPhraseData {
//    NSData *testData = [QY_dataPacketFactor getDeviceLoginData] ;
//    NSLog(@"test data = %@",testData) ;
//    
//    NSUInteger len = [QY_JRMDataPharser getLen:testData] ;
//    NSLog(@"len = %lu",(unsigned long)len) ;
//    JOSEPH_COMMAND cmd = [QY_JRMDataPharser getCmd:testData] ;
//    NSLog(@"cmd = %d",cmd) ;
//    
//    NSRange range = NSMakeRange( JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD, 4) ;
//    NSInteger value = [QY_JRMDataPharser getIngeterValue:testData range:range] ;
//    NSLog(@"value = %ld",(long)value) ;
//}

//- (void)testPhraseStringData {
//    Byte bytes[] = {0x31,0x30,0x30,0x30,0x30,0x31,0x33,0x33,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00} ;
//    
//    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)] ;
//    
//    NSLog(@"dataStr = %@",[NSData QY_NSData2NSString:data]);
//    
//    NSLog(@"data = %@",data) ;
//}

@end
