//
//  QY_SocketServiceDelegateNotificationCenter.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketServiceDelegateNotificationCenter.h"

#import "QY_JRMDataPhraser.h"

@implementation QY_SocketServiceDelegateNotificationCenter

#pragma mark 发送通知QY_SocketServiceDelegate

+ (void)postDelegate:(id<QY_SocketServiceDelegate>)delegate Notification:(JRM_REQUEST_OPERATION_TYPE)operation WithPacket:(QY_JRMDataPacket *)packet {
    switch (operation) {
        case JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN:
            [self postDeviceLoginResultTo:delegate Packet:packet] ;
            break;
        case JRM_REQUEST_OPERATION_TYPE_USER_REGISTE:
            [self postUserRegisteResultTo:delegate Packet:packet] ;
            break ;
        case JRM_REQUEST_OPERATION_TYPE_USER_LOGIN:
            [self postUserLoginResultTo:delegate Packet:packet] ;
            break ;
            
            //            //253
            //        case JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD : {
            //            data = [self getDataForResetPasswordForUser:parameters[ParameterKey_userId]
            //                                               password:parameters[ParameterKey_password]] ;
            //            break ;
            //        }
        //254
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO : {
            [self postGetJPROServerInfoForUserResultTo:delegate Packet:packet] ;
            break ;
        }
            //            //255
            //        case JRM_REQUEST_OPERATION_TYPE_GET_USER_JSS : {
            //            data = [self getDataForgetJSSserverInfoForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //256
            //        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JPRO : {
            //            data = [self getDataForgetJRPOserverInfoForCamera:parameters[ParameterKey_jipncId]] ;
            //            break ;
            //        }
            //            //257
            //        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JSS : {
            //            data = [self getDataForgetJSSserverInfoForCamera:parameters[ParameterKey_jipncId]] ;
            //            break ;
            //        }
            //            //258
            //        case JRM_REQUEST_OPERATION_TYPE_CHECK_USERNAME_B_TEL : {
            //            data = [self getDataForcheckUsernameBindingTelephone:parameters[ParameterKey_username]
            //                                                       Telephone:parameters[ParameterKey_userPhone]] ;
            //            break ;
            //        }
        //259
        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_USERNAME : {
            [self postQY_getUserIdByUsernameResultTo:delegate Packet:packet] ;
            break ;
        }
            //            //2510
            //        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_TEL : {
            //            data = [self getDataForgetUserIdByTelephone:parameters[ParameterKey_userPhone]] ;
            //            break ;
            //        }
            //            //2511
            //        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_EMAIL : {
            //            data = [self getDataForgetUserIdByEmail:parameters[ParameterKey_userEmail]] ;
            //            break ;
            //        }
            //            //2512
            //        case JRM_REQUEST_OPERATION_TYPE_SET_TEL_FOR_USER : {
            //            data = [self getDataForBindingTelephoneForUser:parameters[ParameterKey_userId]
            //                                                 Telephone:parameters[ParameterKey_userPhone]] ;
            //            break ;
            //        }
            //            //2513
            //        case JRM_REQUEST_OPERATION_TYPE_GET_TEL_BY_ID : {
            //            data = [self getDataForgetTelephoneByUserId:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2514
            //        case JRM_REQUEST_OPERATION_TYPE_VALIDATE_USER_TEL : {
            //            data = [self getDataForVerifyTelephoneForUser:parameters[ParameterKey_userId]
            //                                                Telephone:parameters[ParameterKey_userPhone]
            //                                               VerifyCode:parameters[ParameterKey_verifyCode]] ;
            //            break ;
            //        }
            //            //2515
            //        case JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_USER : {
            //            data = [self getDataForsetNicknameForUser:parameters[ParameterKey_userId]
            //                                             Nickname:parameters[ParameterKey_userNickname]] ;
            //        }
            //            //2516
            //        case JRM_REQUEST_OPERATION_TYPE_GET_USER_NICKNAME : {
            //            data = [self getDataForgetNicknameForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2517
            //        case JRM_REQUEST_OPERATION_TYPE_SET_LOCATION_FOR_USER : {
            //            data = [self getDataForsetUserLocationForUser:parameters[ParameterKey_userId]
            //                                                 Location:parameters[ParameterKey_userLocation]] ;
            //            break ;
            //        }
            //            //2518
            //        case JRM_REQUEST_OPERATION_TYPE_GET_LOCATION_FOR_USER : {
            //            data  = [self getDataForgetUserLocationForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2519
            //        case JRM_REQUEST_OPERATION_TYPE_SET_SIGN_FOR_USER : {
            //            data = [self getDataForsetUserSignForUser:parameters[ParameterKey_userId]
            //                                                 Sign:parameters[ParameterKey_userSign]] ;
            //            break ;
            //        }
            //            //2520
            //        case JRM_REQUEST_OPERATION_TYPE_GET_SIGN_FOR_USER : {
            //            data = [self getDataForgetUserSignForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //#warning 2521
            //#warning 2522
            //            //2523
            //        case JRM_REQUEST_OPERATION_TYPE_GET_USER_FRIENDLIST : {
            //            data = [self getDataForgetUserFriendListForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //2524
            case JRM_REQUEST_OPERATION_TYPE_ADD_FRIEND : {
                [self post2524To:delegate Packet:packet] ;
                break ;
            }
            //            //2525
            //        case JRM_REQUEST_OPERATION_TYPE_DEL_FRIEND : {
            //            data = [self getDataFordeleteFriend:parameters[ParameterKey_friendId]] ;
            //            break ;
            //        }
            //            //2526
            //        case JRM_REQUEST_OPERATION_TYPE_SHARE_CAMERA_TO_FRIEND : {
            //            data = [self getDataForshareCamera:parameters[ParameterKey_jipncId]
            //                                        toUser:parameters[ParameterKey_friendId]] ;
            //            break ;
            //        }
            //            //2527
            //        case JRM_REQUEST_OPERATION_TYPE_CANCEL_SHARING_CAMERA_TO_FRIEND : {
            //            data = [self getDataForstopSharingCamera:parameters[ParameterKey_jipncId]
            //                                              toUser:parameters[ParameterKey_friendId]] ;
            //            break ;
            //        }
            //            //2528
            //        case JRM_REQUEST_OPERATION_TYPE_GET_USER_CAMERALIST : {
            //            data = [self getDataForGetCameraListForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //2529
            case JRM_REQUEST_OPERATION_TYPE_BINDING_CAMERA_FOR_CURRENT_USER : {
                [self post2529To:delegate Packet:packet] ;
                break ;
            }
                //2530
            case JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER : {
                [self post2530To:delegate Packet:packet] ;
                break ;
            }
            //            //2531
            //        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_SHARINGLISE : {
            //            data = [self getDataForgetCameraSharingListForOwner:parameters[ParameterKey_ownerId]
            //                                                         camera:parameters[ParameterKey_jipncId]] ;
            //            break ;
            //        }
            //            //2532
            //        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_INFO : {
            //            data = [self getDataForgetCameraInformationForCameraId:parameters[ParameterKey_jipncId]] ;
            //            break ;
            //        }
            //            //2533
            //        case JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_CAMERA : {
            //            data = [self getDataForSetNicknameForCamera:parameters[ParameterKey_jipncId]
            //                                               Nickname:parameters[ParameterKey_jipncNickname]] ;
            //            break ;
            //        }
            //            //2534
            //        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_OWNDERID : {
            //            data = [self getDataForgetCameraOwnerIdForCamera:parameters[ParameterKey_jipncId]] ;
            //            break ;
            //        }
            //            //2535
            //        case JRM_REQUEST_OPERATION_TYPE_GET_USERNAME_BY_ID : {
            //            data = [self getDataForgetUsernameForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2536
            //        case JRM_REQUEST_OPERATION_TYPE_GET_SERIES_BY_ID : {
            //            data = [self getDataForgetUserLoginSeriesForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2537
            //        case JRM_REQUEST_OPERATION_TYPE_REFRESH_SERIES_FOR_USER : {
            //            data = [self getDataForrefreshUserLoginSeriesForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2538
            //        case JRM_REQUEST_OPERATION_TYPE_BINDING_EMAIL_FOR_USER : {
            //            data = [self getDataForrequestBindingEmail:parameters[ParameterKey_userEmail]
            //                                               ForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2539
            //        case JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_USER : {
            //            data = [self getDataForrequestUnbindingEmailForUser:parameters[ParameterKey_userId]] ;
            //            break ;
            //        }
            //            //2540
            //        case JRM_REQUEST_OPERATION_TYPE_GET_ID_FOR_THIRD_PART_LOGIN_USER : {
            //            data = [self getDataForgetUserIdForThirdPartLoginUserWithAccountTyoe:parameters[ParameterKey_accountType]
            //                                                                          openId:parameters[ParameterKey_openId]] ;
            //            break ;
            //        }
            //            //2541
            //        case JRM_REQUEST_OPERATION_TYPE_NEW_ACCOUNT_FOR_THIRD_PART_LOGIN_USER : {
            //            data = [self getDataFornewAccountForThirdPartLoginUserWithAccountTyoe:parameters[ParameterKey_accountType]
            //                                                                           openId:parameters[ParameterKey_openId]
            //                                                                         username:parameters[ParameterKey_username]] ;
            //            break ;
            //        }
            //            //2542
            //        case JRM_REQUEST_OPERATION_TYPE_SET_USERNAME_FOR_THIRD_PART_LOGIN_USER : {
            //            data = [self getDataForsetUsernameForThirdPartLoginWithAccountType:parameters[ParameterKey_accountType]
            //                                                                        openId:parameters[ParameterKey_openId]
            //                                                                      username:parameters[ParameterKey_username]] ;
            //            break ;
            //        }
            //
        default:
            break;
    }
}

#pragma mark - 

// 211
+ (void)postDeviceLoginResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {

    if ( [delegate respondsToSelector:@selector(QY_deviceLoginSuccessed:)]) {
        if ( !packet) {
            QYDebugLog(@"未知错误，socket连接断开") ;
            [delegate QY_deviceLoginSuccessed:FALSE] ;
            return ;
        }
        QYDebugLog(@"设备登录成功") ;
        [delegate QY_deviceLoginSuccessed:TRUE] ;
    }
}

// 251
+ (void)postUserRegisteResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_userRegisteSuccessed:userId:)]) {
        if ( !packet || packet.cmd == JCLIENT_REG_NEW_USER_NAME_INVALID ) {
            QYDebugLog(@"注册失败") ;
            [delegate QY_userRegisteSuccessed:FALSE userId:nil] ;
            return ;
        }
        
        if ( packet.cmd == JCLIENT_REG_NEW_USER_REPLY ) {
            QYDebugLog(@"注册成功") ;
            [delegate QY_userRegisteSuccessed:TRUE userId:[packet valueAtIndex:0]] ;
        }
        
    }
}

// 252
+ (void)postUserLoginResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_userLoginSuccessed:)]) {
        if ( !packet || packet.cmd == DEVICE_LOGIN2JRM_ERR ) {
            QYDebugLog(@"登录失败") ;
            [delegate QY_userLoginSuccessed:FALSE] ;
            return ;
        }
        
        if ( packet.cmd == DEVICE_LOGIN2JRM_OK) {
            QYDebugLog(@"登录成功") ;
            [delegate QY_userLoginSuccessed:TRUE] ;
        }
    }
}

// 254
+ (void)postGetJPROServerInfoForUserResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_getJPROServerInfoForUserSuccessed:Ip:Port:Password:)]) {
        if ( !packet || packet.cmd == JOSEPH_COMMAND_ERR ) {
            QYDebugLog(@"获取JPRO服务器信息失败") ;
            [delegate QY_getJPROServerInfoForUserSuccessed:FALSE
                                                        Ip:nil
                                                      Port:nil
                                                  Password:nil] ;
            return ;
        }
        
        if ( packet.cmd == JOSEPH_COMMAND_OK ) {
            QYDebugLog(@"获取JPRO服务器信息成功") ;
            [delegate QY_getJPROServerInfoForUserSuccessed:TRUE
                                                        Ip:[packet valueAtIndex:0]
                                                      Port:[packet valueAtIndex:1]
                                                  Password:[packet valueAtIndex:2]] ;
        }
    }
}

// 259
+ (void)postQY_getUserIdByUsernameResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_getUserIdByUsernameSuccessed:UserId:)]) {
        if ( !packet || packet.cmd == JOSEPH_COMMAND_ERR ) {
            QYDebugLog(@"通过用户名获取用户Id失败") ;
            [delegate QY_getUserIdByUsernameSuccessed:FALSE
                                               UserId:nil] ;
            return ;
        }
        
        if ( packet.cmd == JOSEPH_COMMAND_OK ) {
            QYDebugLog(@"通过用户名获取用户Id成功") ;
            [delegate QY_getUserIdByUsernameSuccessed:TRUE
                                               UserId:[packet valueAtIndex:0]] ;
        }
    }
}

#pragma mark - 2510

#pragma mark - 2520

+ (void)post2524To:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    
    if ( !packet || packet.cmd == JOSEPH_COMMAND_ERR ) {
        QYDebugLog(@"添加好友失败！") ;

        [delegate QY_addFriendSuccessed:FALSE] ;
        return ;
    }
    
    if ( packet.cmd == JOSEPH_COMMAND_OK ) {
        QYDebugLog(@"添加好友成功！") ;
        [delegate QY_addFriendSuccessed:TRUE] ;
    }
}

+ (void)post2529To:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    
    if ( !packet || packet.cmd == JOSEPH_COMMAND_ERR ) {
        QYDebugLog(@"绑定相机失败！") ;
        [delegate QY_bindCameraSuccessed:FALSE errorCode:[[packet valueAtIndex:0] integerValue]] ;
        return ;
    }
    
    if ( packet.cmd == JOSEPH_COMMAND_OK ) {
        QYDebugLog(@"绑定相机成功！") ;
        [delegate QY_bindCameraSuccessed:TRUE errorCode:-1] ;
    }
}

#pragma mark - 2530

+ (void)post2530To:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( !packet || packet.cmd == JOSEPH_COMMAND_ERR ) {
        QYDebugLog(@"解绑相机失败！") ;
        
        [delegate QY_unbindCameraSuccessed:FALSE] ;
        return ;
    }
    
    if ( packet.cmd == JOSEPH_COMMAND_OK ) {
        QYDebugLog(@"解绑相机成功！") ;
        [delegate QY_unbindCameraSuccessed:TRUE] ;
    }
}


#pragma mark - 2540

@end