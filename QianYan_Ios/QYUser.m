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

static QYUser *_currentUser = nil ;

typedef NS_ENUM(NSInteger, UserWorkingState) {
    UserWorkingState_None = 0 ,
    UserWorkingState_Registe = 1 ,
    UserWorkingState_Login = 2
} ;

@interface QYUser () {
    NSString *_xmlFilePath ;
}


/**
 *  判断当前是注册在工作还是登录在工作
 */
@property (nonatomic,assign) UserWorkingState workingState ;

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

/**
 *  构造方法Self
 */
+ (QYUser *)instanceWithUserId:(NSString *)userId
                      username:(NSString *)username
                        gender:(NSString *)gender
                      location:(NSString *)location
                      birthday:(NSDate *)birthday
                     signature:(NSString *)signature {
    QYUser *user = [QYUser user] ;
    
    user.userId = userId ;
    user.username = username ;
    user.gender = gender ;
    user.location = location ;
    user.birthday = birthday ;
    user.signature = signature ;
    
    return user ;
}

/**
 *  构造方法Friend
 */
+ (QYUser *)instanceWithUserId:(NSString *)userId
                      username:(NSString *)username
                      nickname:(NSString *)nickname
                    remarkname:(NSString *)remarkname
                        follow:(NSInteger)follow
                          fans:(NSInteger)fans
                         black:(NSInteger)black
                        shield:(NSInteger)shield
                          jpro:(NSString *)jpro {
    QYUser *user = [QYUser user] ;
    
    user.userId = userId ;
    user.username = username ;
    user.nickname = nickname ;
    user.remarkname = remarkname ;
    user.follow = follow ;
    user.fans = fans ;
    user.black = black ;
    user.shield = shield ;
    user.jpro = jpro ;
    
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
    self.location = @"" ;
    self.birthday = [NSDate date] ;
    self.signature = @"" ;
    self.nickname = @"" ;
    self.remarkname = @"" ;
    self.follow = 0 ;
    self.fans = 0 ;
    self.black = 0 ;
    self.shield = 0 ;
    self.jpro = @"" ;
    self.telephone = @"" ;
    self.email = @"" ;
    self.userJpro = @"" ;
    self.userJss = @"" ;
    self.userFriendList = @[] ;
    self.userCameraList = @[] ;
    self.xmlFilePath = nil ;
}

#pragma mark - 注册

+ (void)registeName:(NSString *)username Password:(NSString *)password complection:(QYUserBlock)complection {
    __block QYUser *user = [QYUser userWithName:username Password:password ] ;
    complection = ^(QYUser *registedUser , NSError *error) {
        if ( complection ) {
            complection(registedUser,error) ;
        }
    } ;
    user.workingState = UserWorkingState_Registe ;

    QY_SocketAgent *agent = [QY_SocketAgent shareInstance] ;
    
    [agent userRegisteRequestWithName:username Psd:password Complection:^(NSDictionary *info, NSError *error) {
        if ( !error ) {
            NSString *userId = info[ParameterKey_userId] ;
            user.userId = userId ;
            QYDebugLog(@"注册的userId = %@",userId) ;
            [agent getJPROServerInfoForUser:userId Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    user.jproIp   = info[ParameterKey_jproIp] ;
                    user.jproPort = info[ParameterKey_jproPort] ;
                    user.jproPsd  = info[ParameterKey_jproPassword] ;
                    [user uploadProfileComplection:complection] ;
                    
                } else {
                    QYDebugLog(@"获取用户jpro服务器信息出错 error = %@",error) ;
                    error = [NSError QYErrorWithCode:RegisteStep2_Error description:@"注册第二步出错，获取JPRO服务器信息出错。"] ;
                    complection(false,error) ;
                }
            }] ;
        } else {
            QYDebugLog(@"想jrm注册用户出错 error = %@",error) ;
            complection(false,error) ;
        }
    }] ;
}

/**
 *  上传user profile.xml
 */
- (void)uploadProfileComplection:(QYUserBlock)complection {
    assert(complection) ;
    QYDebugLog(@"上传profile.xml") ;
    
    [self createTempProfile] ;

    BOOL isDir = FALSE ;
    NSURL *fileUrl = [NSURL fileURLWithPath:self.xmlFilePath isDirectory:&isDir] ;
    //upload
    WEAKSELF
    [[QY_JPROHttpService shareInstance] uploadFileToPath:[QY_JPROUrlFactor pathForUserProfile:self.userId]
                                                 FileURL:fileUrl
                                                fileName:@"profile.xml"
                                                fileType:MIMETYPE Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    QYDebugLog(@"上传成功") ;
        BOOL result = [weakSelf removeTempProfile2UserProfilePath] ;
        
        if ( result ) {
            QYDebugLog(@"移动成功") ;
            complection(weakSelf,nil) ;
        } else {
            QYDebugLog(@"移动失败") ;
            
            NSError *error = [NSError QYErrorWithCode:RegisteStep4_Error description:@"册第四部出错，移动和重命名temp.xml --> profile.xml"] ;
            complection(weakSelf,error) ;
        }
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"上传失败 error = %@",error) ;
        
        error = [NSError QYErrorWithCode:RegisteStep3_Error description:@"注册第三步出错，upload profile.xml出错。"] ;
        complection(weakSelf,error) ;
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

    user.workingState = UserWorkingState_Login ;
    
    QY_SocketAgent *agent = [QY_SocketAgent shareInstance] ;
    
    [agent userLoginRequestWithName:username Psd:password Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"登录成功 接下来去获取userId") ;
            [agent getUserIdByUsername:username Complection:^(NSDictionary *info, NSError *error) {
                
                if ( !error ) {
                    user.userId = info[ParameterKey_userId] ;
                    
                    [agent getJPROServerInfoForUser:user.userId Complection:^(NSDictionary *info, NSError *error) {
                        if ( !error ) {
                            user.jproIp   = info[ParameterKey_jproIp] ;
                            user.jproPort = info[ParameterKey_jproPort] ;
                            user.jproPsd  = info[ParameterKey_jproPassword] ;
                            
                            [user downloadProfileComplection:complection] ;
                            
                        } else {
                            QYDebugLog(@"获取用户jpro服务器信息出错 error = %@",error) ;
                            error = [NSError QYErrorWithCode:LoginStep3_Error description:@"登录第三步出错，get user jpro information出错"] ;
                            complection(false,error) ;
                        }
                    }] ;
                } else {
                    QYDebugLog(@"通过用户名获取UserId出错 error = %@",error) ;
                    error = [NSError QYErrorWithCode:LoginStep2_Error description:@"get userId by username出错"] ;
                    complection(false,error) ;
                }
            }] ;
        } else {
            QYDebugLog(@"登录失败 error = %@",error) ;
            error = [NSError QYErrorWithCode:LoginStep1_Error description:@"登录第一步出错，网络原因。"] ;
            complection(false,error) ;
        }
    }] ;
    
}

/**
 *  下载profile
 */
- (void)downloadProfileComplection:(QYResultBlock)complection {
    assert(complection) ;
    NSString *path = [[QY_FileService getUserPathByUserId:self.userId] stringByAppendingPathComponent:@"profile.xml"] ;
    NSURL *fileUrl = [NSURL fileURLWithPath:path] ;
    
    WEAKSELF
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:[QY_JPROUrlFactor pathForUserProfile:self.userId] saveToFIleURL:fileUrl complection:^(NSURL *filePath, NSError *error) {
        QYDebugLog(@"file path = %@",filePath) ;
        QYDebugLog(@"error = %@",error) ;
        
        if ( !error ) {
            _currentUser = weakSelf ;
            complection(TRUE,nil) ;
        } else {
            NSError *error = [NSError QYErrorWithCode:LoginStep4_Error description:@"登录第四步出错，get user profile.xml出错"] ;
            complection(FALSE,error) ;
        }
    }] ;
}

#pragma mark - 注销

/**
 *  退出登录
 */
+ (void)logOffComplection:(QYResultBlock)complection {
    complection = ^(BOOL result , NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    _currentUser = nil ;
    [[QY_SocketAgent shareInstance] disconnected];
    complection(TRUE,nil) ;
}

#pragma mark - obj 2 xml file

/**
 *  获取profile.xml的文本
 *
 *  @return profile.xml的文本
 */
- (NSString *)getProfileXMLString {
    return [QY_XMLService getUserProfileXML:self] ;
}

/**
 *  获取userId.xml文本
 *
 *  @return userId.xml文本
 */
- (NSString *)getUserIdXMLString {
    return [QY_XMLService getUserIdXML:self] ;
}

#pragma mark - xml file 2 obj

/**
 *  profile.xml 2 instance
 *
 *  @param xmlStr xml文档
 *
 *  @return id<user2ProfileXMLInterface>
 */
+ (id<user2ProfileXMLInterface>)profileXML2Instance:(NSString *)xmlStr {
    return nil ;
}

/**
 *  userId.xml 2 instance
 *
 *  @param xmlStr xml 文档
 *
 *  @return id<user2userIdXMLInterface>
 */
+ (id<user2userIdXMLInterface>)userIDXML2Instance:(NSString *)xmlStr {
    return nil ;
}


#pragma mark - File Associate

/**
 *  每个User都是基于xml文档实例话的，这个必须有。带文件名的 @"application/.../filename.fileExtension"
 */
- (NSString *)xmlFilePath {
    return _xmlFilePath ;
}

- (void)setXmlFilePath:(NSString *)xmlFilePath {
    _xmlFilePath = xmlFilePath ;
}


#pragma mark - private method

- (NSString *)getUserLocalProfilePath {    
    NSString *path = [QY_FileService getUserPathByUserId:self.userId] ;
    return path ;
}

- (NSString *)getRemoteProfilePath {
    NSString *url = [QY_JPROUrlFactor downloadURLWithHost:self.jproIp Port:self.jproPort] ;
    
    return url ;
}

/**
 *  创建temp.xml
 */
- (BOOL)createTempProfile {
    self.xmlFilePath = [[QY_FileService getTempPath] stringByAppendingPathComponent:@"temp.xml"] ;
    
    NSString *profileStr = [self getProfileXMLString] ;
    QYDebugLog(@"profileStr = %@",profileStr) ;
    NSData *data = [profileStr dataUsingEncoding:NSUTF8StringEncoding] ;
    return [QY_FileService saveFileAtPath:self.xmlFilePath Data:data] ;
}

/**
 *  移动和重命名temp.xml --> profile.xml
 */
- (BOOL)removeTempProfile2UserProfilePath {
    NSString *oldPath = self.xmlFilePath ;
    NSString *newPath = [[QY_FileService getUserPathByUserId:self.userId] stringByAppendingString:@"profile.xml"] ;
    BOOL result = [QY_FileService removeFileFrom:oldPath To:newPath] ;
    
    if ( result ) {
        QYDebugLog(@"移动成功") ;
        self.xmlFilePath = newPath ;
    } else {
        QYDebugLog(@"移动失败") ;
        self.xmlFilePath = oldPath ;
    }
    
    return result ;
}

@end