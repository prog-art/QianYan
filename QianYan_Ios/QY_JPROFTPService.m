//
//  QY_JPROFTPService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JPROFTPService.h"

#import "QY_Common.h"
#import "QY_FileService.h"

#import <AFNetworking/AFNetworking.h>

@interface QY_JPROFTPService ()

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
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration] ;

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config] ;
    
    NSString *path = @"ftp://admin:123456@jdas.qycam.com:50280/av_server.752.wifi" ;
    path = @"ftp://download:123456@jdas.qycam.com:50280/10000129/t00000000000207/motion/20150804/154226_20150804154221_2_5.avi" ;
    
    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:path]] ;
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSLog(@"targetPath = %@",targetPath) ;
        NSURL *dirUrl = [QY_FileService getAlertMessageVideoDirUrl] ;
        dirUrl = [dirUrl URLByAppendingPathComponent:[path lastPathComponent]] ;
        return dirUrl ;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        QYDebugLog(@"\n\nresponse = %@\n",response) ;
        QYDebugLog(@"\n\nfilePath = %@\n",[filePath path]) ;
        QYDebugLog(@"\n\nerror = %@\n",error) ;
    }] ;
    
    [task resume] ;
    
}

@end