//
//  QY_tempHttpService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JPROHttpService.h"

#import <AFNetworking/AFNetworking.h>
#import "QY_Common.h"
#import "QY_CoreDataModels.h"

#define JPRO_IP @"qycam.com"
#define JPRO_PORT @"50300"
//#define JPRO_PORT @"50060"

#import "QY_jpro_parameter_key_marco.h"
#import "QY_FileService.h"


NSString * const kUserDefaultsCookie = @"UserCookie" ;

@interface QY_JPROHttpService ()

- (NSString *)baseUrl ;

@end

@implementation QY_JPROHttpService

@synthesize jpro_ip = _jpro_ip ;
@synthesize jpro_port = _jpro_port ;

+ (instancetype)shareInstance {
    static QY_JPROHttpService *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_JPROHttpService alloc] init] ;
    }) ;
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    [self readCookiesToCookiesStorage] ;
}

#pragma mark - getter && setter

- (NSString *)jpro_ip {
    return _jpro_ip ? : JPRO_IP ;
}

- (NSString *)jpro_port {
    return _jpro_port ? : JPRO_PORT ;
}

/**
 *  jpro的URL
 *
 *  @return
 */
- (NSString *)baseUrl {
    return [NSString stringWithFormat:@"http://%@:%@",self.jpro_ip,self.jpro_port] ;
}

- (void)configIp:(NSString *)jpro_ip Port:(NSString *)jpro_port {
    static dispatch_once_t onceToken ;
    
    if ( !jpro_ip && !jpro_port ) {
        [NSException raise:@"jpro ip port info config exception" format:@"空的ip和port传入"] ;
        return ;
    }
    
    dispatch_once(&onceToken, ^{
        _jpro_ip = jpro_ip ;
        _jpro_port = jpro_port ;
    }) ;
}

/**
 *  封装一层Block
 */
QYResultBlock packComplection(QYResultBlock complection) {
    return ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
}

#pragma mark - Cookies

- (NSArray *)cookiesForURL:(NSString *)urlString {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlString]] ;
    return cookies ;
}

/**
 *  持久化保存cookie，下次登录时，调用readCookiesToCookiesStorage读取到系统缓存中。
 *
 *  @param cookies
 */
- (void)saveCookies:(NSArray *)cookies {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies] ;
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie] ;
}

/**
 *  读取持久话cookie到系统缓存中。
 */
- (void)readCookiesToCookiesStorage {
    NSData *cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie] ;
    if ( [cookiesData length] ) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData] ;
        [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie] ;
        }] ;
    }
}

/**
 *  注销时，清除cookies
 *
 *  @return 是否清除成功
 */
- (BOOL)clearCookies {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie] ;
    return [[NSUserDefaults standardUserDefaults] synchronize] ;
}

- (void)saveCookiesForURL:(NSString *)urlString {
    NSArray *cookies = [self cookiesForURL:urlString] ;
    [self saveCookies:cookies] ;
}


#pragma mark - JPRO 

/**
 *  登录JPRO服务器
 *
 *  @param userId      @"10000133"
 *  @param password    @"123456"
 *  @param complection
 */
- (void)jproLoginWithUserId:(NSString *)userId
                   Password:(NSString *)password
                Complection:(QYResultBlock)complection {
    assert(userId) ;
    assert(password) ;
    complection = packComplection(complection) ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/login/",self.baseUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary] ;
    {
        [parameters setObject:userId forKey:QY_key_user_id] ;
        [parameters setObject:password forKey:QY_key_password] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"登录成功") ;
        complection(true,nil) ;
        
        [self saveCookiesForURL:self.baseUrl] ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"登录失败 error = %@",error) ;
        complection(false,error) ;
    }] ;
    
}

/**
 *  注销用户登录
 *
 *  @param complection
 */
- (void)jproLogoutComplection:(QYResultBlock)complection {
    complection = packComplection(complection) ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/logout/",self.baseUrl];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"注销成功") ;
        [self clearCookies] ;
        complection(true,false) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"注销失败 error = %@",error) ;
        complection(false,error) ;
    }] ;
}

#pragma makr - JPRO Alert Message 

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
                    Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/",self.baseUrl] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary] ;
    {
        if ( page ) [parameters setObject:@(page) forKey:QY_key_page] ;
        if ( num ) [parameters setObject:@(num) forKey:QY_key_num] ;
        if ( type ) [parameters setObject:@(type) forKey:QY_key_type] ;
        if ( userId ) [parameters setObject:userId forKey:QY_key_user_id] ;
        if ( cameraId ) [parameters setObject:cameraId forKey:QY_key_jipnc_id] ;
        if ( startId ) [parameters setObject:startId forKey:QY_key_start] ;
        if ( endId ) [parameters setObject:endId forKey:QY_key_end] ;
        if ( check ) [parameters setObject:check forKey:QY_key_check] ;
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray *alertMsgs) {
        QYDebugLog(@"获取报警信息列表成功！alertMsgs = %@",alertMsgs) ;
        NSMutableArray *alertMessages = [NSMutableArray array] ;
        [alertMsgs enumerateObjectsUsingBlock:^(NSDictionary *messageDic, NSUInteger idx, BOOL *stop) {
            QY_alertMessage *alertMessage = [[QY_alertMessage alloc] initWithDictionary:messageDic] ;
            [alertMessages addObject:alertMessage] ;
        }] ;
        complection(alertMessages,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"获取报警信息类表失败！error = %@",error) ;
        complection(nil,error) ;
    }] ;
    
}

/**
 *  2.删除msg列表
 *
 *  @param messageIds  要删除的msg列表
 *  @param complection
 */
- (void)deleteAlertMessages:(NSSet *)messageIds
                Complection:(QYArrayBlock)complection {
    assert(messageIds) ;
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/",self.baseUrl] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary] ;
    {
        [parameters setObject:messageIds
                       forKey:QY_key_msg_list] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager DELETE:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray *deletedMsgIds) {
        QYDebugLog(@"删除msg成功 response = %@",deletedMsgIds) ;
        complection(deletedMsgIds,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"添加msg失败 error = %@",error) ;
        complection(nil,error) ;
    }] ;
}

/**
 *  3.通过msgId获取某个Alert Message
 *
 *  @param msgId
 *  @param complection
 */
- (void)getMsgById:(NSString *)msgId Complection:(QYObjectBlock)complection{
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/%@/",self.baseUrl,msgId] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *alertMsgDic) {
        QYDebugLog(@"获取某个msg成功 response = %@",alertMsgDic) ;
        QY_alertMessage *alertMessage = [[QY_alertMessage alloc] initWithDictionary:alertMsgDic] ;
        complection(alertMessage,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"添加msg失败 error = %@",error) ;
        complection(nil,error) ;
    }] ;
}

/**
 *  4.通过msgId删除某个Alert Message
 *
 *  @param msgId
 */
- (void)deleteMsgById:(NSString *)msgId Complection:(QYResultBlock)complection {
    complection = ^(BOOL result , NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/%@/",self.baseUrl,msgId] ;
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"删除某个msg成功") ;
        
        complection(TRUE,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除某个msg失败 error = %@",error) ;
        
        complection(FALSE,error) ;
    }] ;
}

/**
 *  5.获取某相机的报警消息用户分享列表
 *
 *  @param cameraId
 *  @param complection
 */
- (void)getCameraShareList:(NSString *)cameraId Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/group/%@/",self.baseUrl,cameraId] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *sharedUserIds) {
        QYDebugLog(@"获取相机对用户的分享列表成功 response = %@",sharedUserIds) ;
        
        complection(sharedUserIds,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"获取相机对用户的分享列表失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

/**
 *  6.增加某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userIds     用户ID
 *  @param complection
 */
- (void)shareCamera:(NSString *)cameraId toUsers:(NSSet *)userIds Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/group/%@/",self.baseUrl,cameraId] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary] ;
    {
        [param setObject:userIds forKey:QY_key_shared_user_list] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager PUT:urlString parameters:param success:^(AFHTTPRequestOperation *operation, NSArray *sharedUserIds) {
        QYDebugLog(@"增加某相机的报警信息对用户的分享成功 response = %@",sharedUserIds) ;
        
        complection(sharedUserIds,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"增加某相机的报警信息对用户的分享失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}


/**
 *  7.(相机拥有者角度)删除某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userIds     用户IDs
 *  @param complection
 */
- (void)cancelShareCamer:(NSString *)cameraId toUsers:(NSSet *)userIds Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/group/%@/",self.baseUrl,cameraId] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary] ;
    {
        [param setObject:userIds forKey:QY_key_shared_user_list] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager DELETE:urlString parameters:param success:^(AFHTTPRequestOperation *operation, NSArray *canceledUserIds) {
        QYDebugLog(@"删除某相机的报警信息对用户的分享成功 response = %@",canceledUserIds) ;
        
        complection(canceledUserIds,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除某相机的报警信息对用户的分享失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

/**
 *  7.(被分享者角度)删除某相机的报警信息对用户的分享
 *
 *  @param cameraId    相机ID
 *  @param userId     用户IDs
 *  @param complection
 */
- (void)cancelShareCamer:(NSString *)cameraId toUser:(NSString *)userId Complection:(QYResultBlock)complection {
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/group/%@/",self.baseUrl,cameraId] ;
    
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject ) {
        QYDebugLog(@"删除某相机的报警信息对用户的分享成功") ;
        
        complection(TRUE,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除某相机的报警信息对用户的分享失败 error = %@",error) ;
        
        complection(FALSE,error) ;
    }] ;
}

/**
 *  8.上传图片
 *
 *  @param attachmentData 附件Data
 *  @param complection
 */
- (void)uploadImageAttach:(NSData *)attachmentData Complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/attaches/",self.baseUrl] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:attachmentData
                                    name:@"attach"
                                fileName:@"test.jpg"
                                mimeType:MIMETYPE] ;
        
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *attachIdDic) {
        QYDebugLog(@"上传成功 response = %@",attachIdDic) ;
        
        complection(attachIdDic[QY_key_id],nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"上传失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

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
                            Complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/attaches/",self.baseUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary] ;
    {
        [param setObject:src forKey:QY_key_src] ;
        [param setObject:type forKey:QY_key_type] ;
        if ( medium ) [param setObject:medium forKey:QY_key_medium] ;
        if ( small ) [param setObject:small forKey:QY_key_small] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager PUT:urlString parameters:param success:^(AFHTTPRequestOperation *operation, NSDictionary *attachIdDic) {
        QYDebugLog(@"关联成功") ;
        
        complection(attachIdDic[QY_key_id],nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"关联失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

/**
 *  10.发表状态feed,注意type字段，1代表message分享，2.代表附件图片分享，3.代表普通文字分享
 *
 *  @param content     内容
 *  @param attachesIds 附件IDs
 *  @param messageIds  消息IDs
 *  @param complection
 */
- (void)createAttachFeedWithContent:(NSString *)content
                           Attaches:(NSSet *)attachesIds
                           Messages:(NSSet *)messageIds
                        Complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    if ( [attachesIds count] !=0 && [messageIds count] != 0) {
        [NSException raise:@"QY_Parameter_Exception" format:@"attachesIds & messageIds 不能同时传入。"] ;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/",self.baseUrl] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary] ;
    {
        [param setObject:content forKey:QY_key_content] ;
        
        NSNumber *type = @3 ;

        
        if ( messageIds.count != 0 ) {
            [param setObject:[messageIds allObjects] forKey:QY_key_messages] ;
            type = @1 ;
        }

        if ( attachesIds.count != 0 ) {
            [param setObject:[attachesIds allObjects] forKey:QY_key_attaches] ;
            type = @2 ;
        }

        [param setObject:type forKey:QY_key_type] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager PUT:urlString parameters:param success:^(AFHTTPRequestOperation *operation, NSDictionary *feedIdDic) {
        QYDebugLog(@"发表状态feed 成功 feedId = %@",feedIdDic) ;
        
        complection(feedIdDic[QY_key_id],nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"发表状态feed 失败 error = %@",error) ;
        complection(nil,error) ;
    }] ;
}

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
                Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/",self.baseUrl] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary] ;
    {
        if (page) [parameters setObject:@(page) forKey:QY_key_page] ;
        if (@(num)) [parameters setObject:@(num) forKey:QY_key_num] ;
        if (userId) [parameters setObject:userId forKey:QY_key_user_id] ;
        if (startId) [parameters setObject:startId forKey:QY_key_start] ;
        if (endId) [parameters setObject:endId forKey:QY_key_end] ;
        if (check) [parameters setObject:check forKey:QY_key_check] ;
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray *feedDicArray) {
        QYDebugLog(@"获取状态列表feed 成功 response = %@",feedDicArray) ;
        
        NSMutableArray *feeds = [NSMutableArray array] ;
        [feedDicArray enumerateObjectsUsingBlock:^(NSDictionary *feedDic, NSUInteger idx, BOOL *stop) {
#warning 未测试
            QY_feed *feed = [[QY_feed alloc] initWithFeedDic:feedDic] ;
            [feeds addObject:feed] ;
        }] ;
        
        complection(feeds,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"获取状态列表feed 失败 error = %@",error) ;
        complection(nil,error) ;
    }] ;
}


/**
 *  12.获取某个状态feed
 *
 *  @param feedId      feedId
 *  @param complection
 */
- (void)getFeedById:(NSString *)feedId
        Complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/%@/",self.baseUrl,feedId];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *feedDic) {
        QYDebugLog(@"获取某个状态feed 成功 response = %@",feedDic) ;

#warning !
//        QY_feed *feed = [[QY_feed alloc] initWithFeedDic:feedDic] ;
//        
//        complection(feed,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"获取某个状态feed 失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

/**
 *  13.删除状态feed
 *
 *  @param feedId      feedId
 *  @param complection
 */
- (void)deleteFeedById:(NSString *)feedId
           Complection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/%@/",self.baseUrl,feedId] ;
    
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"删除某个状态feed 成功") ;
        complection(TRUE,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除某个状态feed 失败 error = %@",error) ;
        complection(FALSE,nil) ;
    }] ;
}



/**
 *  14.发表评论comment
 *
 *  @param feedId      feedId
 *  @param comment     评论内容
 *  @param complection
 */
- (void)addCommentToFeed:(NSString *)feedId
                 Comment:(NSString *)comment
             Complection:(QYObjectBlock)complection {
    assert(comment) ;
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/%@/comments",self.baseUrl,feedId];
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary] ;
    {
        [param setObject:comment forKey:QY_key_content];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager PUT:urlString parameters:param success:^(AFHTTPRequestOperation *operation, NSDictionary *commentIdDic) {
        QYDebugLog(@"发表评论 成功 response = %@",commentIdDic) ;
        
        complection(commentIdDic[QY_key_id],nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"发表评论 失败 error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}


/**
 *  15.删除评论
 *
 *  @param commentId   评论ID
 *  @param complection
 */
- (void)deleteCommentById:(NSString *)commentId
              Complection:(QYResultBlock)complection {
    assert(commentId) ;
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/comments/%@/",self.baseUrl,commentId] ;
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"删除评论 成功") ;
        
        complection(TRUE,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除评论 失败 error = %@",error) ;
        
        complection(FALSE,error) ;
    }] ;
}

/**
 *  16.点赞digg
 *
 *  @param feedId      feedID
 *  @param complection
 */
- (void)diggForFeed:(NSString *)feedId
        Complection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/%@/digg/",self.baseUrl,feedId] ;
    
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"点赞 成功") ;
        
        complection(TRUE,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"点赞 失败 error = %@",error) ;
        
        complection(false,error) ;
    }] ;
}

/**
 *  17.取消点赞digg
 *
 *  @param feedId      feedID
 *  @param complection
 */
- (void)cancelDiggForFeed:(NSString *)feedId Complection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/feeds/%@/digg/",self.baseUrl,feedId] ;
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"取消点赞 成功") ;
        
        complection(TRUE,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"取消点赞 失败 error = %@",error) ;
        
        complection(FALSE,error) ;
    }] ;
}

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
                    Fail:(QY_AFFailBlock)fail {
    if ( !isFileUrlCorrect(fileUrl) ) {
        //文件路径出错
        if ( fail ) {
            NSError *error = [NSError QYErrorWithCode:FILEURL_ERROR description:@"提供的文件URL出错"] ;
            fail(nil,error) ;
        }
        return ;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/files/upload/?path=%@",self.baseUrl,path] ;
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSError *error ;
        [formData appendPartWithFileURL:fileUrl
                                   name:@"file"
                               fileName:filename
                               mimeType:fileType
                                  error:&error] ;
        
        if ( error ) {
            QYDebugLog(@"加载数据失败 error = %@",error) ;
            return ;
        }
        
        QYDebugLog(@"加载数据成功") ;
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"成功 responseObject = %@",responseObject) ;
        if ( success ) {
            success(operation,responseObject) ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"失败 error = %@",error) ;
        if ( fail ) {
            fail(operation,error) ;
        }
    }] ;
}

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
             Complection:(QYResultBlock)complection {
    assert(path) ;
    assert(data) ;
    assert(name) ;
    assert(mimeType) ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/files/upload/?path=%@",self.baseUrl,path] ;
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:name
                                mimeType:mimeType] ;
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"上传成功") ;
        complection(true,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"上传失败") ;
        complection(false,error) ;
        
    }] ;
    
}

/**
 *  19.从服务器下载文件
 *
 *  @param Path        服务器Path @"user/10000010/profile.xml"
 *  @param fileUrl     FILE URL
 *  @param complection 回调
 */
- (void)downloadFileFromPath:(NSString *)path
               saveToFIleURL:(NSURL *)fileUrl
                 complection:(QY_DownloadComplectionBlock)complection {
    assert(fileUrl) ;
    AFURLSessionManager *manager = [self getADefaultSessionManager] ;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/archives/%@",self.baseUrl,path] ;
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //指定下载文件保存的路径
        QYDebugLog(@"fileUrl = %@",fileUrl) ;
        BOOL reachability = makeFIleUrlReachabily(fileUrl) ;
        if ( reachability )
            return fileUrl ;
        else
            return nil ;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if ( [(NSHTTPURLResponse *)response statusCode] == 404 ) {
            QYDebugLog(@"404 not found") ;
            
        } else {
            QYDebugLog(@"response = %@",response) ;
            
            QYDebugLog(@"filePath = %@\n error = %@",filePath,error) ;
            
            QYDebugLog(@"fileExists? = %@",[[QY_FileService fileManager] fileExistsAtPath:[filePath path]] ? @"存在" : @"不存在") ;
            
            QYDebugLog(@"file content = %@",[QY_FileService getTextContentAtPath:[filePath path]]) ;
        }
        
        if ( complection ) {
            complection(filePath,error) ;
        }
        
    }] ;
    
    [task resume] ;
}

/**
 *  19[2].从服务器读取文件内容到Memory
 *
 *  @param path        [必填]服务器Path @"user/10000133/profile.xml"
 *  @param complection 回调
 */
- (void)downloadFileFromPath:(NSString *)path
                 complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            if ( object ) {
                NSString *fileStr = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding] ;
                object = fileStr ;
            }
            complection(object,error) ;
        }
    } ;
    [self downloadFileDataFromPath:path isImageFile:NO complection:complection] ;
}

/**
 *  19[3].从服务器读取图片Data到Memory
 *
 *  @param path        [必填]服务器Path @"user/10000133/profile.xml"
 *  @param complection
 */
- (void)downloadImageFromPath:(NSString *)path
                  complection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    [self downloadFileDataFromPath:path isImageFile:YES complection:complection] ;
}

/**
 *  20.获取档案目录文件列表
 *
 *  @param path        服务器路径
 *  @param complection
 */
- (void)getDocumentListForPath:(NSString *)path
                   Complection:(QYArrayBlock)complection {
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/files/list/",self.baseUrl] ;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary] ;
    {
        [parameter setObject:path forKey:@"path"] ;
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [manager GET:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, NSArray *fileList) {
        QYDebugLog(@"获取文件列表成功 response = %@",fileList) ;
        
        complection(fileList,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"获取文件列表失败，error = %@",error) ;
        
        complection(nil,error) ;
    }] ;
}

/**
 *  21.删除档案目录或文件
 *
 *  @param path        服务器路径
 *  @param complection
 */
- (void)clearDocumentOnPath:(NSString *)path
                Complection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSString *urlString = [NSString stringWithFormat:@"%@/files/clear/",self.baseUrl] ;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary] ;
    {
        [parameter setObject:path forKey:@"path"] ;
    }
    
    [manager GET:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"删除档案目录或文件成功") ;
        
        complection(TRUE,nil) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"删除档案目录或文件失败，error = %@",error) ;
        
        complection(FALSE,error) ;
    }] ;
    
}


#pragma mark - Other Method

/**
 *  检查FileUrl的正确性
 *
 *  @return 是否是fileUrl && Url上存在文件
 */
BOOL isFileUrlCorrect(NSURL *fileUrl) {
    BOOL isDir = FALSE ;
    if ( [fileUrl isFileURL] && [[QY_FileService fileManager] fileExistsAtPath:fileUrl.path isDirectory:&isDir]) {
        QYDebugLog(@"文件存在 path = %@",fileUrl) ;
        return TRUE ;
    }
    QYDebugLog(@"文件不存在 path = %@",fileUrl) ;
    return FALSE ;
}

- (AFURLSessionManager *)getADefaultSessionManager {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config] ;
    return manager ;
}


/**
 *  下载文件时，指定路径，把路径变为可写的。
 *
 *  @return 是否可写
 */
BOOL makeFIleUrlReachabily(NSURL *fileUrl) {
    if ( ![fileUrl isFileURL]) {
        QYDebugLog(@"fileUrl出错，不是file Url") ;
        return FALSE ;
    }
    NSString *path = [fileUrl path] ;
    NSString *dirPath = [path stringByDeletingLastPathComponent] ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    {
        //检查路径文件夹
        BOOL isDir = YES ;
        if ( ![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
            NSError *error ;
            [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error] ;
            if ( error ) {
                QYDebugLog(@"创建文件夹失败") ;
                return FALSE ;
            }
            QYDebugLog(@"创建文件夹成功") ;
            return TRUE ;
        }
        QYDebugLog(@"文件夹存在，检查是否存在。") ;
    }
    
    {
        //检查路径文件存在与否 ;
        BOOL isDir = NO ;
        if ( [fileManager fileExistsAtPath:path isDirectory:&isDir]) {
            NSError *error ;
            [fileManager removeItemAtPath:path error:&error] ;
            
            if ( error ) {
                QYDebugLog(@"原路径存在文件，尝试移除失败") ;
                return FALSE ;
            }
            QYDebugLog(@"原路径存在文件，移除成功") ;
            return TRUE ;
        }
        QYDebugLog(@"原路径不存在文件，可写") ;
    }
    QYDebugLog(@"路径合法！") ;
    return TRUE ;
}

#pragma mark - JPRO 内自封装的接口

/**
 *  上传用户头像
 *
 *  @param userId      [必填]用户Id
 *  @param avatar      [必填]头像图片
 *  @param complection
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar Complection:(QYResultBlock)complection {
    complection = ^(BOOL success ,NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    NSString *path = [NSString stringWithFormat:@"user/%@/headpicture.jpg",userId] ;
    
#warning 图片未压缩
    NSData *imageData = UIImageJPEGRepresentation(avatar, 1.0f) ;
    
    [self uploadFileToPath:path
                  FileData:imageData
                  fileName:@"headpicture.jpg"
                  mimeType:MIMETYPE
               Complection:complection] ;
}

- (void)deleteFriendWithFriendId:(NSString *)friendId selfId:(NSString *)selfId complection:(QYResultBlock)complection {
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
#warning 这里对JPRO的操作，不应该客户端来保证原子性！！一旦某个操作失败很容易导致数据被污染。
    QYDebugLog(@"删除好友 friendId = %@",friendId) ;
    
    if ( !friendId || !selfId ) {
        NSError *error = [NSError QYErrorWithCode:PARAMETER_NULL_ERROR description:@"参数为空"] ;
        complection(FALSE,error) ;
        return ;
    }
    
    dispatch_group_t group = dispatch_group_create() ;
    
    __block NSError *error1 ;
    __block NSError *error2 ;
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
        //删除自己
        NSString *path = [QY_JPROUrlFactor pathForUserFriendList:friendId FriendId:selfId] ;
        
        [self clearDocumentOnPath:path Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"删除自己成功") ;
            } else {
                QYDebugLog(@"删除自己失败 error = %@",error) ;
                error1 = error ;
            }
            
            dispatch_semaphore_signal(sema) ;
        }] ;
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER) ;
        QYDebugLog(@"删除自己完成") ;
    }) ;
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
        //删除别人
        NSString *path = [QY_JPROUrlFactor pathForUserFriendList:selfId FriendId:friendId] ;
        
        [self clearDocumentOnPath:path Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"删除别人成功") ;
            } else {
                QYDebugLog(@"删除别人失败 error = %@",error) ;
                error2 = error ;
            }
            dispatch_semaphore_signal(sema) ;
        }] ;
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER) ;
        QYDebugLog(@"删除别人完成") ;
    }) ;

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ( !error2 && !error1 ) {
            QYDebugLog(@"远端数据删除成功，回调后请删除本地数据库数据") ;
            complection(TRUE,nil) ;
        } else {
#warning 如果出现这步，就非常严重了。
            NSError *error = error1 ? : error2 ;
            complection(FALSE,error) ;
        } ;
        
    }) ;
    
}

/**
 *  下载文件到内存
 *
 *  @param path        [必填]服务器上的路径
 *  @param typeImage   更具这个选择ResponseSerializer
 *  @param complection 回调
 */
- (void)downloadFileDataFromPath:(NSString *)path
                     isImageFile:(BOOL)typeImage
                     complection:(QYObjectBlock)complection {
    assert(path) ;
    assert(complection) ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/archives/%@",self.baseUrl,path] ;
    
    manager.responseSerializer = typeImage ? [AFImageResponseSerializer serializer] : [AFHTTPResponseSerializer serializer] ;
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complection(responseObject,nil) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complection(nil,error) ;
    }] ;
}

#pragma mark - test 

- (void)testUpload {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/files/upload/?path=user/10000133/profile.xml",self.baseUrl] ;
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = [@"testJpro300" dataUsingEncoding:NSUTF8StringEncoding] ;
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"profile.xml" mimeType:@"multipart/form-data"] ;
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"成功 responseObject = %@",responseObject) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"失败 error = %@",error) ;
        
    }] ;
}

- (void)testDownload {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/archives/user/10000133/profile.xml",self.baseUrl] ;
//    manager.responseSerializer = [AFXMLParserResponseSerializer serializer] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"responseObject = %@",responseObject) ;
        
        QYDebugLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"error = %@",error) ;
    }] ;
}

- (void)testDownload2 {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    NSString *urlStr = [NSString stringWithFormat:@"%@/archives/user/10000133/headpicture.jpg",self.baseUrl] ;
    
    manager.responseSerializer = [AFImageResponseSerializer serializer] ;
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"responseObject = %@,class = %@",responseObject,[responseObject class]) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"error = %@",error) ;
    }] ;
}

@end