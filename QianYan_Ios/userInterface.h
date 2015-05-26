//
//  userInterface.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_userInterface_h
#define QianYan_Ios_userInterface_h


@protocol user2ProfileXMLInterface <NSObject>

@required

/**
 *  用户Id @"10000001"
 */
@property (nonatomic) NSString *userId ;

/**
 *  用户名 @"qianyan"
 */
@property (nonatomic) NSString *username ;

/**
 *  用户性别 @"男"
 */
@property (nonatomic) NSString *gender ;

/**
 *  用户位置 @"江苏南京"
 */
@property (nonatomic) NSString *location ;

/**
 *  用户生日 @"2008年06月21日"
 */
@property (nonatomic) NSDate *birthday ;

/**
 *  用户签名 @"千衍通信欢迎您!"
 */
@property (nonatomic) NSString *signature ;



@optional

/**
 *  获取profile.xml的文本
 *
 *  @return profile.xml的文本
 */
- (NSString *)getProfileXMLString ;

/**
 *  profile.xml 2 instance
 *
 *  @param xmlStr xml文档
 *
 *  @return id<user2ProfileXMLInterface>
 */
+ (id<user2ProfileXMLInterface>)profileXML2Instance:(NSString *)xmlStr ;

/**
 *  构造方法
 */
+ (id<user2ProfileXMLInterface>)instanceWithUserId:(NSString *)userId
                                          username:(NSString *)username
                                            gender:(NSString *)gender
                                          location:(NSString *)location
                                          birthday:(NSDate *)birthday
                                         signature:(NSString *)signature ;

@end


@protocol user2userIdXMLInterface <NSObject>

@required

/**
 *  用户Id @"10000001"
 */
@property (nonatomic) NSString *userId ;

/**
 *  用户名 @"qianyan"
 */
@property (nonatomic) NSString *username ;

/**
 *  用户昵称 @"严冬冬"
 */
@property (nonatomic) NSString *nickname ;

/**
 *  备注吗 @"东东"
 */
@property (nonatomic) NSString *remarkname ;

/**
 *  关注人数 1
 */
@property (nonatomic,assign) NSInteger follow ;

/**
 *  粉丝 1
 */
@property (nonatomic,assign) NSInteger fans ;

/**
 *  黑名单个数 0
 */
@property (nonatomic,assign) NSInteger black ;

/**
 *  不详 0
 */
@property (nonatomic,assign) NSInteger shield ;

/**
 *  jpro 信息http://qycam.com:50551
 */
@property (nonatomic) NSString *jpro ;

@optional

/**
 *  获取userId.xml文本
 *
 *  @return userId.xml文本
 */
- (NSString *)getUserIdXMLString ;

/**
 *  userId.xml 2 instance
 *
 *  @param xmlStr xml 文档
 *
 *  @return id<user2userIdXMLInterface>
 */
+ (id<user2userIdXMLInterface>)userIDXML2Instance:(NSString *)xmlStr ;

/**
 *  构造方法
 */
+ (id<user2userIdXMLInterface>)instanceWithUserId:(NSString *)userId
                                         username:(NSString *)username
                                         nickname:(NSString *)nickname
                                       remarkname:(NSString *)remarkname
                                           follow:(NSInteger)follow
                                             fans:(NSInteger)fans
                                            black:(NSInteger)black
                                           shield:(NSInteger)shield
                                             jpro:(NSString *)jpro ;

@end

#endif