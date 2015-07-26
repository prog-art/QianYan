//
//  QYViewController.m
//  
//
//  Created by 虎猫儿 on 15/7/12.
//
//

#import "QYBaseViewController.h"
#import "QY_Common.h"

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
            NSString *userId = info[KEY_FOR_DATA_AT_INDEX(0)] ;
//            NSString *device_type = info[KEY_FOR_DATA_AT_INDEX(2)] ;
            QYDebugLog(@"二维码中userId = %@",userId) ;
            
            [self addFriendWithFriendId:userId] ;
            
            break ;
        }
            
        case QY_QRCodeType_Binding_Camera : {
            NSString *cameraId = info[KEY_FOR_DATA_AT_INDEX(0)] ;
//            NSString *password = info[KEY_FOR_DATA_AT_INDEX(1)] ;
//            NSString *device_type = info[KEY_FOR_DATA_AT_INDEX(2)] ;
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
 *  @param cameraId
 */
- (void)bindingCameraWithCameraId:(NSString *)cameraId {
    QYDebugLog(@"绑定摄像机！") ;
    
    QYUser *user = [QYUser currentUser] ;
    user.userId = @"10000133" ;
    
    if ( user.userId ) {
        
        [[QY_SocketAgent shareInstance] bindingCameraToCurrentUser:cameraId Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                [QYUtils alert:@"绑定摄像机成功"] ;
            } else {
                [QYUtils alertError:error] ;
            }
        }] ;
        
    } else {
        QYDebugLog(@"user为空") ;
    }
}

- (void)addFriendWithFriendId:(NSString *)friendId {
    QYDebugLog(@"添加好友！") ;
    QYUser *user = [QYUser currentUser] ;
    
    if ( user ) {
#warning 修改
//        [[QY_SocketAgent shareInstance] createAddRequestToUser:friendId Complection:^(BOOL success, NSError *error) {
//            if ( success ) {
//                [QYUtils alert:@"添加好友成功"] ;
//            } else {
//                [QYUtils alertError:error] ;
//            }            
//        }] ;
    } else {
        QYDebugLog(@"user为空") ;
    }
}


@end
