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

#pragma mark - 删除好友

//#error 改！
- (void)deleteFriendWithId:(NSString *)friendId complection:(QYResultBlock)complection {
    
//    complection = ^(BOOL result,NSError *error) {
//        if ( complection ) {
//            complection(result,error) ;
//        }
//    } ;
//    QYDebugLog(@"删除好友 friendId = %@",friendId) ;
//
//    QYUser *curUser = [QYUser currentUser] ;
//    
//    if ( !curUser ) {
//        QYDebugLog(@"未登录!") ;
//        
//        NSError *error = [NSError QYErrorWithCode:USER_DID_NOT_LOGIN description:@"未登录！"];
//        
//        complection(false,error) ;
//        
//        return ;
//    }
//    
//    QY_user *user = curUser.coreUser ;
//    QY_user *friend = [QY_user findUserById:friendId] ;
//
//    if ( [user.friends containsObject:friend] ) {
//        [[QY_JPROHttpService shareInstance] deleteFriendWithFriendId:friend.userId selfId:user.userId complection:^(BOOL success, NSError *error) {
//            if ( success ) {
//                //本地删除
//                QYDebugLog(@"删除成功，准备从本地数据库删除") ;
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toFriend.userId = %@",friend.userId];
//                QY_friendSetting *setting = (QY_friendSetting *)[QY_appDataCenter findObjectWithClassName:@"QY_friendSetting" predicate:predicate] ;
//                {
//                    QY_user *friend = setting.toFriend ;
//                    QY_user *owner = setting.owner ;
//                    QYDebugLog(@"setting[%@] exist : %@ , owner = [%@] , toFriend = [%@]",setting,setting?@"存在":@"不存在",owner,friend) ;
//                    [QY_appDataCenter deleteObjectsWithClassName:@"QY_friendSetting" predicate:predicate] ;
//                    setting = nil ;
//                }
//                [QY_appDataCenter saveObject:nil error:NULL] ;
//                QYDebugLog(@"本地数据库删除成功") ;
//                complection(TRUE,nil) ;
//                
//            } else {
//                NSError *error = [NSError QYErrorWithCode:JPRO_DELETE_FRIEND_FILE_ERROR description:@"删除双方文件时出错"] ;
//                complection(FALSE,error) ;
//            }
//        }] ;
//    } else {
//        QYDebugLog(@"无好友关系！") ;
//        NSError *error = [NSError QYErrorWithCode:ALL_FIX_ERROR description:@"无好友关系"] ;
//        
//        complection(FALSE,error) ;
//    }
}

@end
