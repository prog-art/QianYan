//
//  QYUser.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QYUser.h"

#import "QY_XMLService.h"
#import "QY_FileService.h"
#import "QY_JPRO.h"

#import "QY_Socket.h"

#import "QY_appDataCenter.h"

static QYUser *_currentUser = nil ;

@interface QYUser ()

/**
 *  密码
 */
@property (nonatomic) NSString *password ;

@end

@implementation QYUser

+ (instancetype)currentUser {
    return _currentUser ;
}

+ (instancetype)user {
    return [[QYUser alloc] init] ;
}

+ (instancetype)userWithName:(NSString *)username Password:(NSString *)password {
    QYUser *user = [QYUser user] ;
    user.username = username ;
    user.password = password ;
    
    return user ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setup] ;
    }
    return self ;
}

- (void)setup {
    
    //默认值
    self.userId = @"" ;
    self.username = @"" ;
    self.gender = @"男" ;
    self.location = nil ;
    self.birthday = [NSDate date] ;
    self.signature = @"" ;
    self.nickname = @"" ;
    self.remarkname = @"" ;
    self.telephone = @"" ;
    self.email = @"" ;
    self.userJss = @"" ;
    self.userFriendList = @[] ;
    self.userCameraList = @[] ;
}


#pragma mark - 注册

+ (void)registeName:(NSString *)username
           Password:(NSString *)password
        complection:(QYUserBlock)complection {
    __block QYUser *user = [QYUser userWithName:username Password:password] ;
    complection = ^(QYUser *registedUser , NSError *error) {
        if ( complection ) {
            complection(registedUser,error) ;
        }
    } ;

    QY_SocketAgent *agent = [QY_SocketAgent shareInstance] ;
    
    [agent userRegisteRequestWithName:username Psd:password Complection:^(NSDictionary *info, NSError *error) {
        if ( !error && info ) {
            NSString *userId = info[ParameterKey_userId] ;
            QYDebugLog(@"注册的userId = %@",userId) ;
            user.userId = userId ;
            
            QYDebugLog(@"before") ;
            user.coreUser = [QY_user insertUserById:user.userId] ;
            QYDebugLog(@"after") ;
            
            user.coreUser.userName = user.username ;
#warning nickname 后会增加一个界面设置。
            user.coreUser.nickname = user.username ;
            
            [QY_appDataCenter saveObject:nil error:NULL] ;
            
            complection(user,nil) ;
        } else {
            QYDebugLog(@"向jrm注册用户出错 error = %@",error) ;
            error = [NSError QYErrorWithCode:REGISTE_ERROR_USERNAME_EXISTED
                                 description:@"用户名已经存在"] ;
            complection(false,error) ;
        }
    }] ;
}

- (void)uploadProfileComplection:(QYResultBlock)complection {
    complection = ^(BOOL result , NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;

    QYDebugLog(@"上传profile.xml") ;
    [self.coreUser saveUserInfoComplection:^(QY_user *user, NSError *error) {
        if ( user && !error ) {
            complection(true,nil) ;
        } else {
            complection(false,error) ;
        }
    }] ;
}

#pragma mark - 登录

+ (void)loginName:(NSString *)username Password:(NSString *)password complection:(QYResultBlock)complection {
    QYUser *user = [QYUser userWithName:username Password:password] ;
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    QY_SocketAgent *agent = [QY_SocketAgent shareInstance] ;
    
    [agent userLoginRequestWithName:username Psd:password Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"登录成功 接下来去获取userId") ;
            [agent getUserIdByUsername:username Complection:^(NSDictionary *info, NSError *error) {
                
                if ( !error ) {
                    user.userId = info[ParameterKey_userId] ;
                    
                    user.coreUser = [QY_appDataCenter userWithId:user.userId] ;

                    
                    [user.coreUser fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
                        if ( success ) {
                            _currentUser = user ;
                            [QY_appDataCenter saveObject:nil error:NULL] ;
                            complection(TRUE,nil) ;
                        } else {
                            complection(false,error) ;
                        }
                    }] ;

                } else {
                    QYDebugLog(@"通过用户名获取UserId出错 error = %@",error) ;
                    error = [NSError QYErrorWithCode:JRM_GET_USERID_BY_ID_ERROR
                                         description:@"请检查网络"] ;
                    complection(false,error) ;
                }
            }] ;
        } else {
            QYDebugLog(@"登录失败 error = %@",error) ;
            error = [NSError QYErrorWithCode:Login_Error_Username_Or_Password description:@"用户名或密码出错"] ;
            complection(false,error) ;
        }
    }] ;
    
}

- (void)downloadProfileComplection:(QYResultBlock)complection {
    assert(complection) ;
    
    [self.coreUser fetchUserInfoComplection:^(QY_user *user, NSError *error) {
        if ( user && !error ) {
            complection(YES,nil) ;
        } else {
            NSError *error = [NSError QYErrorWithCode:JPRO_DOWNLOAD_PROFILE_ERROR description:@"下载PROFILE的时候出错"] ;
            complection(false,error) ;
        }
    }] ;
}

#pragma mark - 注销

+ (void)logOffComplection:(QYResultBlock)complection {
#warning 改
    complection = ^(BOOL result , NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    _currentUser = nil ;
    complection(TRUE,nil) ;
}

#pragma mark - getter & setter

- (QY_user *)coreUser {
    if ( !_coreUser ) {
        _coreUser = [QY_user findUserById:self.userId] ;
    }
    return _coreUser ;
}

@end