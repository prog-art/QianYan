//
//  testNetworkViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "testNetworkViewController.h"

#import "QY_Socket.h"
#import "QY_JPROHttpService.h"
#import "QYUser.h"


#pragma mark - NSDictionary + testNetwork

#import "QY_QRCode.h"

#define DescKey @"desc"
#define cmdKey  @"cmd"
@interface NSDictionary (testNetwork)

+ (instancetype)dictionaryWithDesc:(NSString *)desc cmd:(NSNumber *)cmd ;

@end

@implementation NSDictionary (testNetwork)

+ (instancetype)dictionaryWithDesc:(NSString *)desc cmd:(NSNumber *)cmd {
    return @{DescKey:desc,
             cmdKey:cmd} ;
}

@end



@interface testNetworkViewController ()<UITableViewDelegate,UITableViewDataSource,QY_SocketServiceDelegate,QY_QRCodeScanerDelegate> {
    NSArray *cmds ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView ;

@property (weak,nonatomic) QY_SocketService *socketService ;

@property (nonatomic) NSString *userId ;

@end

@implementation testNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"str 1 = %@ str2 = %@",@"qycam.com",@"50060") ;
    NSLog(@"Ip:Port = %@:%@",@"qycam.com",@"50060") ;
    
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
//    [NSDictionary dictionaryWithDesc:@"连接JRM服务器" cmd:@211] ;
    
    cmds = @[[NSDictionary dictionaryWithDesc:@"扫一扫" cmd:@(-3)],
             [NSDictionary dictionaryWithDesc:@"测试下载" cmd:@(-1)],
             [NSDictionary dictionaryWithDesc:@"测试上传" cmd:@(-2)],
             [NSDictionary dictionaryWithDesc:@"连接JDAS服务器" cmd:@0],
             [NSDictionary dictionaryWithDesc:@"获取JRM的IP和PORT" cmd:@1],
             [NSDictionary dictionaryWithDesc:@"连接JRM服务器" cmd:@200],
             [NSDictionary dictionaryWithDesc:@"211 设备登录JRM服务器" cmd:@211],
             [NSDictionary dictionaryWithDesc:@"251 用户注册" cmd:@251],
             [NSDictionary dictionaryWithDesc:@"252 用户登录" cmd:@252],
//             [NSDictionary dictionaryWithDesc:@"重设用户密码" cmd:@253],
             [NSDictionary dictionaryWithDesc:@"254 获取用户jpro服务器信息" cmd:@254],
//             [NSDictionary dictionaryWithDesc:@"获取用户jss服务器信息" cmd:@255],
//             [NSDictionary dictionaryWithDesc:@"获取相机jpro服务器信息" cmd:@256],
             [NSDictionary dictionaryWithDesc:@"259 通过用户名获取用户Id" cmd:@259],
             [NSDictionary dictionaryWithDesc:@"2529 绑定测试相机0112" cmd:@2529],
             [NSDictionary dictionaryWithDesc:@"2530 解绑相机" cmd:@2530],
             ] ;
    
    self.socketService = [QY_SocketService shareInstance] ;
    self.socketService.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cmds.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"testNetworkViewCellReuseId" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId] ;
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId] ;
    }
    
    cell.textLabel.text = cmds[indexPath.row][DescKey] ;
    
    return cell ;
}

#pragma mark - UITableViewDelegate 

#define testUsername @"18817870386"
#define testPassword1 @"123456"
#define testPassword2 @"1234567"
#define testUserId @""
#define testCameraId @"t00000000000112"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cmd = [cmds[indexPath.row][cmdKey] integerValue] ;
    
    switch (cmd) {
        case -3 : {
            [QY_QRCodeUtils startWithDelegater:self] ;
            break ;
        }
        case -1 : {
            [QY_JPROHttpService downLoadTest] ;
            break ;
        }
        case -2 : {
            [QY_JPROHttpService uploadTest] ;
            break ;
        }
        case 0 : {
            NSError *error ;
            [self.socketService connectToJDASHost:&error] ;
            break ;
        }
        case 1 : {
            [self.socketService getJRMIPandJRMPORT] ;
            //221.6.13.155 , Port = 50271
            break ;
        }
        case 200 : {
            NSError *error ;
            [self.socketService connectToJRMHost:&error] ;
            break ;
        }
        case 211 : {
            [self.socketService deviceLoginRequest] ;
            break ;
        }
        case 251 : {
            [self.socketService userRegisteRequestWithName:@"793951781" Psd:testPassword1] ;
            break ;
        }
        case 252 : {
            [self.socketService userLoginRequestWithName:testUsername Psd:testPassword1] ;
            break ;
        }
//        case 253 : {
//            [self.socketService resetPasswordForUser:@"userId" password:@"1234567"] ;
//            break ;
//        }
        case 254 : {
            [self.socketService getJPROServerInfoForUser:self.userId] ;
            break ;
        }
        case 259 : {
            [self.socketService getUserIdByUsername:testUsername] ;
            break ;
        }
        case 2529 : {
            [self.socketService bindingCameraToCurrentUser:testCameraId] ;
            break ;
        }
        case 2530 : {
            [self.socketService unbindingCameraToCurrentUser:testCameraId] ;
            break ;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

/**
 *  测试用例1:登录->通过Username获取UserId->通过UserId获取JPRO服务器信息
 */

#pragma mark - QY_SocketServiceDelegate

/**
 *  211 设备登录结果
 *
 *  @param successed
 */
- (void)QY_deviceLoginSuccessed:(BOOL)successed {
    
}

/**
 *  251 用户注册结果
 *
 *  @param successed
 *  @param userId    成功时返回结果有userId
 */
- (void)QY_userRegisteSuccessed:(BOOL)successed userId:(NSString *)userId {
    
}

/**
 *  252 用户登录结果
 *
 *  @param successed
 */
- (void)QY_userLoginSuccessed:(BOOL)successed {
    
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
        QYDebugLog(@"Ip:Port = %@ %@",jproIp,jproPort) ;//Ip:Port = qycam.com 50060
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
        QYDebugLog(@"userId = %@",userId) ;//userId = 10000133
        self.userId = userId ;
    }
}

#pragma mark - 2510 

#pragma mark - 2520

/**
 *  2529 绑定相机
 *
 *  @param successed
 *  @param code      1:参数出错 2:绑定出错 3:已经绑定给其他用户
 */
- (void)QY_bindCameraSuccessed:(BOOL)successed errorCode:(NSInteger)code {
    if ( successed ) {
        QYDebugLog(@"成功绑定！") ;
    } else {
        QYDebugLog(@"绑定出错！error code = %ld",(long)code) ;
    }
}

#pragma mark - 2530 

/**
 *  2530 接绑相机
 *
 *  @param successed
 */
- (void)QY_unbindCameraSuccessed:(BOOL)successed {
    if ( successed ) {
        QYDebugLog(@"成功解绑!") ;
    } else {
        QYDebugLog(@"解绑出错！") ;
    }
}

#pragma mark - 2540 

#pragma mark - QY_QRCodeScanerDelegate

/**
 *  成功扫描二维码，普通字符串
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr {
    QYDebugLog(@"扫描普通字符串 %@",resultStr) ;
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan {
    QYDebugLog(@"取消扫描") ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

/**
 *  扫描到了某种千衍的二维码结构
 *
 *  @param opetion 扫描到的类型
 *  @param info    各种参数
 */
- (void)QY_didScanOption:(QY_QRCodeType)option userInfo:(NSDictionary *)info {
    QYDebugLog(@"扫描千衍二维码！option = %ld info = %@",option,info) ;
    [self.navigationController popViewControllerAnimated:YES] ;
    if ( option == QY_QRCodeType_Binding_Camera ) {
        QYDebugLog(@"绑定摄像机！") ;
        
        if ( self.userId ) {
            [self.socketService bindingCameraToCurrentUser:self.userId] ;
        } else {
            QYDebugLog(@"user为空") ;            
        }
        
    } else
    if (option == QY_QRCodeType_User )  {
        QYDebugLog(@"添加好友！") ;
        QYUser *user = [QYUser currentUser] ;
        NSString *friendId = info[QY_QRCODE_DATA_DIC_KEY][KEY_FOR_DATA_AT_INDEX(1)] ;
        
        if ( user ) {
            [self.socketService createAddRequestToUser:friendId] ;
        } else {
            QYDebugLog(@"user为空") ;
        }
        
    }
}

@end