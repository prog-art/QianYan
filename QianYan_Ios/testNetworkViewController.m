//
//  testNetworkViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "testNetworkViewController.h"

#import "QY_JMS.h"
#import "QY_Socket.h"
#import "QY_JPRO.h"
#import "QYUser.h"

#import "QY_Common.h"
#import "QY_contactService.h"

#import "QY_FileService.h"

#import <UIImageView+AFNetworking.h>

#import "QY_appDataCenter.h"

#pragma mark - NSDictionary + testNetwork

#import "QY_QRCode.h"

#import "SVProgressHUD.h"

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

#pragma mark - Core Data test 

#import "AppDelegate.h"

#pragma mark -

@interface testNetworkViewController ()<UITableViewDelegate,UITableViewDataSource,QY_QRCodeScanerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    dispatch_semaphore_t _sema ;
    NSArray *cmds ;
    NSArray *cmdTitles ;
    
    NSArray *coreDataCmds ;
    NSArray *appCmds ;
    NSArray *jmsCmds ;
    NSArray *jrmCmds ;
    NSArray *jproCmds ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView ;

@property (weak,nonatomic) QY_SocketAgent *socketAgent_v2 ;

@property (nonatomic) NSString *userId ;

@end

@implementation testNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    coreDataCmds = @[[NSDictionary dictionaryWithDesc:@"[ok]-400 查询所有User" cmd:@(-400)],
                     [NSDictionary dictionaryWithDesc:@"[ok]-410 查询所有Camera" cmd:@(-410)],
                     [NSDictionary dictionaryWithDesc:@"[ok]-411 删除所有Camera" cmd:@(-411)],
                     [NSDictionary dictionaryWithDesc:@"[ok]-412 查询有所feed" cmd:@(-412)],
                     [NSDictionary dictionaryWithDesc:@"-413 查询能看见的feed" cmd:@(-413)]] ;
    
    appCmds = @[[NSDictionary dictionaryWithDesc:@"[ok]-1 user登录 to main" cmd:@(-1)],
                [NSDictionary dictionaryWithDesc:@"[ok]1 user登录 not to main" cmd:@1],
                [NSDictionary dictionaryWithDesc:@"-12 user登录错误密码" cmd:@(-12)],
                [NSDictionary dictionaryWithDesc:@"[ok]-2 user注册" cmd:@(-2)],
                [NSDictionary dictionaryWithDesc:@"[ok]-3 扫一扫" cmd:@(-3)],
                [NSDictionary dictionaryWithDesc:@"[ok]-4 user注册上传profile.xml" cmd:@(-4)],
                [NSDictionary dictionaryWithDesc:@"-5 通过UserId或Tel搜索用户" cmd:@(-5)],
                [NSDictionary dictionaryWithDesc:@"[ok]-302 绑定摄像机" cmd:@(-302)],
                [NSDictionary dictionaryWithDesc:@"-303 分享相机" cmd:@(-303)],
                [NSDictionary dictionaryWithDesc:@"-304 取消分享相机" cmd:@(-304)],
                [NSDictionary dictionaryWithDesc:@"-305 解绑相机" cmd:@(-305)],
                [NSDictionary dictionaryWithDesc:@"[ok]-306 添加好友" cmd:@(-306)],
                [NSDictionary dictionaryWithDesc:@"-307 不想让他看我的朋友圈状态" cmd:@(-307)],
                [NSDictionary dictionaryWithDesc:@"-308 不想看他的朋友圈状态" cmd:@(-308)],
                [NSDictionary dictionaryWithDesc:@"-309 删除好友" cmd:@(-309)],
                [NSDictionary dictionaryWithDesc:@"-310 修复profile.xml" cmd:@(-310)]] ;
    
    jmsCmds = @[[NSDictionary dictionaryWithDesc:@"[ok]-201 获取单个摄像机的状态" cmd:@(-201)],
                [NSDictionary dictionaryWithDesc:@"[ok]-202 获取多个摄像机的状态" cmd:@(-202)],
                [NSDictionary dictionaryWithDesc:@"-203 获取摄像机的缩略图" cmd:@(-203)],
                [NSDictionary dictionaryWithDesc:@"-204 发送心跳包" cmd:@(-204)]] ;
    
    jproCmds = @[[NSDictionary dictionaryWithDesc:@"[ok]-90 测试下载文件到内存" cmd:@(-90)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-91 测试下载图片到内存" cmd:@(-91)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-100 登录JPRO拿登录Cookie" cmd:@(-100)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-99 注销登录，清除Cookie" cmd:@(-99)],
                 [NSDictionary dictionaryWithDesc:@"-101 获取msg列表" cmd:@(-101)],
                 [NSDictionary dictionaryWithDesc:@"-102 删除msg列表" cmd:@(-102)],
                 [NSDictionary dictionaryWithDesc:@"-103 获取某个msg" cmd:@(-103)],
                 [NSDictionary dictionaryWithDesc:@"-104 删除某个msg" cmd:@(-104)],
                 [NSDictionary dictionaryWithDesc:@"-105 获取某相机的报警消息用户分享列表" cmd:@(-105)],
                 [NSDictionary dictionaryWithDesc:@"-106 增加某相机的报警消息对用户的分享" cmd:@(-106)],
                 [NSDictionary dictionaryWithDesc:@"-107 删除某相机的抱紧信息对用户的分享" cmd:@(-107)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-108 上传图片" cmd:@(-108)],//60服务器id=13,300服务器 id=3
                 [NSDictionary dictionaryWithDesc:@"[暂时不测]-109 添加在别处上传的图片或视频" cmd:@(-109)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-110 发表状态" cmd:@(-110)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-111 获取状态列表" cmd:@(-111)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-112 获取某个状态" cmd:@(-112)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-113 删除某个状态" cmd:@(-113)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-114 发表评论" cmd:@(-114)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-115 删除评论" cmd:@(-115)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-116 点赞" cmd:@(-116)],//
                 [NSDictionary dictionaryWithDesc:@"[ok]-117 取消点赞" cmd:@(-117)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-119[2] 下载文件" cmd:@(-1192)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-119[3] 下载图片" cmd:@(-1193)],
                 [NSDictionary dictionaryWithDesc:@"[ok]-8 上传profile.xml" cmd:@(-8)],
                 [NSDictionary dictionaryWithDesc:@"-10 ftp下载视频" cmd:@(-10)]] ;

    jrmCmds = @[[NSDictionary dictionaryWithDesc:@"[ok] 212 获取jms服务器信息" cmd:@212],
                [NSDictionary dictionaryWithDesc:@"[ok] 251 用户注册" cmd:@251],
                [NSDictionary dictionaryWithDesc:@"[ok] 252 用户登录" cmd:@252],
                [NSDictionary dictionaryWithDesc:@"10252 测试用户错误密码" cmd:@10252],
                [NSDictionary dictionaryWithDesc:@"[ok] 253 重设用户密码" cmd:@253],
                [NSDictionary dictionaryWithDesc:@"[ok] 254 获取用户jpro服务器信息" cmd:@254],
                [NSDictionary dictionaryWithDesc:@"[ok] 255 获取用户jss服务器信息" cmd:@255],
                [NSDictionary dictionaryWithDesc:@"[ok] 256 获取相机jpro服务器信息" cmd:@256],
                [NSDictionary dictionaryWithDesc:@"[ok] 257 获取相机jss服务器信息" cmd:@257],
                [NSDictionary dictionaryWithDesc:@"[2512设置后查询不到] 258 检查用户名是否与手机号绑定" cmd:@258],
                [NSDictionary dictionaryWithDesc:@"[ok] 259 通过用户名获取用户Id" cmd:@259],
                [NSDictionary dictionaryWithDesc:@"[ok] 2510 通过手机号获取用户Id" cmd:@2510],
                [NSDictionary dictionaryWithDesc:@"[ok] 2510+ 确认联系人列表" cmd:@25101],
                [NSDictionary dictionaryWithDesc:@"2511 通过邮箱获取用户Id" cmd:@2511],
                [NSDictionary dictionaryWithDesc:@"[ok] 2512 设置用户手机号" cmd:@2512],
                [NSDictionary dictionaryWithDesc:@"[ok] 2513 获取用户手机号" cmd:@2513],
                [NSDictionary dictionaryWithDesc:@"[ok] 2514 验证用户手机号" cmd:@2514],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2515 设置用户昵称" cmd:@2515],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2516 获取用户昵称" cmd:@2516],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2517 设置用户所在地" cmd:@2517],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2518 获取用户所在地" cmd:@2518],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2519 设置用户个性签名" cmd:@2519],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2520 获取用户个性签名" cmd:@2520],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2521 设置用户头像" cmd:@2521],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2522 获取用户头像" cmd:@2522],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2523 获取用户好友列表" cmd:@2523],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2524 添加好友" cmd:@2524],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2525 删除好友" cmd:@2525],
                //#warning testing 相机分享
//                [NSDictionary dictionaryWithDesc:@"2526 分享相机给好友" cmd:@2526],
//                [NSDictionary dictionaryWithDesc:@"2527 取消相机对好友的分享" cmd:@2527],
//                [NSDictionary dictionaryWithDesc:@"[实际返回和文档不符] 2528 获取相机列表" cmd:@2528],
                
                [NSDictionary dictionaryWithDesc:@"[一直已绑定给用户] 2529 绑定测试相机0112" cmd:@2529],
                [NSDictionary dictionaryWithDesc:@"[解绑成功，然并卵] 2530 解绑相机" cmd:@2530],
                
//                [NSDictionary dictionaryWithDesc:@"[查询不到] 2531 获取相机的分享列表" cmd:@2531],
//                [NSDictionary dictionaryWithDesc:@"[ok] 2532 获取相机信息" cmd:@2532],
//                [NSDictionary dictionaryWithDesc:@"[设置成功，但2532查不到] 2533 设置相机昵称" cmd:@2533],
                
//                [NSDictionary dictionaryWithDesc:@"[绑定成功过，但是被绑于001User] 2534 获取相机拥有者Id" cmd:@2534],
//                [NSDictionary dictionaryWithDesc:@"[失效] 2535 获取用户名By userId" cmd:@2535],
#warning testing 36 - 42 暂时不测
                
                ] ;

    cmds = @[coreDataCmds,
             appCmds,
             jmsCmds,
             jproCmds,
             jrmCmds] ;
    cmdTitles = @[@"core data 命令测试",
                  @"app流程 命令测试",
                  @"jms 命令测试",
                  @"jpro 命令测试",
                  @"jrm 命令测试"] ;
    
    self.socketAgent_v2 = [QY_SocketAgent shareInstance] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [cmds count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cmds[section] count] ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return cmdTitles[section] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"testNetworkViewCellReuseId" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId] ;
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId] ;
    }
    
    cell.textLabel.text = cmds[indexPath.section][indexPath.row][DescKey] ;
    
    return cell ;
}

#pragma mark - UITableViewDelegate 

#define testUsername @"18817870386"
#define testTelephone @"18817870386"
#define testEmail @"793951781@qq.com"
#define testPassword1 @"123456"
#define testPassword2 @"1234567"
//#define testPassword2 @"123456"

#define testUserId @"10000133"
//#define testUserId @"10000125"

#define testCameraId @"t00000000000112"
#define testCameraId2 @"c00000000000247"
#define testCameraId3 @"t00000000000052"
#define testNickname @"虎猫儿"
#define testLocation @"中国上海"
#define testSign @"虎猫儿(・Д・)ノ"

#define testFeedId @"12"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cmd = [cmds[indexPath.section][indexPath.row][cmdKey] integerValue] ;
    switch (cmd) {
        case -400 : {
            NSArray *users = [QY_appDataCenter findObjectsWithClassName:NSStringFromClass([QY_user class]) predicate:nil] ;
            
            QY_user *user = users[0] ;
            
            QYDebugLog(@"userId = %@",user.userId) ;
            
            QYDebugLog(@"Users = %@",users) ;
            
            break ;
        }
            
        case -410 : {
            NSArray *cameras = [QY_appDataCenter findObjectsWithClassName:NSStringFromClass([QY_camera class]) predicate:nil] ;            
            QYDebugLog(@"Cameras = %@",cameras) ;
            break ;
        }
            
        case -411 : {
            BOOL result = [QY_appDataCenter deleteObjectsWithClassName:NSStringFromClass([QY_camera class]) predicate:nil] ;
            
            QYDebugLog(@"%@",result?@"删除成功":@"删除失败") ;
            
            break ;
        }
            
        case -412 : {
            NSArray *feeds = [QY_appDataCenter findObjectsWithClassName:NSStringFromClass([QY_feed class]) predicate:nil] ;
            
            [feeds enumerateObjectsUsingBlock:^(QY_feed *feed, NSUInteger idx, BOOL *stop) {
                QYDebugLog(@"feedId = %@,feed = %@",feed.feedId,feed) ;                
            }] ;
            
            break ;
        }
            
        case -413 : {
            NSArray *feeds = [[QY_user insertUserById:@"10000133"] visualableFeedItems] ;
            
            [feeds enumerateObjectsUsingBlock:^(QY_feed *feed, NSUInteger idx, BOOL *stop) {
                QYDebugLog(@"feedId = %@,feed = %@",feed.feedId,feed) ;
            }] ;
            
            break ;
        }
            
        case -302 : {
            //扫描机身二维码－生成wifi二维码－
//            [self bindingCameraWithCameraId:testCameraId2] ;
            break ;
        }
            
        case -303 : {
            break ;
        }
            
        case -304 : {
            break ;
        }
            
        case -305 : {
            break ;
        }
            
        case -306 : {
//            [self addFriendWithFriendId:@"10000122"] ;
            break ;
        }
            
        case -307 : {
            break ;
        }
            
        case -308 : {
            break ;
        }
            
        case -309 : {
            break ;
        }
            
        case -310 : {
            QY_user *user = [QY_user insertUserById:@"10000133"] ;
            
            user.userName = testUsername ;
            [user saveUserInfoComplection:^(id object, NSError *error) {
                if ( object && !error ) {
                    [QY_appDataCenter saveObject:nil error:NULL] ;
                } else {
                    [QYUtils alertError:error] ;
                }
            }] ;            
        }
            
        case -201 : {
//            [[QY_JMSService shareInstance] getCameraStateById:testCameraId] ;
            //<74303030 30303030 30303030 31313200 0000177a 00000000 00000006 00040000 053c>
            break ;
        }
            
        case -202 : {
//            [[QY_JMSService shareInstance] getCamerasStateByIds:[NSSet setWithArray:@[testCameraId,testCameraId2,testCameraId3]]] ;
            //<74303030 30303030 30303030 31313200 0000177d 00000000 0000000f 74303030 30303030 30303030 313132>
            break ;
        }
            
        case -203 : {
//            [[QY_JMSService shareInstance] getCameraThumbnailById:testCameraId2] ;
            break ;
        }
            
        case -204 : {
            [[QY_JMSService shareInstance] startSendHeartBeatMessage] ;
            break ;
        }
            
            
        case -90 : {
            [[QY_JPROHttpService shareInstance] testDownload] ;
            break ;
        }
        
        case -91 : {
            [[QY_JPROHttpService shareInstance] testDownload2] ;
            break ;
        }
            
        case -100 : {
            [[QY_JPROHttpService shareInstance] jproLoginWithUserId:@"10000133" Password:@"1234567" Complection:nil] ;
            break ;
        }
            
        case -99 : {
            [[QY_JPROHttpService shareInstance] jproLogoutComplection:nil] ;
            break ;
        }
            
        case -101 : {
            [[QY_JPROHttpService shareInstance] getAlertMessageListPage:1
                                                             NumPerPage:10
                                                                   Type:140
                                                                 UserId:testUserId
                                                               cameraId:testCameraId3
                                                                StartId:nil
                                                                  EndId:nil
                                                                  Check:nil
                                                            Complection:nil] ;
            break ;
        }
        
        case -102 : {
//            [[QY_JPROHttpService shareInstance] deleteAlertMessages:nil Complection:nil] ;
            break ;
        }
        
        case -103 : {
//            [[QY_JPROHttpService shareInstance] getMsgById:nil Complection:nil] ;
            break ;
        }
            
        case -104 : {
//            [[QY_JPROHttpService shareInstance] deleteMsgById:nil Complection:nil] ;
            break ;
        }
        
        case -105 : {
            [[QY_JPROHttpService shareInstance] getCameraShareList:testCameraId Complection:nil] ;
            break ;
        }
            
        case -106 : {
//            [[QY_JPROHttpService shareInstance] shareCamera:testCameraId toUsers:nil Complection:nil] ;
            break ;
        }
            
        case -107 : {
            break ;
        }
            
        case -108 : {
            UIImage *image = [UIImage imageNamed:@"2.jpg"] ;
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f) ;
            [[QY_JPROHttpService shareInstance] uploadImageAttach:imageData Complection:nil] ;
            break ;
        }
        
        case -110 : {
            [[QY_JPROHttpService shareInstance] createAttachFeedWithContent:@"233 hello world"
                                                                   Attaches:nil
                                                                   Messages:nil
                                                                Complection:nil] ;
            break ;
        }
            
        case -111 : {
            [[QY_JPROHttpService shareInstance] getFeedListWithPage:1
                                                         NumPerPage:10
                                                             UserId:nil
                                                            StartId:nil
                                                              EndId:nil
                                                              Check:nil
                                                        Complection:nil] ;
            break ;
        }
            
        case -112 : {
            [[QY_JPROHttpService shareInstance] getFeedById:testFeedId Complection:nil] ;
            break ;
        }
            
        case -113 : {
//            [[QY_JPROHttpService shareInstance] deleteFeedById:@"6" Complection:nil] ;
            break ;
        }
            
        case -114 : {
            [[QY_JPROHttpService shareInstance] addCommentToFeed:testFeedId Comment:@"testComment!" Complection:nil] ;
            break ;
        }
            
        case -115 : {
            [[QY_JPROHttpService shareInstance] deleteCommentById:@"2" Complection:nil] ;
            break ;
        }
            
        case -116 : {
            [[QY_JPROHttpService shareInstance] diggForFeed:testFeedId Complection:nil] ;
            break ;
        }
            
        case -117 : {
            [[QY_JPROHttpService shareInstance] cancelDiggForFeed:testFeedId Complection:nil] ;
            break ;
        }
            
        case -1192 : {
            [[QY_JPROHttpService shareInstance] downloadFileFromPath:@"user/10000133/profile.xml" complection:^(NSString *fileContent, NSError *error) {
                if ( fileContent ) {
                    QYDebugLog(@"file content = %@",fileContent) ;
                } else {
                    QYDebugLog(@"error = %@",error) ;
                }
            }] ;
            break ;
        }
            
        case -1193 : {
            WEAKSELF
            [[QY_JPROHttpService shareInstance] downloadImageFromPath:@"user/10000133/headpicture.jpg" complection:^(UIImage *image, NSError *error) {
                if ( image ) {
                    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)] ;
                    [weakSelf.view addSubview:avatarView] ;
                    [weakSelf.view bringSubviewToFront:avatarView] ;
                    [avatarView setImage:image] ;
                } else {
                    QYDebugLog(@"error = %@",error) ;
                }
                
            }] ;
            break ;
        }
            
        case -8 : {
            [[QY_JPROHttpService shareInstance] testUpload] ;            
            break ;
        }
            
        case -10 : {
            [[QY_JPROFTPService shareInstance] testDownload:nil] ;
            break ;
        }
            
        case -3 : {
            [QY_QRCodeUtils startQRScanWithNavigationController:self.navigationController Delegate:self] ;
            break ;
        }
            
        case 1 : {
            //登录 not to main
            [QYUser loginName:testUsername Password:testPassword2 complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"登陆成功") ;
                } else {
                    QYDebugLog(@"登陆失败 error = %@",error) ;
                    [QYUtils alertError:error] ;
                }
            }] ;
            break ;
        }
            
        case -1 : {
            //登录 to main
            [QYUser loginName:testUsername Password:testPassword2 complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"登陆成功") ;
                    [QYUtils toMain] ;
                } else {
                    QYDebugLog(@"登陆失败 error = %@",error) ;
                    [QYUtils alertError:error] ;
                }
            }] ;
            
//            [QYUser loginName:@"7939517817" Password:testPassword1 complection:^(BOOL success, NSError *error) {
//                if ( success ) {
//                    QYDebugLog(@"登录成功") ;
//                } else {
//                    QYDebugLog(@"登录失败 error = %@",error) ;
//                }
//            }] ;
            break ;
        }
        
        case -12 : {
            [QYUser loginName:testUsername Password:testPassword1 complection:nil] ;
            break ;
        }
            
        case -2 : {
#warning 重写
            break ;
        }
            
        case -4 : {
#warning 重写
            break ;
        }
            
        case -5 : {
            //259 通过用户名获取UserId
            //2510 通过手机号获取UserId
            QYDebugLog(@"美鞋") ;
            
            break ;
        }
    
        case 211 : {
            [[QY_SocketAgent shareInstance] deviceLoginRequestComplection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"设别登录成功") ;
                } else {
                    QYDebugLog(@"error = %@",error) ;
                }
            }] ;
            
//            [self.socketService deviceLoginRequest] ;
            break ;
        }
        case 212 : {
            [self.socketAgent_v2 getJMSServerInfoComplection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取jms服务器信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取jms服务器信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 251 : {
            
            [self.socketAgent_v2 userRegisteRequestWithName:@"793951780" Psd:testPassword1 Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"注册成功 userId = %@",info) ;
                } else {
                    QYDebugLog(@"注册失败 error = %@",error) ;
                }
            }] ;
            
            break ;
        }
        case 252 : {
//            [self.socketAgent_v2 userLoginRequestWithName:@"7939517817" Psd:testPassword1 Complection:^(BOOL success, NSError *error) {
            [self.socketAgent_v2 userLoginRequestWithName:testUsername Psd:testPassword2 Complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"登录成功") ;
                } else {
                    QYDebugLog(@"登录失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 10252 : {
//            [self.socketAgent_v2 userLoginRequestWithName:@"7939517817" Psd:testPassword1 Complection:^(BOOL success, NSError *error) {
            [self.socketAgent_v2 userLoginRequestWithName:testUsername Psd:testPassword1 Complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"登录成功") ;
                } else {
                    QYDebugLog(@"登录失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 253 : {
            [self.socketAgent_v2 resetPasswordForUser:testUserId password:testPassword2 Complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"修改密码成功") ;
                } else {
                    QYDebugLog(@"修改密码失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 254 : {
            [self.socketAgent_v2 getJPROServerInfoForUser:testUserId Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取用户jpro信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取用户jpro信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 255 : {
            [self.socketAgent_v2 getUserJSSInfoByUserId:testUserId Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取用户jss信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取用户jss信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 256 : {
            [self.socketAgent_v2 getCameraJRPOInfoByCameraId:testCameraId Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取相机jpro信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取相机jpro信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 257 : {
            [self.socketAgent_v2 getCameraJSSInfoByCameraId:testCameraId Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取相机jss信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取相机jss信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 258 : {
            [self.socketAgent_v2 checkUsernameBindingTelephone:testUsername Telephone:testTelephone Complection:^(NSDictionary *info, NSError *error) {
                if ( info ) {
                    QYDebugLog(@"查询绑定信息成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"查询绑定信息失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 259 : {
            [self.socketAgent_v2 getUserIdByUsername:testUsername Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取成功 userId = %@",info) ;
                } else {
                    QYDebugLog(@"获取失败 error = %@",error) ;
                }
            }] ;
            
            break ;
        }
        case 2510 : {
            [self.socketAgent_v2 getUserIdByTelephone:testTelephone Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取成功 userId = %@",info) ;
                } else {
                    QYDebugLog(@"获取失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 25101 : {
            [self testContacts] ;
            break ;
        }
        case 2511 : {
            [self.socketAgent_v2 getUserIdByEmail:testEmail Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"获取成功 info = %@",info) ;
                } else {
                    QYDebugLog(@"获取失败 error = %@",error) ;
                }
            }] ;
            break ;
        }
        case 2512 : {
            [self.socketAgent_v2 bindingTelephoneForUser:testUserId Telephone:testTelephone Complection:nil] ;
            break ;
        }
        case 2513 : {
            [self.socketAgent_v2 getTelephoneByUserId:testUserId Complection:nil] ;
            break ;
        }
        case 2514 : {
            [self.socketAgent_v2 verifyTelephoneForUser:testUserId Telephone:testTelephone VerifyCode:@"233233" Complection:nil] ;
            break ;
        }
//        case 2515 : {
//            [self.socketAgent_v2 setNicknameForUser:@"10000138" Nickname:@"虎猫儿" Complection:nil] ;
//            break ;
//        }
//        case 2516 : {
//            [self.socketAgent_v2 getNicknameByUserId:@"10000138" Complection:nil] ;
//            break ;
//        }
//        case 2517 : {
//            [self.socketAgent_v2 setUserLocationForUser:testUserId Location:@"中国上海" Complection:nil] ;
//            break ;
//        }
//        case 2518 : {
//            [self.socketAgent_v2 getUserLocationByUserId:testUserId Complection:nil] ;
//            break ;
//        }
//        case 2519 : {
//            [self.socketAgent_v2 setUserSignForUser:testUserId Sign:@"test sign" Complection:nil] ;
//            break ;
//        }
//        case 2520 : {
//            [self.socketAgent_v2 getUserSignByUserId:testUserId Complection:nil] ;
//            break ;
//        }
//        case 2521 : {
//            
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:imagePicker animated:YES completion:nil];
//            
//            break ;
//        }
//        case 2522 : {
//            
//            UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)] ;
//            [self.view addSubview:avatarView] ;
//            [self.view bringSubviewToFront:avatarView] ;
//            
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qycam.com:50300/archives/user/10000133/headpicture.jpg"]] ;
//            [avatarView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"2"]] ;

//            [self.socketAgent_v2 getUserAvatarForUser:testUserId Complection:^(NSData *imageData, NSError *error) {
//                BOOL successed = !error ;
//                if ( successed ) {
//                    QYDebugLog(@"获取用户头像成功") ;
//                    UIImage *image = [UIImage imageWithData:imageData] ;
//                    
//                    __block UIImageView *avatarView = [[UIImageView alloc] initWithImage:image] ;
//                    
//                    [avatarView setFrame:CGRectMake(100, 100, 50, 50)] ;
//                    
//                    [self.view addSubview:avatarView] ;
////                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 20 ) ;
////                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
////                        QYDebugLog(@"dismiss") ;
////                        [avatarView removeFromSuperview] ;
////                    }) ;
//                    
//                } else {
//                    QYDebugLog(@"获取用户头像失败 error = %@",error) ;
//                }
//                
//            }] ;
//            
//            break ;
//        }
//        case 2523 : {
//            [self.socketAgent_v2 getUserFriendListForUser:testUserId Complection:^(NSArray *objects, NSError *error) {
//                if ( !error ) {
//                    QYDebugLog(@"获取朋友列表成功") ;
//                } else {
//                    QYDebugLog(@"获取朋友列表失败 error = %@",error) ;
//                }
//            }] ;
//            break ;
//        }
//        case 2524 : {
//            [self.socketAgent_v2 createAddRequestToUser:@"10000138" Complection:^(BOOL success, NSError *error) {
//                if ( success ) {
//                    QYDebugLog(@"添加好友成功") ;
//                } else {
//                    QYDebugLog(@"添加好友失败 error = %@",error) ;
//                }
//            }] ;
//            
//            break ;
//        }
//        case 2525 : {
//            [self.socketAgent_v2 deleteFriend:@"10000138" Complection:^(BOOL success, NSError *error) {
//                if ( success ) {
//                    QYDebugLog(@"删除好友成功") ;
//                } else {
//                    QYDebugLog(@"删除好友失败 error = %@",error) ;
//                }
//            }] ;
//            break ;
//        }
//        case 2528 : {
//            [self.socketAgent_v2 getCameraListForUser:testUserId Complection:nil] ;
//            break ;
//        }
        case 2529 : {
            break ;
        }
        case 2530 : {
            break ;
        }
//        case 2531 : {
//            [self.socketAgent_v2 getCameraSharingListForOwner:testUserId camera:testCameraId Complection:nil] ;
//            break ;
//        }
//        case 2532 : {
//            [self.socketAgent_v2 getCameraInformationForCameraId:testCameraId Complection:nil] ;
//            break ;
//        }
//        case 2533 : {
//            [self.socketAgent_v2 setNicknameForCamera:testCameraId Nickname:@"test233" Complection:nil] ;
//            break ;
//        }
//        case 2534 : {
//            [self.socketAgent_v2 getCameraOwnerIdForCamera:testCameraId2 Complection:nil] ;
//            break ;
//        }
//        case 2535 : {
//            [self.socketAgent_v2 getUsernameByUserId:testUserId Complection:nil] ;
//            break ;
//        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

#pragma mark - 

- (void)testContacts {
    QY_contactUtils *contactUtils = [[QY_contactUtils alloc] init] ;
    [contactUtils getContactsComplection:^(BOOL success, NSArray *contacts) {
        if ( success ) {
            QYDebugLog(@"获取联系人成功") ;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _sema = dispatch_semaphore_create(0) ;
                
                for ( QY_Contact *contact in contacts ) {
                    QYDebugLog(@"contact = %@",contact) ;
                    
                    [self.socketAgent_v2 getUserIdByTelephone:contact.tel Complection:^(NSDictionary *info, NSError *error) {
                        dispatch_semaphore_signal(_sema) ;
                        if ( !error ) {
                            QYDebugLog(@"info = %@",info) ;
                        }
                    }] ;
                    
                    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER) ;
                }
                QYDebugLog(@"完成了所有～") ;
                _sema = NULL ;
            }) ;
            
        } else {
            QYDebugLog(@"获取联系人失败") ;
        }
    }] ;
}

- (void)testUploadAvatar:(UIImage *)image {
    [[QY_JPROHttpService shareInstance] setUserAvatarForUser:testUserId image:image Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"上传头像成功") ;
        } else {
            QYDebugLog(@"上传头像失败 error = %@",error) ;
        }
    }] ;
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    QYDebugLog(@"选中") ;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage] ;
        
        UIImage *image = [UIImage QY_thumbnailWithImageWithoutScale:img size:CGSizeMake(50, 50)] ;
        
        [self performSelector:@selector(testUploadAvatar:) withObject:image afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    QYDebugLog(@"取消") ;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end