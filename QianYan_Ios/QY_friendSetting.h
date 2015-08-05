//
//  QY_friendSetting.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QY_Block_Define.h"

@class QY_user;

@interface QY_friendSetting : NSManagedObject

@property (nonatomic, retain) NSNumber * black;
@property (nonatomic, retain) NSNumber * fans;
@property (nonatomic, retain) NSNumber * follow;
@property (nonatomic, retain) NSString * remarkName;
@property (nonatomic, retain) NSNumber * shield;
@property (nonatomic, retain) QY_user *owner;
@property (nonatomic, retain) QY_user *toFriend;

#pragma mark - 本地数据库交互

+ (QY_friendSetting *)settingFromOwner:(QY_user *)owner toFriend:(QY_user *)toFriend ;

#pragma mark - 远端数据库交互 

- (void)saveComplection:(QYResultBlock)complection ;

- (void)fetchComplection:(QYObjectBlock)complection ;

#pragma mark -

/**
 *  生成保存在Jpro服务器上的xml字符串
 *
 *  @return
 */
- (NSString *)xmlStringForSaveAtJpro ;

- (NSData *)xmlStringDataForTransportByHttp ;

#pragma mark - getter

- (NSString *)displayName ;

@end
