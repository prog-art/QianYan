//
//  fileManagerTest.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "QY_FileService.h"

@interface fileManagerTest : XCTestCase

@end

@implementation fileManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//
//- (void)testWrite {
//    NSString *docPath = [QY_FileService getDocPath] ;
//    NSString *filePath = [docPath stringByAppendingPathComponent:@"testFile.txt"] ;
////    filePath = [filePath stringByAppendingPathExtension:@"txt"] ;
//    
//    NSString *testStr = @"我热哦" ;
//    
//    [testStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL] ;
//}
//
//- (void)testRead {
//    NSString *docPath = [QY_FileService getDocPath] ;
//    
//    NSString *filePath = [docPath stringByAppendingPathComponent:@"profile.xml"] ;
//    
//    NSString *testStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL] ;
//    
//    //file:///Users/humaoer/Library/Developer/CoreSimulator/Devices/E97E5760-6F7E-4E39-8B58-27A7DC668193/data/Containers/Data/Application/F5BE52BE-911B-4E5C-BE74-CABA8BE45F8C/Documents/profile.xml
//    ///Users/humaoer/Library/Developer/CoreSimulator/Devices/E97E5760-6F7E-4E39-8B58-27A7DC668193/data/Containers/Data/Application/7D69D41C-E184-4EC2-B065-A25B4E1DAD4E/Documents/profile.xml
//    
//    NSLog(@"fileExists ? = %d \n\n filePath = %@",[[QY_FileService fileManager] fileExistsAtPath:filePath],filePath) ;
//    
//    NSLog(@"\n\n\n testStr = %@\n\n\n",testStr) ;
//    
//}

- (void)testFileUrl {
    NSString *filePath = [QY_FileService getDocPath] ;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath] ;
    
    NSLog(@"fileUrl = %@",fileUrl) ;
    
    NSLog(@"url = %@",[NSURL URLWithString:filePath]) ;
    
    NSLog(@"fileUrl --> Str = %@",[fileUrl absoluteString]) ;
    
    NSLog(@"fileUrl --> Str = %@",[fileUrl relativeString]) ;
    
    NSLog(@"fileUrl --> Str = %@",[fileUrl path]) ;
    
}
//
//- (void)testWrite2 {
////    //这里不会简历子路径
////    NSString *docPath = [QY_FileService getDocPath] ;
////    NSString *filePath = [docPath stringByAppendingPathComponent:@"testFolder"] ;
////    filePath = [filePath stringByAppendingPathComponent:@"testFile.txt"] ;
////    
////    NSString *testStr = @"我热哦" ;
////    
////    NSError *error ;
////    [testStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error] ;
////    
////    NSLog(@"\n\n\n\nerror = %@",error) ;
//}

//- (void)testFolder {
//    //会给多级文件路径创建对应的文件夹
//    NSString *docPath = [QY_FileService getDocPath] ;
//    
//    NSString *fileDir = [docPath stringByAppendingPathComponent:@"testFolder1"] ;
//    fileDir = [fileDir stringByAppendingPathComponent:@"testFolder2"] ;
//    NSString *filepath = [fileDir stringByAppendingPathComponent:@"a.txt"] ;
//    
//    NSFileManager *manager = [NSFileManager defaultManager] ;
//    
//    if ( [manager fileExistsAtPath:filepath] ) {
//        NSLog(@"\n\n\\n已经存在\n\n\\n") ;
//    } else {
//        BOOL isDir = YES ;
//        BOOL result = [manager fileExistsAtPath:fileDir isDirectory:&isDir] ;
//        
//        if ( !result ) {
//            NSLog(@"文件夹不存在") ;
//            
//            [manager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:NULL] ;
//        }
//        
//        NSString *a = @"我热啊" ;
//        [a writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL] ;
//    }
//    
//}

//- (void)testFolderAndFileName {
//    //会给多级文件路径创建对应的文件夹
//    NSString *docPath = [QY_FileService getDocPath] ;
//    
//    NSString *fileDir = [docPath stringByAppendingPathComponent:@"testFolder1"] ;
//    fileDir = [fileDir stringByAppendingPathComponent:@"testFolder2"] ;
//    
//    
//    NSFileManager *manager = [NSFileManager defaultManager] ;    
//    
//    NSLog(@"path 可写吗？ %d",[manager isWritableFileAtPath:fileDir]) ;
//    
//    BOOL isDir = YES ;
//    if ( ![manager fileExistsAtPath:fileDir isDirectory:&isDir]) {
//        [manager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:NULL] ;
//    }
//    
//    
//    NSString *filepath = [fileDir stringByAppendingPathComponent:@"a.txt"] ;
//    
//    NSError *error ;
//    
//    if ( [manager fileExistsAtPath:filepath]) {
//        [manager removeItemAtPath:filepath error:&error] ;
//    }
//    
//    NSString *a = @"wocao" ;
//    
//    [a writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL] ;
//}

@end