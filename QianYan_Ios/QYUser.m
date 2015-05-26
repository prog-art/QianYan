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
#import "QY_JPROHttpService.h"

static QYUser *_currentUser = nil ;

@interface QYUser ()<QY_SocketServiceDelegate> {
    NSString *_xmlFilePath ;
}

@property (weak,nonatomic) QY_SocketService *socketService ;

@property (nonatomic,assign) QYUserBlock registeComplection ;

@property (nonatomic,assign) QYResultBlock loginComplection ;

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
    self.socketService = [QY_SocketService shareInstance] ;
    
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

+ (void)registeName:(NSString *)username Password:(NSString *)password complection:(QYUserBlock)complection {
    QYUser *user = [QYUser userWithName:username Password:password ] ;
    user.registeComplection = complection ;
    
    user.socketService.delegate = user ;
    [user.socketService userRegisteRequestWithName:username Psd:password] ;
}

+ (void)loginName:(NSString *)username Password:(NSString *)password complection:(QYResultBlock)complection {
    QYUser *user = [QYUser userWithName:username Password:password] ;
    user.loginComplection = complection ;
    
    user.socketService.delegate = user ;
    [user.socketService userLoginRequestWithName:username Psd:password] ;
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

#pragma mark - QY_SocketServiceDelegate

/**
 *  251 用户注册结果
 *
 *  @param successed
 *  @param userId    成功时返回结果有userId
 */
- (void)QY_userRegisteSuccessed:(BOOL)successed userId:(NSString *)userId {
    if ( successed ) {
        QYDebugLog(@"注册成功 userId = %@,接下来去获取jpro",userId) ;
        self.userId = userId ;
        
        self.socketService.delegate = self ;
        [self.socketService getJPROServerInfoForUser:self.userId] ;
    } else {
        QYDebugLog(@"注册失败") ;
        
        NSError *error = [NSError QYErrorWithCode:RegisteStep1_Error description:@"网络原因请检查。"] ;
        if ( self.registeComplection ) {
            self.registeComplection(nil,error) ;
        }
    }
}

/**
 *  252 用户登录结果
 *
 *  @param successed
 */
- (void)QY_userLoginSuccessed:(BOOL)successed {
    if ( successed ) {
        QYDebugLog(@"登录成功 接下来去获取userId") ;
        self.socketService.delegate = self ;
        [self.socketService getUserIdByUsername:self.username] ;
    } else {
        QYDebugLog(@"登录失败") ;
        if ( self.loginComplection ) {
            self.loginComplection(FALSE,nil) ;
        }
    }
}


/**
 *  254 获取JPRO服务器信息结果
 *
 *  @param successed
 *  @param jproIp       jpro的ip地址或域名，如"qycam.com"
 *  @param jproPort     jpro的端口号 如"50551"
 *  @param jproPassword jpro的访问密码(暂无)
 */
- (void)QY_getJPROServerInfoForUserSuccessed:(BOOL)successed Ip:(NSString *)jproIp Port:(NSString *)jproPort Password:(NSString *)jproPassword {
    if ( successed ) {
        //注册第二部成功
        self.jproIp = jproIp ;
        self.jproPort = jproPort ;
        self.jproPsd = jproPassword ;
        
#warning 这里得做分流，注册和登录都要这个。
        //create 文件
        if ( [self createTempProfile] ) {
            QYDebugLog(@"创建成功temp.xml，等待上传服务器") ;
            
            //upload
        } else {
            QYDebugLog(@"创建临时文件失败") ;
            NSError *error = [NSError QYErrorWithCode:RegisteStep3_Error description:@"注册第三部，创建temp.xml时出错"] ;
            if ( self.registeComplection ) {
                self.registeComplection(nil,error) ;
            }
        }
        
        
    } else {
        NSError *error = [NSError QYErrorWithCode:RegisteStep2_Error description:@"注册第二步出错，获取JPRO服务器信息出错。"];
        if ( self.registeComplection ) {
            self.registeComplection(nil,error) ;
        }
        
    }
}

/**
 *  259 通过用户名获取用户Id
 *
 *  @param successed
 *  @param userId    成功时返回结果有userId
 */
- (void)QY_getUserIdByUsernameSuccessed:(BOOL)successed UserId:(NSString *)userId {
    if ( successed ) {
        self.userId = userId ;
        //获取jpro去
    } else {
        
    }
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

/**
 *  创建temp.xml,等待上传
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