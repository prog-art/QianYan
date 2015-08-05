//
//  QYViewController.m
//  
//
//  Created by 虎猫儿 on 15/7/12.
//
//

#import "QYBaseViewController.h"
#import "QY_Common.h"
#import "QY_JPROUrlFactor.h"
#import "QY_JPROHttpService.h"
#import "QY_XMLService.h"

@implementation QYBaseViewController


#pragma mark - QY_QRCodeScanerDelegate

/**
 *  成功扫描二维码，普通字符串
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr {
    QYDebugLog(@"str = %@",resultStr) ;
}

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan {
    QYDebugLog(@"扫描取消") ;
}

/**
 *  扫描到了某种千衍的二维码结构
 *
 *  @param opetion 扫描到的类型
 *  @param info    各种参数
 */
- (void)QY_didScanOption:(QY_QRCodeType)option userInfo:(NSDictionary *)info {
    NSDictionary *data = info[QY_QRCODE_DATA_DIC_KEY] ;
    QYDebugLog(@"data = %@",data) ;
    switch (option) {
        case QY_QRCodeType_User : {
            NSString *userId = data[KEY_FOR_DATA_AT_INDEX(0)] ;
//            NSString *device_type = data[KEY_FOR_DATA_AT_INDEX(2)] ;
            QYDebugLog(@"二维码中userId = %@",userId) ;
            
            [self addFriendWithFriendId:userId] ;
            
            break ;
        }
            
        case QY_QRCodeType_Binding_Camera : {
            NSString *cameraId = data[KEY_FOR_DATA_AT_INDEX(0)] ;
//            NSString *password = data[KEY_FOR_DATA_AT_INDEX(1)] ;
//            NSString *device_type = data[KEY_FOR_DATA_AT_INDEX(2)] ;
            QYDebugLog(@"二维码中cameraId = %@",cameraId) ;
            
            [self bindingCameraWithCameraId:cameraId] ;
            
            break ;
        }
            
        default:
            break;
    }
}

#pragma mark - QR Option 

/**
 *  绑定摄像机
 *
 *  @param cameraId 相机Id
 */
- (void)bindingCameraWithCameraId:(NSString *)cameraId {
    QYDebugLog(@"绑定摄像机！Id = %@",cameraId) ;
    
    QYUser *user = [QYUser currentUser] ;
    if ( !user || !user.userId ) {
        QYDebugLog(@"User 为空") ;
        return ;
    }
    
    //绑定相机流程，1.扫描二维码ok了。

    [[QY_SocketAgent shareInstance] bindingCameraToCurrentUser:cameraId Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"绑定摄像机成功") ;
            [QYUtils alert:@"绑定摄像机成功"] ;
        } else {
            QYDebugLog(@"绑定摄像机失败 error = %@",error) ;
            [QYUtils alertError:error] ;
        }
        
    }] ;
}

/**
 *  添加好友
 *
 *  @param friendId 好友Id
 */
- (void)addFriendWithFriendId:(NSString *)friendId {
    QYDebugLog(@"添加好友！friendId = %@",friendId) ;
    
    QYUser *user = [QYUser currentUser] ;
    if ( !user || !user.userId ) {
        QYDebugLog(@"User 为空") ;
        return ;
    }
    
    if ( nil == friendId ) {
        [QYUtils alert:@"friendId为空，非法！"] ;
        return ;
    }
    
    QY_user *me = user.coreUser ;
    
    [me addFriendById:friendId complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"添加好友成功") ;
            [QYUtils alert:@"添加好友成功"] ;
        } else {
            QYDebugLog(@"添加好友失败 error = %@",error) ;
            [QYUtils alertError:error] ;
        }
    }] ;
}

@end
