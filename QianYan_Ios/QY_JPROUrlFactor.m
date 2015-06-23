//
//  QY_JPROUrlFactor.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JPROUrlFactor.h"

@implementation QY_JPROUrlFactor

#pragma mark - 上传

#define UPLOAD_BASEURL(host,port,userId) [NSString stringWithFormat:@"http://%@:%@/files/upload/?path=user/%@/profile.xml",host,port,userId]

+ (NSString *)uploadURLWithHost:(NSString *)host
                           Port:(NSString *)port {
    return [NSString stringWithFormat:@"http://%@:%@/files/upload",host,port] ;
}

+ (NSString *)uploadURLWithHost:(NSString *)host
                           Port:(NSString *)port
                           Path:(NSString *)path {
    NSString *ppath = [NSString stringWithFormat:@"?path=%@",path] ;
    return [[self uploadURLWithHost:host Port:port] stringByAppendingPathComponent:ppath] ;
}

#pragma mark - 下载 

//#define DOWNLOAD_BASEURL(host,port,userId) [NSString stringWithFormat:@"http://%@:%@/archives/user/%@/profile.xml",host,port,userId]

+ (NSString *)downloadURLWithHost:(NSString *)host
                             Port:(NSString *)port {
    return [NSString stringWithFormat:@"http://%@:%@/archives",host,port] ;
}

+ (NSString *)downloadURLWithHost:(NSString *)host
                             Port:(NSString *)port
                             Path:(NSString *)path {
    return [[self downloadURLWithHost:host Port:port] stringByAppendingPathComponent:path] ;
}

#pragma mark - 删除

+ (NSString *)deleteURLWithHost:(NSString *)host
                           Port:(NSString *)port {
    return [NSString stringWithFormat:@"http://%@:%@/files/clear",host,port] ;
}

+ (NSString *)deleteURLWithHost:(NSString *)host
                           Port:(NSString *)port
                           Path:(NSString *)path {
    NSString *ppath = [NSString stringWithFormat:@"?path=%@",path] ;
    return [[self deleteURLWithHost:host Port:port] stringByAppendingPathComponent:ppath] ;
}

#pragma mark - 目录列表获取

+ (NSString *)getFileListURLWithHost:(NSString *)host
                                Port:(NSString *)port {
    return [NSString stringWithFormat:@"http://%@:%@/files/list",host,port] ;
}

+ (NSString *)getFileListURLWithHost:(NSString *)host
                                Port:(NSString *)port
                                Path:(NSString *)path {
    NSString *ppath = [NSString stringWithFormat:@"?path=%@",path] ;
    return [[self getFileListURLWithHost:host Port:port] stringByAppendingPathComponent:ppath] ;
}

#pragma mark - 路径组装

#define PATH_USER @"user"
#define PROFILE_XML @"profile.xml"

+ (NSString *)pathForUserProfile:(NSString *)userId {
    NSString *path = PATH_USER ;
    path = [path stringByAppendingPathComponent:userId] ;
    path = [path stringByAppendingPathComponent:PROFILE_XML] ;
    return path ;
}

+ (NSString *)pathForUserFriendList:(NSString *)userId {
    NSString *path = PATH_USER ;
    path = [path stringByAppendingPathComponent:userId] ;
    path = [path stringByAppendingPathComponent:@"friendlist"] ;
    return path ;
}

+ (NSString *)pathForUserFriendList:(NSString *)userId FriendId:(NSString *)friendId {
    NSString *path = [self pathForUserFriendList:userId] ;
    path = [[path stringByAppendingPathComponent:friendId] stringByAppendingPathExtension:@"xml"];
    return path ;
}

+ (NSString *)pathForUserCameraList:(NSString *)userId {
    NSString *path = PATH_USER ;
    path = [path stringByAppendingPathComponent:userId] ;
    path = [path stringByAppendingPathComponent:@"cameralist"] ;
    return path ;
}

+ (NSString *)pathForUserCameraList:(NSString *)userId CameraId:(NSString *)cameraId {
    NSString *path = [self pathForUserCameraList:userId] ;
    path = [[path stringByAppendingPathComponent:cameraId] stringByAppendingPathExtension:@"xml"] ;
    return path ;
}

#define PATH_CAMERA @"camera"

/**
 *  32 @"camera/userId"
 */
+ (NSString *)pathForCamera:(NSString *)cameraId {
    NSString *path = PATH_CAMERA ;
    path = [path stringByAppendingPathComponent:cameraId] ;
    return path ;
}

/**
 *  321 @"camera/cameraId/profile.xml"
 */
+ (NSString *)pathForCameraProfile:(NSString *)cameraId {
    NSString *path = [self pathForCamera:cameraId] ;
    path = [path stringByAppendingPathComponent:PROFILE_XML] ;
    return path ;
}

/**
 *  322 @"camera/cameraId/sharelist"
 */
+ (NSString *)pathForCameraSharelist:(NSString *)cameraId {
    NSString *path = [self pathForCamera:cameraId] ;
    path = [path stringByAppendingPathComponent:@"sharelist"] ;
    return path ;
}

/**
 *  322 @"camera/cameraId/sharelist/userId.xml"
 */
+ (NSString *)pathForCameraSharelist:(NSString *)cameraId sharedUserId:(NSString *)userId {
    NSString *path = [self pathForUserCameraList:cameraId] ;
    path = [[path stringByAppendingPathComponent:userId] stringByAppendingPathExtension:@"xml"] ;
    return path ;
}

@end