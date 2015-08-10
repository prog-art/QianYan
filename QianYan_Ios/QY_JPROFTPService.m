//
//  QY_JPROFTPService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JPROFTPService.h"

#import "FTPManager.h"
#import "QY_Common.h"
#import "QY_FileService.h"

@interface QY_JPROFTPService () <FTPManagerDelegate>

@end

@implementation QY_JPROFTPService


+ (instancetype)shareInstance {
    static QY_JPROFTPService *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_JPROFTPService alloc] init] ;
    }) ;
    return sharedInstance ;
}

#pragma mark - 


- (void)testDownload:(NSString *)url {
    QYDebugLog(@"url = %@",url) ;
    NSString *path ;
    
//                                 jdas.qycam.com:50280/10000133/t00000000000193/motion/20150718/134234_20150718134229_2_5.avi
//                                 jdas.qycam.com:50280/10000133/t00000000000193/motion/20150718/133858_20150718133853_2_5.avi
    path = @"ftp://download:123456@jdas.qycam.com:50280/10000133/t00000000000193/motion/20150718/133858_20150718133853_2_5.avi" ;
    FTPManager *manager = [[FTPManager alloc] init] ;
    
    manager.delegate = self ;
    
    FMServer *server = [FMServer serverWithDestination:@"jdas.qycam.com:50280/10000133/t00000000000193/motion/20150718" username:@"download" password:@"123456"] ;
    server.port = 50280 ;
    
    NSURL *dirUrl = [QY_FileService getAlertMessageVideoDirUrl] ;
    
    BOOL result = [manager downloadFile:[path lastPathComponent] toDirectory:dirUrl fromServer:server] ;
    QYDebugLog(@"%@",result?@"成功":@"失败") ;
}

#pragma mark - FTPManagerDelegate

// Returns information about the current download.
// See "Process Info Dictionary Constants" below for detailed info.
- (void)ftpManagerDownloadProgressDidChange:(NSDictionary *)processInfo {
    QYDebugLog(@"%@",processInfo) ;
}


@end
