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
    
#warning 如果后台数据结构不重构，之后就会非常非常麻烦了。
    
    //0.拉取资料。。。
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:[QY_JPROUrlFactor pathForUserProfile:friendId] complection:^(NSString* xmlStr, NSError *error) {
        if ( xmlStr ) {
            QY_user *friend = [QY_XMLService getUserFromProfileXML:xmlStr] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            
            if ( user.coreUser.nickname == nil ) {
                [[QY_JPROHttpService shareInstance] downloadFileFromPath:[QY_JPROUrlFactor pathForUserProfile:user.userId] complection:^(NSString *xmlStr, NSError *error) {
                    
                    if ( xmlStr ) {
                        user.coreUser = [QY_XMLService getUserFromProfileXML:xmlStr] ;
                        [QY_appDataCenter saveObject:nil error:NULL] ;
                        
                        //两边资料齐全才能添加。。
                        [self addFriendWithFriendInstance:friend] ;
                        
                    } else {
                        [QYUtils alert:@"资料拉取失败，请检查网络"] ;
                    }
                }] ;
            }
        } else {
            [QYUtils alertError:error] ;
            
        }
    }] ;

}

/**
 *  拉取到用户资料后，准备添加！
 *
 *  @param friend
 */
- (void)addFriendWithFriendInstance:(QY_user *)friend {
    //1.在自己用户档案朋友列表目录user/10000133/friendlist/中添加friendId.xml,并设置follow属性为1。其他属性0
    //2.在对方用户档案朋友列表目录user/friendId/friendlist/中添加selfId.xml，并设置fans属性为1，其他0
    
    //3.在对方消息通知文件user/10000022/notification.xml添加好友关注消息。
    dispatch_async(dispatch_get_main_queue(), ^{
        //先保存
        [QY_appDataCenter saveObject:nil error:NULL] ;
        
        QY_user *me = [QY_appDataCenter userWithId:[QYUser currentUser].userId] ;
        
        [me addFriendsObject:friend] ;
        
        QY_friendSetting *me2Friend = [QY_friendSetting setting] ;
        me2Friend.owner = me ;
        me2Friend.toFriend = friend ;
        me2Friend.remarkName = me.nickname ;
        NSString *path4Friend = [QY_JPROUrlFactor pathForUserFriendList:friend.userId FriendId:me.userId] ;
        
        
        QY_friendSetting *friend2Me = [QY_friendSetting setting] ;
        friend2Me.owner = friend ;
        friend2Me.toFriend = me ;
        friend2Me.remarkName = friend.nickname ;
        NSString *path4Me = [QY_JPROUrlFactor pathForUserFriendList:me.userId FriendId:friend.userId] ;

        
        //开始上传服务器
        [[QY_JPROHttpService shareInstance] uploadFileToPath:path4Friend FileData:me2Friend.xmlStringDataForTransportByHttp fileName:@"file" mimeType:MIMETYPE Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                
                [[QY_JPROHttpService shareInstance] uploadFileToPath:path4Me FileData:friend2Me.xmlStringDataForTransportByHttp fileName:@"file" mimeType:MIMETYPE Complection:^(BOOL success, NSError *error) {
                    if ( success ) {
                        QYDebugLog(@"添加好友成功") ;
                        [QY_appDataCenter saveObject:nil error:NULL] ;
                        [QYUtils alert:@"添加好友成功"] ;
                    } else {
                        [[QY_appDataCenter managedObjectContext] undo] ;
                    }
                }] ;
                
            } else {
                [[QY_appDataCenter managedObjectContext] undo] ;
            }
        }] ;
    }) ;
}

#pragma mark - 删除好友

- (void)deleteFriendWithId:(NSString *)friendId complection:(QYResultBlock)complection {
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    QYDebugLog(@"删除好友 friendId = %@",friendId) ;

    QYUser *curUser = [QYUser currentUser] ;
    
    if ( !curUser ) {
        QYDebugLog(@"未登录!") ;
        
        NSError *error = [NSError QYErrorWithCode:USER_DID_NOT_LOGIN description:@"未登录！"];
        
        complection(false,error) ;
        
        return ;
    }
    
    QY_user *user = curUser.coreUser ;
    QY_user *friend = [QY_user findUserById:friendId] ;

    if ( [user.friends containsObject:friend] ) {
        [[QY_JPROHttpService shareInstance] deleteFriendWithFriendId:friend.userId selfId:user.userId complection:^(BOOL success, NSError *error) {
            if ( success ) {
                //本地删除
                QYDebugLog(@"删除成功，准备从本地数据库删除") ;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toFriend.userId = %@",friend.userId];
                QY_friendSetting *setting = (QY_friendSetting *)[QY_appDataCenter findObjectWithClassName:@"QY_friendSetting" predicate:predicate] ;
                {
                    QY_user *friend = setting.toFriend ;
                    QY_user *owner = setting.owner ;
                    QYDebugLog(@"setting[%@] exist : %@ , owner = [%@] , toFriend = [%@]",setting,setting?@"存在":@"不存在",owner,friend) ;
                    [QY_appDataCenter deleteObjectsWithClassName:@"QY_friendSetting" predicate:predicate] ;
                    setting = nil ;
                }
                [user removeFriendsObject:friend] ;
                [QY_appDataCenter saveObject:nil error:NULL] ;
                QYDebugLog(@"本地数据库删除成功") ;
                complection(TRUE,nil) ;
                
            } else {
                NSError *error = [NSError QYErrorWithCode:JPRO_DELETE_FRIEND_FILE_ERROR description:@"删除双方文件时出错"] ;
                complection(FALSE,error) ;
            }
        }] ;
    } else {
        QYDebugLog(@"无好友关系！") ;
        NSError *error = [NSError QYErrorWithCode:ALL_FIX_ERROR description:@"无好友关系"] ;
        
        complection(FALSE,error) ;
    }
}

@end
