//
//  testNetworkViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "testNetworkViewController.h"

#import "QY_JPRO.h"
#import "QYUser.h"

#import "QY_Common.h"
#import "QY_contactService.h"

#import "QY_FileService.h"

#import "QY_Socket.h"

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

#pragma mark - Core Data test 

#import "AppDelegate.h"

#pragma mark -

@interface testNetworkViewController ()<UITableViewDelegate,UITableViewDataSource,QY_QRCodeScanerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    dispatch_semaphore_t _sema ;
    NSArray *cmds ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView ;

@property (weak,nonatomic) QY_SocketAgent *socketAgent_v2 ;

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
    
    cmds = @[[NSDictionary dictionaryWithDesc:@"测试 core data" cmd:@(-7)],
//             [NSDictionary dictionaryWithDesc:@"一键设备登录JRM" cmd:@(-6)],
//             [NSDictionary dictionaryWithDesc:@"一键获取JRM IP和PORT" cmd:@(-5)],
//             [NSDictionary dictionaryWithDesc:@"一键登录" cmd:@(-4)],
//             [NSDictionary dictionaryWithDesc:@"扫一扫" cmd:@(-3)],
             [NSDictionary dictionaryWithDesc:@"-1. user 登录" cmd:@(-1)],
             [NSDictionary dictionaryWithDesc:@"-2. user 注册" cmd:@(-2)],
             [NSDictionary dictionaryWithDesc:@"212 获取jms服务器信息" cmd:@212],
             [NSDictionary dictionaryWithDesc:@"251 用户注册" cmd:@251],
             [NSDictionary dictionaryWithDesc:@"252 用户登录" cmd:@252],
             [NSDictionary dictionaryWithDesc:@"253 重设用户密码" cmd:@253],
             [NSDictionary dictionaryWithDesc:@"254 获取用户jpro服务器信息" cmd:@254],
             [NSDictionary dictionaryWithDesc:@"255 获取用户jss服务器信息" cmd:@255],
             [NSDictionary dictionaryWithDesc:@"256 获取相机jpro服务器信息" cmd:@256],
             [NSDictionary dictionaryWithDesc:@"257 获取相机jss服务器信息" cmd:@257],
             [NSDictionary dictionaryWithDesc:@"258 检查用户名是否与手机号绑定" cmd:@258],
             [NSDictionary dictionaryWithDesc:@"259 通过用户名获取用户Id" cmd:@259],
#warning testing 验证
             [NSDictionary dictionaryWithDesc:@"2510 通过手机号获取用户Id" cmd:@2510],
             [NSDictionary dictionaryWithDesc:@"2510+ 确认联系人列表" cmd:@25101],
             [NSDictionary dictionaryWithDesc:@"2511 通过邮箱获取用户Id" cmd:@2511],
             [NSDictionary dictionaryWithDesc:@"2512 设置用户手机号" cmd:@2512],
             [NSDictionary dictionaryWithDesc:@"2513 获取用户手机号" cmd:@2513],
             [NSDictionary dictionaryWithDesc:@"2514 验证用户手机号" cmd:@2514],
//             [NSDictionary dictionaryWithDesc:@"2515 设置用户昵称" cmd:@2515],
//             [NSDictionary dictionaryWithDesc:@"2516 获取用户昵称" cmd:@2516],
//             [NSDictionary dictionaryWithDesc:@"2517 设置用户所在地" cmd:@2517],
//             [NSDictionary dictionaryWithDesc:@"2518 获取用户所在地" cmd:@2518],
//             [NSDictionary dictionaryWithDesc:@"2519 设置用户个性签名" cmd:@2519],
//             [NSDictionary dictionaryWithDesc:@"2520 获取用户个性签名" cmd:@2520],
             [NSDictionary dictionaryWithDesc:@"2521 设置用户头像" cmd:@2521],
             [NSDictionary dictionaryWithDesc:@"2522 获取用户头像" cmd:@2522],
//#warning testing 好友
//             [NSDictionary dictionaryWithDesc:@"2523 获取用户好友列表" cmd:@2523],
//             [NSDictionary dictionaryWithDesc:@"2524 添加好友" cmd:@2524],
//             [NSDictionary dictionaryWithDesc:@"2525 删除好友" cmd:@2525],
//#warning testing 相机分享
//             [NSDictionary dictionaryWithDesc:@"2526 分享相机给好友" cmd:@2526],
//             [NSDictionary dictionaryWithDesc:@"2527 取消相机对好友的分享" cmd:@2527],
//             [NSDictionary dictionaryWithDesc:@"2528 获取相机列表" cmd:@2528],
             
//#warning testing ok
             [NSDictionary dictionaryWithDesc:@"2529 绑定测试相机0112" cmd:@2529],
             [NSDictionary dictionaryWithDesc:@"2530 解绑相机" cmd:@2530],
             
//#warning testing
//             [NSDictionary dictionaryWithDesc:@"2531 获取相机的分享列表" cmd:@2531],
//             [NSDictionary dictionaryWithDesc:@"2532 获取相机信息" cmd:@2532],
//             [NSDictionary dictionaryWithDesc:@"2533 设置相机昵称" cmd:@2533],
             
//#warning testing ok
             [NSDictionary dictionaryWithDesc:@"2534 获取相机拥有者Id" cmd:@2534],
             [NSDictionary dictionaryWithDesc:@"2535 获取用户名By userId" cmd:@2535],
#warning testing 36 - 42 暂时不写
             
             ] ;
    
    self.socketAgent_v2 = [QY_SocketAgent shareInstance] ;
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
#define testTelephone @"18817870386"
#define testEmail @"793951781@qq.com"
#define testPassword1 @"123456"
#define testPassword2 @"1234567"
#define testUserId @"10000100"
#define testCameraId @"t00000000000112"
#define testNickname @"虎猫儿"
#define testLocation @"中国上海"
#define testSign @"虎猫儿(・Д・)ノ"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cmd = [cmds[indexPath.row][cmdKey] integerValue] ;
    switch (cmd) {
        case -7 : {
            
            NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext] ;
            //增
            [context insertObject:nil] ;
            [context insertedObjects] ;
            //删
            [context deleteObject:nil] ;
            [context deletedObjects] ;
            //改
            [context updatedObjects] ;
            
            //查
            NSError *error ;
            [context executeFetchRequest:nil error:&error] ;
//            TestEntity *person = [NSEntityDescription insertNewObjectForEntityForName:@"TestEntity" inManagedObjectContext:context] ;
//            person.name = @"MJ" ;
//            person.age = [NSNumber numberWithInt:27] ;
//            
//            TestCard *card = [NSEntityDescription insertNewObjectForEntityForName:@"TestCard" inManagedObjectContext:context] ;
//            card.no = @"1234567" ;
//            person.card = card ;
//            
//            BOOL result = [context save:NULL] ;
//            
//            if ( result ) {
//                QYDebugLog(@"成功") ;
//                QYDebugLog(@"%@",[QY_FileService getDocPath]) ;
//            }
            
            break ;
        }
//        case -6 : {
//            [self.socketService autoDeviceLogin] ;
//            break ;
//        }
//        case -5 : {
//            [self.socketService getJRMIPandJRMPORT_v2] ;
//            break ;
//        }
//        case -4 : {            
//            [QYUser loginName:testUsername Password:testPassword1 complection:^(BOOL success, NSError *error) {
//                if ( success ) {
//                    QYDebugLog(@"登陆成功- -") ;
//                    [QYUtils toMain] ;
//                } else {
//                    QYDebugLog(@"登陆失败 error = %@",error) ;
//                    [QYUtils alert:@"登陆失败"] ;
//                }
//            }] ;
//            break ;
//        }
//        case -3 : {
//            [QY_QRCodeUtils startWithDelegater:self] ;
//            break ;
//        }
//        case -1 : {
//            [QY_JPROHttpService downLoadTest] ;
//            break ;
//        }
//        case -2 : {
//            [QY_JPROHttpService uploadTest] ;
//            break ;
//        }
//        case 0 : {
//            NSError *error ;
//            [self.socketService connectToJDASHost:&error] ;
//            break ;
//        }
//        case 1 : {
//            [self.socketService getJRMIPandJRMPORT] ;
//            //221.6.13.155 , Port = 50271
//            break ;
//        }
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
            [self.socketAgent_v2 userRegisteRequestWithName:@"793951781" Psd:testPassword1 Complection:^(NSDictionary *info, NSError *error) {
                if ( !error ) {
                    QYDebugLog(@"注册成功 userId = %@",info) ;
                } else {
                    QYDebugLog(@"注册失败 error = %@",error) ;
                }
            }] ;
            
            break ;
        }
        case 252 : {
            [self.socketAgent_v2 userLoginRequestWithName:testUsername Psd:testPassword2 Complection:^(BOOL success, NSError *error) {
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
                if ( !error ) {
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
#warning test
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
            [self.socketAgent_v2 bindingTelephoneForUser:testCameraId Telephone:testTelephone Complection:nil] ;
            break ;
        }
        case 2513 : {
            [self.socketAgent_v2 getTelephoneByUserId:testUserId Complection:nil] ;
            break ;
        }
        case 2514 : {
            [self.socketAgent_v2 verifyTelephoneForUser:testUserId Telephone:testTelephone VerifyCode:@"233" Complection:nil] ;
            break ;
        }
//        case 2515 : {
//            [self.socketService setNicknameForUser:testUserId Nickname:testNickname] ;
//            break ;
//        }
//        case 2516 : {
//            [self.socketService getNicknameByUserId:testUserId] ;
//            break ;
//        }
//        case 2517 : {
//            [self.socketService setUserLocationForUser:testUserId Location:testLocation] ;
//            break ;
//        }
//        case 2518 : {
//            [self.socketService getUserLocationByUserId:testUserId] ;
//            break ;
//        }
//        case 2519 : {
//            [self.socketService setUserSignForUser:testUserId Sign:testSign] ;
//            break ;
//        }
//        case 2520 : {
//            [self.socketService getUserSignByUserId:testUserId] ;
//            break ;
//        }
        case 2521 : {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            break ;
        }
        case 2522 : {
//            [self.socketService getUserAvatarForUser:testUserId] ;
            
            [self.socketAgent_v2 getUserAvatarForUser:testUserId Complection:^(NSData *imageData, NSError *error) {
                BOOL successed = !error ;
                if ( successed ) {
                    QYDebugLog(@"获取用户头像成功") ;
                    UIImage *image = [UIImage imageWithData:imageData] ;
                    
                    __block UIImageView *avatarView = [[UIImageView alloc] initWithImage:image] ;
                    
                    [avatarView setFrame:CGRectMake(100, 100, 50, 50)] ;
                    
                    [self.view addSubview:avatarView] ;
//                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 20 ) ;
//                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                        QYDebugLog(@"dismiss") ;
//                        [avatarView removeFromSuperview] ;
//                    }) ;
                    
                } else {
                    QYDebugLog(@"获取用户头像失败 error = %@",error) ;
                }
                
            }] ;
            
            break ;
        }
        case 2529 : {
//            [self.socketService bindingCameraToCurrentUser:testCameraId] ;
            break ;
        }
        case 2530 : {
//            [self.socketService unbindingCameraToCurrentUser:testCameraId] ;
            break ;
        }
        case 2532 : {
//            [self.socketService getCameraInformationForCameraId:testCameraId] ;
            break ;
        }
        case 2534 : {
//            [self.socketService getCameraOwnerIdForCamera:testCameraId] ;
            break ;
        }
        case 2535 : {
//            [self.socketService getUsernameByUserId:testUserId] ;
            break ;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

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
//            [self.socketService bindingCameraToCurrentUser:self.userId] ;
        } else {
            QYDebugLog(@"user为空") ;            
        }
        
    } else
    if (option == QY_QRCodeType_User )  {
        QYDebugLog(@"添加好友！") ;
        QYUser *user = [QYUser currentUser] ;
        NSString *friendId = info[QY_QRCODE_DATA_DIC_KEY][KEY_FOR_DATA_AT_INDEX(1)] ;
        
        if ( user ) {
//            [self.socketService createAddRequestToUser:friendId] ;
        } else {
            QYDebugLog(@"user为空") ;
        }
        
    }
}

#pragma mark - 

- (void)testContacts {
    QY_contactUtils *contactUtils = [[QY_contactUtils alloc] init] ;
    WEAKSELF
    [contactUtils getContactsComplection:^(BOOL success, NSArray *contacts) {
        if ( success ) {
            QYDebugLog(@"获取联系人成功") ;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _sema = dispatch_semaphore_create(0) ;
                
//                weakSelf.socketService.delegate = weakSelf ;
                
                for ( QY_Contact *contact in contacts ) {
                    QYDebugLog(@"contact = %@",contact) ;
//                    [weakSelf.socketService getUserIdByTelephone:contact.tel] ;
                    
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
    [self.socketAgent_v2 setUserAvatarForUser:testUserId image:image Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"上传头像成功") ;
        } else {
            QYDebugLog(@"上传头像失败 error = %@",error) ;
        }
    }] ;
    
//    [self.socketService setUserAvatarForUser:testUserId image:image] ;
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