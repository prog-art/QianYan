//
//  QY_jpro_http_protocol.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Block_Define.h"
#import "QYConstants.h"

#import <AFNetworking/AFNetworking.h>
/**
 *  AFNetwork成功回调
 *
 *  @param operation      AFHTTPRequestOperation
 *  @param responseObject NSError
 */
typedef void(^QY_AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) ;
/**
 *  AFNetwork失败回调
 *
 *  @param operation AFHTTPRequestOperation
 *  @param error     NSError
 */
typedef void(^QY_AFFailBlock)(AFHTTPRequestOperation *operation, NSError *error) ;

/**
 *  AFNetwork下载回调
 *
 *  @param filePath 下载的文件路径
 *  @param error    NSError
 */
typedef void(^QY_DownloadComplectionBlock)(NSURL *filePath,NSError *error) ;

@protocol QY_jpro_http_protocol <NSObject>

/**
 *  登录JPRO服务器
 *
 *  @param userId      @"10000133"
 *  @param password    @"123456"
 *  @param complection
 */
- (void)jproLoginWithUserId:(NSString *)userId
                   Password:(NSString *)password
                Complection:(QYResultBlock)complection ;

/**
 *  注销用户登录
 *
 *  @param complection
 */
- (void)jproLogoutComplection:(QYResultBlock)complection ;

/**
 *  1.获取警报message列表
 *
 *  @param page        页数
 *  @param num         指定每页的msg数
 *  @param type        过滤指定的消息类型 这里写140
 *  @param userId      过滤指定用户ID
 *  @param cameraId    过滤指定相机ID
 *  @param startId     以小于start制定的ID倒序开始
 *  @param endId       以大于end制定的ID结尾
 *  @param check       检测已缓存msg是否删除、检测是否有未缓存msg存在，@[@{@"id":@1},@{@"id":@2}]
 *  @param complection
 */
- (void)getAlertMessageListPage:(NSUInteger)page
                     NumPerPage:(NSUInteger)num
                           Type:(NSUInteger)type
                         UserId:(NSString *)userId
                       cameraId:(NSString *)cameraId
                        StartId:(NSString *)startId
                          EndId:(NSString *)endId
                          Check:(NSSet *)check
                    Complection:(QYArrayBlock)complection ;

/**
 *  2.删除msg列表
 *
 *  @param messageIds  要删除的msg列表
 *  @param complection
 */
- (void)deleteAlertMessages:(NSSet *)messageIds
                Complection:(QYArrayBlock)complection ;

/**
 *  3.通过msgId获取某个Alert Message
 *
 *  @param msgId
 *  @param complection
 */
- (void)getMsgById:(NSString *)msgId
       Complection:(QYObjectBlock)complection ;

/**
 *  4.通过msgId删除某个Alert Message
 *
 *  @param msgId
 */
- (void)deleteMsgById:(NSString *)msgId
          Complection:(QYResultBlock)complection ;

/**
 *  5.获取某相机的报警消息用户分享列表
 *
 *  @param cameraId
 *  @param complection
 */
- (void)getCameraShareList:(NSString *)cameraId
               Complection:(QYArrayBlock)complection ;
/**
 *  6.增加某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userIds     用户ID
 *  @param complection
 */
- (void)shareCamera:(NSString *)cameraId
            toUsers:(NSSet *)userIds
        Complection:(QYArrayBlock)complection ;

/**
 *  7.(相机拥有者角度)删除某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userIds     用户IDs
 *  @param complection
 */
- (void)cancelShareCamer:(NSString *)cameraId
                 toUsers:(NSSet *)userIds
             Complection:(QYArrayBlock)complection ;

/**
 *  7.(被分享者角度)删除某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userId     用户IDs
 *  @param complection
 */
- (void)cancelShareCamer:(NSString *)cameraId
                  toUser:(NSString *)userId
             Complection:(QYResultBlock)complection ;
/**
 *  8.上传图片
 *
 *  @param attachmentData 附件Data
 *  @param complection
 */
- (void)uploadImageAttach:(NSData *)attachmentData
              Complection:(QYObjectBlock)complection ;
/**
 *  9.添加在别处上传的图片或视频attach
 *
 *  @param src         图片或视频链接
 *  @param type        @"image" or @"video"
 *  @param medium      @"中等缩略图" [可选]
 *  @param small       @"最小缩略图” [可选]
 *  @param complection
 */
- (void)addConnectToAttachSourceFromSrc:(NSString *)src
                                   Type:(NSString *)type
                                 Medium:(NSString *)medium
                                  Small:(NSString *)small
                            Complection:(QYObjectBlock)complection ;
/**
 *  10.发表状态feed
 *
 *  @param content     内容
 *  @param attachesIds 附件IDs
 *  @param messageIds  消息IDs
 *  @param complection
 */
- (void)createAttachFeedWithContent:(NSString *)content
                           Attaches:(NSSet *)attachesIds
                           Messages:(NSSet *)messageIds
                        Complection:(QYObjectBlock)complection ;
/**
 *  11.获取状态feed列表
 *
 *  @param page        翻页，默认每页显示10条feed
 *  @param num         指定每页显示的feed数
 *  @param userId      过滤指定用户ID
 *  @param startId     以小于start指定的ID倒序开始
 *  @param endId       以大于end指定的ID结尾
 *  @param check       获取feed的简略信息，如@[@{@"id":@2,@"mod_date":@1407913369},@{@"id":@3,@"mod_date":@1407913322}]
 *  @param complection
 */
- (void)getFeedListWithPage:(NSUInteger)page
                 NumPerPage:(NSUInteger)num
                     UserId:(NSString *)userId
                    StartId:(NSString *)startId
                      EndId:(NSString *)endId
                      Check:(NSSet *)check
                Complection:(QYArrayBlock)complection ;

/**
 *  12.获取某个状态feed
 *
 *  @param feedId      feedId
 *  @param complection
 */
- (void)getFeedById:(NSString *)feedId
        Complection:(QYObjectBlock)complection ;
/**
 *  13.删除状态feed
 *
 *  @param feedId      feedId
 *  @param complection
 */
- (void)deleteFeedById:(NSString *)feedId
           Complection:(QYResultBlock)complection ;


/**
 *  14.发表评论comment
 *
 *  @param feedId      feedId
 *  @param comment     评论内容
 *  @param complection
 */
- (void)addCommentToFeed:(NSString *)feedId
                 Comment:(NSString *)comment
             Complection:(QYObjectBlock)complection ;

/**
 *  15.删除评论
 *
 *  @param commentId   评论ID
 *  @param complection
 */
- (void)deleteCommentById:(NSString *)commentId
              Complection:(QYResultBlock)complection ;

/**
 *  16.点赞digg
 *
 *  @param feedId      feedID
 *  @param complection
 */
- (void)diggForFeed:(NSString *)feedId
        Complection:(QYResultBlock)complection ;
/**
 *  17.取消点赞digg
 *
 *  @param feedId      feedID
 *  @param complection
 */
- (void)cancelDiggForFeed:(NSString *)feedId
              Complection:(QYResultBlock)complection ;
/**
 *  18.上传档案文件
 *
 *  @param path     user/10000001/friendlist/100000022.xml
 *  @param fileUrl  FILE URL
 *  @param filename @"file"
 *  @param fileType @"multipart/form-data"
 *  @param success
 *  @param fail
 */
- (void)uploadFileToPath:(NSString *)path
                 FileURL:(NSURL *)fileUrl
                fileName:(NSString *)filename
                fileType:(NSString *)fileType
                 Success:(QY_AFSuccessBlock)success
                    Fail:(QY_AFFailBlock)fail QYDeprecated("尽量不用，用18[2]");

/**
 *  18[2].上传档案文件
 *
 *  @param path        [必填]上传在jpro服务器上的路径,(@"?path=%@",path)
 *  @param data        [必填]要上传的文件的data
 *  @param name        [必填]上传在服务器上保存的名字
 *  @param mimeType    [必填]Content-Type
 *  @param complection
 */
- (void)uploadFileToPath:(NSString *)path
                FileData:(NSData *)data
                fileName:(NSString *)name
                mimeType:(NSString *)mimeType
             Complection:(QYResultBlock)complection ;

/**
 *  19.从服务器下载文件
 *
 *  @param Path        服务器Path @"user/10000010/profile.xml"
 *  @param fileUrl     FILE URL
 *  @param complection 回调
 */
- (void)downloadFileFromPath:(NSString *)path
               saveToFIleURL:(NSURL *)fileUrl
                 complection:(QY_DownloadComplectionBlock)complection ;

/**
 *  19[2].从服务器读取文件内容到Memory
 *
 *  @param path        [必填]服务器Path @"user/10000133/profile.xml"
 *  @param complection 回调
 */
- (void)downloadFileFromPath:(NSString *)path
                 complection:(QYObjectBlock)complection ;

/**
 *  19[3].从服务器读取图片Data到Memory
 *
 *  @param path        [必填]服务器Path @"user/10000133/profile.xml"
 *  @param complection
 */
- (void)downloadImageFromPath:(NSString *)path
                  complection:(QYObjectBlock)complection ;

/**
 *  20.获取档案目录文件列表
 *
 *  @param path        服务器路径
 *  @param complection
 */
- (void)getDocumentListForPath:(NSString *)path
                   Complection:(QYArrayBlock)complection ;

/**
 *  21.删除档案目录或文件
 *
 *  @param path        服务器路径
 *  @param complection
 */
- (void)clearDocumentOnPath:(NSString *)path
                Complection:(QYResultBlock)complection ;

@end
