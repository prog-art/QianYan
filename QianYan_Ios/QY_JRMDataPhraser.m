//
//  QY_JRMDataPharser.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMDataPhraser.h"

#import "QYUtils.h"

#import "NSString+QY_dataFormat.h"
#import "NSData+QY_dataFormat.h"

#import "JRMvalue.h"

@implementation QY_JRMDataPhraser

+(QY_JRMDataPacket *)pharseDataWithData:(NSData *)data Tag:(JRM_REQUEST_OPERATION_TYPE)tag {
    QYDebugLog() ;
    QY_JRMDataPacket *resPacket ;
    
    switch (tag) {
        //211
        case JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN:
            resPacket = [self packetFromDeviceLoginResponse:data] ;
            break ;
        //251
        case JRM_REQUEST_OPERATION_TYPE_USER_REGISTE:
            resPacket = [self packetFromUserRegisteResponse:data] ;
            break ;
        //252
        case JRM_REQUEST_OPERATION_TYPE_USER_LOGIN:
            resPacket = [self packetFromUserLoginResponse:data] ;
            break ;
//            //253
//        case JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD : {
//            data = [self getDataForResetPasswordForUser:parameters[ParameterKey_userId]
//                                               password:parameters[ParameterKey_password]] ;
//            break ;
//        }
        //254
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO : {
            resPacket = [self packetFrom254Response:data] ;
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
            resPacket = [self packetFrom259Response:data] ;
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
            resPacket = [self packetFrom2524Response:data] ;
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
            resPacket = [self packetFrom2529Response:data] ;
            break ;
        }
        //2530
        case JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER : {
            resPacket = [self packetFrom2530Response:data] ;
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
            resPacket = nil ;
            [QYUtils alert:[NSString stringWithFormat:@"未知的服务器操作类型%d",tag]] ;
            break;
    }
    return resPacket ;
}

#pragma mark - 数据解析器(method)

#pragma mark - 211

NSUInteger api211SuccessDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.1.1  设备登陆返回数据解析
 *  成功：LOGIN2JRM_REPLY_CMD(=41)
 *  失败：断开JRMSocket连接
 *
 *  @param responseData 服务器返回data
 *
 *  @return 解析好的 QY_JRMDataPacket 数据模型。
 */
+ (QY_JRMDataPacket *)packetFromDeviceLoginResponse:(NSData *)responseData {
    if ( responseData.length != api211SuccessDataLen ) {
        QYDebugLog(@"211 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"设备登录 data = %@",responseData) ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithJRMData:responseData
                                                 ValueDescriptions:nil
                                            ValueDescriptionsCount:0] ;
    return packet ;
}

#pragma mark - 251

NSUInteger api251SuccessDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD + JRM_DATA_LEN_OF_KEY_userId ;
NSUInteger api251FailedDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.1 用户注册返回数据解析
 */
+ (QY_JRMDataPacket *)packetFromUserRegisteResponse:(NSData *)responseData {
    if ( responseData.length != api251FailedDataLen && responseData.length !=api251SuccessDataLen) {
        QYDebugLog(@"251 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"用户注册 data = %@",responseData) ;//data = <00140000 019d3130 30303031 33300000 00000000 0000>
    
    JRMvalueDescription *description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                          Type:JRMValueType_String] ;
    
    QY_JRMDataPacket *packet = responseData.length == api251SuccessDataLen ?
        [QY_JRMDataPacket packetWithJRMData:responseData
                          ValueDescriptions:@[description]
                     ValueDescriptionsCount:1] :
        [QY_JRMDataPacket packetWithJRMData:responseData
                          ValueDescriptions:nil
                     ValueDescriptionsCount:0] ;
    
    return packet ;
}

NSUInteger api252FullDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.2  用户登录返回数据解析
 */
+ (QY_JRMDataPacket *)packetFromUserLoginResponse:(NSData *)responseData {
    if ( responseData.length != api252FullDataLen ) {
        QYDebugLog(@"252 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"用户登录 data = %@",responseData) ;//data = <00040000 ffdd>
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithJRMData:responseData
                                                 ValueDescriptions:nil
                                            ValueDescriptionsCount:0] ;
    return packet ;
}

NSUInteger api254SuccessDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD + JRM_DATA_LEN_OF_KEY_jproIp + JRM_DATA_LEN_OF_KEY_jproPort + JRM_DATA_LEN_OF_KEY_jproPassword ;
NSUInteger api254FailedDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.4 获取用户jpro服务器信息
 */
+ (QY_JRMDataPacket *)packetFrom254Response:(NSData *)responseData {
    if ( responseData.length != api254FailedDataLen &&
        responseData.length != api254SuccessDataLen ) {
        QYDebugLog(@"254 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"254 data = %@",responseData) ;//data =
    
	
    NSMutableArray *descriptions = [NSMutableArray array] ;
    JRMvalueDescription *description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproIp
                                                                          Type:JRMValueType_String] ;
    [descriptions addObject:description] ; 
    
    description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPort
                                                     Type:JRMValueType_String] ;
    [descriptions addObject:description] ;
    
    description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPassword
                                                     Type:JRMValueType_String] ;
    [descriptions addObject:description] ;
    
    
    QY_JRMDataPacket *packet = responseData.length == api254SuccessDataLen ?
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:descriptions
                 ValueDescriptionsCount:3] :
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:nil
                 ValueDescriptionsCount:0] ;
    
    return packet ;
}

NSUInteger api259SuccessDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD + JRM_DATA_LEN_OF_KEY_userId ;
NSUInteger api259FailedDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.9 通过用户名获取用户Id
 */
+ (QY_JRMDataPacket *)packetFrom259Response:(NSData *)responseData {
    if ( responseData.length != api259FailedDataLen &&
         responseData.length != api259SuccessDataLen ) {
        QYDebugLog(@"259 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"259 data = %@",responseData) ;//data =
    
    JRMvalueDescription *description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                          Type:JRMValueType_String] ;
    
    QY_JRMDataPacket *packet = responseData.length == api259SuccessDataLen ?
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:@[description]
                 ValueDescriptionsCount:1] :
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:nil
                 ValueDescriptionsCount:0] ;
    
    return packet ;
}


#pragma mark - 2510

#pragma mark - 2520

NSUInteger api2524FullDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.24 添加好友
 */
+ (QY_JRMDataPacket *)packetFrom2524Response:(NSData *)responseData {
    if ( responseData.length != api2524FullDataLen ) {
        QYDebugLog(@"2524 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"2524 data = %@",responseData) ;//data =
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithJRMData:responseData
                                                 ValueDescriptions:nil
                                            ValueDescriptionsCount:0] ;
    
    return packet ;
}

NSUInteger api2529SuccessDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
NSUInteger api2529FailedDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD + JRM_DATA_LEN_OF_KEY_errno ;
/**
 *  2.5.29 用户绑定相机
 */
+ (QY_JRMDataPacket *)packetFrom2529Response:(NSData *)responseData {
    if ( responseData.length != api2529FailedDataLen &&
        responseData.length != api2529SuccessDataLen ) {
        QYDebugLog(@"2529 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"2529 data = %@",responseData) ;//data =
    
    JRMvalueDescription *description = [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_errno
                                                                          Type:JRMValueType_Number] ;
    
    QY_JRMDataPacket *packet = responseData.length == api2529SuccessDataLen ?
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:nil
                 ValueDescriptionsCount:0] :
    [QY_JRMDataPacket packetWithJRMData:responseData
                      ValueDescriptions:@[description]
                 ValueDescriptionsCount:1] ;
    
    return packet ;
}

#pragma mark - 2530

NSUInteger api2530FullDataLen = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
/**
 *  2.5.30 解绑相机
 */
+ (QY_JRMDataPacket *)packetFrom2530Response:(NSData *)responseData {
    if ( responseData.length != api2530FullDataLen ) {
        QYDebugLog(@"2530 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"2530 data = %@",responseData) ;//data =
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithJRMData:responseData
                                                 ValueDescriptions:nil
                                            ValueDescriptionsCount:0] ;
    
    return packet ;
}

#pragma mark - 2541


@end