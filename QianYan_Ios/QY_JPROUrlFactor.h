//
//  QY_JPROUrlFactor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于组装JPRO服务器的URL字符串
 */
@interface QY_JPROUrlFactor : NSObject

#pragma mark - 上传

/**
 *  获取文件上传的BaseUrl
 *  http://host:port/files/upload/
 *
 *  @param host 主机ip或域名 @"qycam.com"
 *  @param port 主机端口 @"50060"
 *
 *  @return
 */
+ (NSString *)uploadURLWithHost:(NSString *)host
                           Port:(NSString *)port ;


+ (NSString *)uploadURLWithHost:(NSString *)host
                           Port:(NSString *)port
                           Path:(NSString *)path ;

#pragma mark - 下载

/**
 *  @return @"http://host:port/archives/
 */
+ (NSString *)downloadURLWithHost:(NSString *)host
                             Port:(NSString *)port ;

+ (NSString *)downloadURLWithHost:(NSString *)host
                             Port:(NSString *)port
                             Path:(NSString *)path ;

#pragma mark - 删除

+ (NSString *)deleteURLWithHost:(NSString *)host
                           Port:(NSString *)port ;

+ (NSString *)deleteURLWithHost:(NSString *)host
                           Port:(NSString *)port
                           Path:(NSString *)path ;


#pragma mark - 目录列表获取


+ (NSString *)getFileListURLWithHost:(NSString *)host
                                Port:(NSString *)port ;

+ (NSString *)getFileListURLWithHost:(NSString *)host
                                Port:(NSString *)port
                                Path:(NSString *)path ;

#pragma mark - 路径组装

/**
 *  311 @"user/userId/profile.xml"
 */
+ (NSString *)pathForUserProfile:(NSString *)userId ;

/**
 *  312 @"user/userId/friendlist"
 */
+ (NSString *)pathForUserFriendList:(NSString *)userId ;

/**
 *  312 @"user/userId/friendlist/friendId.xml"
 */
+ (NSString *)pathForUserFriendList:(NSString *)userId FriendId:(NSString *)friendId ;

/**
 *  313 @"user/userId/cameralist"
 */
+ (NSString *)pathForUserCameraList:(NSString *)userId ;

/**
 *  313 @"user/userId/cameralist/cameraId.xml"
 */
+ (NSString *)pathForUserCameraList:(NSString *)userId CameraId:(NSString *)cameraId ;

//公众号没做

/**
 *  314 @"user/userId/headpicture.jpg"
 */
+ (NSString *)pathForUserAvatar:(NSString *)userId ;

/**
 *  32 @"camera/userId"
 */
+ (NSString *)pathForCamera:(NSString *)cameraId ;

/**
 *  321 @"camera/cameraId/profile.xml"
 */
+ (NSString *)pathForCameraProfile:(NSString *)cameraId ;

/**
 *  322 @"camera/cameraId/sharelist"
 */
+ (NSString *)pathForCameraSharelist:(NSString *)cameraId ;

/**
 *  322 @"camera/cameraId/sharelist/userId.xml"
 */
+ (NSString *)pathForCameraSharelist:(NSString *)cameraId sharedUserId:(NSString *)userId ;

@end
