//
//  QYSocialDataModelInterface.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QYSocialDataModelInterface_h
#define QianYan_Ios_QYSocialDataModelInterface_h

#import <Foundation/Foundation.h>

@class UIImageView ;
@class UIImage ;

@protocol AUser ;

#pragma mark - Abstract Status

@protocol AStatus <NSObject>

/**
 *  发布时间
 */
- (NSDate *)aPubDate ;

/**
 *  谁操作的
 */
- (id<AUser>)aOwner ;

/**
 *  唯一表识
 */
- (NSString *)aUUId ;

@end

#pragma mark - Feed[说说]

@protocol AFeed <AStatus>

/**
 *  说说内容
 */
- (NSString *)aContent ;

/**
 *  说说附件，图片或视频。id<Attach>
 */
- (NSArray *)aAttaches ;

/**
 *  类型[1-3],1视频,2图片,3文字
 */
- (NSInteger)aType ;

/**
 *  是否被当前用户点赞了
 */
- (BOOL)aDiggedByCurrentUser ;

/**
 *  被点赞次数
 */
- (NSInteger)aDiggCount ;

/**
 *  评论id<AComment>
 */
- (NSArray *)aComments ;

@end

#pragma mark - Comment[评论]

@protocol AComment <AStatus>

/**
 *  评论内容
 */
- (NSString *)aContent ;

@optional

/**
 *  回复给某人[预留，现无回复接口]
 */
- (id<AUser>)reply2User ;

@end


#pragma mark - User[用户]

@protocol AUser <NSObject>

/**
 *  用户名
 */
- (NSString *)aName ;

/**
 *  用户Id
 */
- (NSString *)aUserId ;

- (void)aDisplayUserAvatarAtImageView:(UIImageView *)avatarImgView ;

@optional

//扩展，之后想加的在这里可以加。这里现在没用到的。

/**
 *  直接返回头像
 */
- (UIImage *)aAvatar ;

/**
 *  返回头像的URL
 */
- (NSURL *)aAvatarUrl ;

@end



#pragma mark - Attach[附件]

@protocol AAttach <NSObject>

/**
 *  日期[排序key]
 */
- (NSDate *)aPubDate ;

/**
 *  唯一标识
 */
- (NSString *)aUUID ;

/**
 *  类型
 */
- (NSString *)aType ;

/**
 *  地址
 */
- (NSURL *)aSource ;

@end

#endif
