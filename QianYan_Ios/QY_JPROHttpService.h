//
//  QY_tempHttpService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "QY_Block_Define.h"

#import "QY_JPRO.h"

#import "QY_jpro_http_protocol.h"

@interface QY_JPROHttpService : NSObject<QY_jpro_http_protocol>

+ (instancetype)shareInstance ;

/**
 *  退出登录清理cookie
 */
+ (void)logoff ;

@property (nonatomic,readonly) NSString *jpro_ip ;
@property (nonatomic,readonly) NSString *jpro_port ;

- (void)configIp:(NSString *)jpro_ip Port:(NSString *)jpro_port ;



/**
 *  上传用户头像
 *
 *  @param userId      用户Id[必填]
 *  @param avatar      头像图片[必填,方法内自压缩]
 *  @param complection
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar Complection:(QYResultBlock)complection ;

/**
 *  负责删除远端friendlist中，双方的部分。本地数据由调用者在回调中负责删除。
 *
 *  @param friendId    朋友的Id
 *  @param selfId      自己的Id
 *  @param complection
 */
- (void)deleteFriendWithFriendId:(NSString *)friendId selfId:(NSString *)selfId complection:(QYResultBlock)complection ; 

#pragma mark - test

- (void)testUpload ;

- (void)testDownload ;

- (void)testDownload2 ;

@end
