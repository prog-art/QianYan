//
//  QY_MessageFactor.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMDataPacketFactor.h"

#import "QY_jclient_jrm_protocol_Marco.h"

#import "QY_CommonDefine.h"

#import "QY_JRMDataPacket.h"

#import "JRMvalue.h"

#pragma marl - QY_dataPacketFactor

@implementation QY_JRMDataPacketFactor

+ (NSData *)getDataWithOperationType:(JRM_REQUEST_OPERATION_TYPE)operationType Parameters:(NSDictionary *)parameters ParameterCount:(NSInteger)count {
    NSData *data ;
#warning 分路
    switch (operationType) {
        //211
        case JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN : {
            data = [self getDeviceLoginData] ;
            break ;
        }
        //251
        case JRM_REQUEST_OPERATION_TYPE_USER_REGISTE : {
            data = [self getUserRegisteDataWithUserName:parameters[ParameterKey_username]
                                               password:parameters[ParameterKey_password]] ;
            break ;
        }
        //252
        case JRM_REQUEST_OPERATION_TYPE_USER_LOGIN : {
            data = [self getUserLoginDataWithUserName:parameters[ParameterKey_username]
                                             password:parameters[ParameterKey_password]] ;
            break ;
        }
        //253
        case JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD : {
            data = [self getDataForResetPasswordForUser:parameters[ParameterKey_userId]
                                               password:parameters[ParameterKey_password]] ;
            break ;
        }
        //254
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO : {
            data = [self getDataForgetJRPOserverInfoForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //255
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_JSS : {
            data = [self getDataForgetJSSserverInfoForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //256
        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JPRO : {
            data = [self getDataForgetJRPOserverInfoForCamera:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //257
        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JSS : {
            data = [self getDataForgetJSSserverInfoForCamera:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //258
        case JRM_REQUEST_OPERATION_TYPE_CHECK_USERNAME_B_TEL : {
            data = [self getDataForcheckUsernameBindingTelephone:parameters[ParameterKey_username]
                                                       Telephone:parameters[ParameterKey_userPhone]] ;
            break ;
        }
        //259
        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_USERNAME : {
            data = [self getDataForUserIdByUsername:parameters[ParameterKey_username]] ;
            break ;
        }
        //2510
        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_TEL : {
            data = [self getDataForgetUserIdByTelephone:parameters[ParameterKey_userPhone]] ;
            break ;
        }
        //2511
        case JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_EMAIL : {
            data = [self getDataForgetUserIdByEmail:parameters[ParameterKey_userEmail]] ;
            break ;
        }
        //2512
        case JRM_REQUEST_OPERATION_TYPE_SET_TEL_FOR_USER : {
            data = [self getDataForBindingTelephoneForUser:parameters[ParameterKey_userId]
                                                 Telephone:parameters[ParameterKey_userPhone]] ;
            break ;
        }
        //2513
        case JRM_REQUEST_OPERATION_TYPE_GET_TEL_BY_ID : {
            data = [self getDataForgetTelephoneByUserId:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2514
        case JRM_REQUEST_OPERATION_TYPE_VALIDATE_USER_TEL : {
            data = [self getDataForVerifyTelephoneForUser:parameters[ParameterKey_userId]
                                                Telephone:parameters[ParameterKey_userPhone]
                                               VerifyCode:parameters[ParameterKey_verifyCode]] ;
            break ;
        }
        //2515
        case JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_USER : {
            data = [self getDataForsetNicknameForUser:parameters[ParameterKey_userId]
                                             Nickname:parameters[ParameterKey_userNickname]] ;
        }
        //2516
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_NICKNAME : {
            data = [self getDataForgetNicknameForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2517
        case JRM_REQUEST_OPERATION_TYPE_SET_LOCATION_FOR_USER : {
            data = [self getDataForsetUserLocationForUser:parameters[ParameterKey_userId]
                                                 Location:parameters[ParameterKey_userLocation]] ;
            break ;
        }
        //2518
        case JRM_REQUEST_OPERATION_TYPE_GET_LOCATION_FOR_USER : {
            data  = [self getDataForgetUserLocationForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2519
        case JRM_REQUEST_OPERATION_TYPE_SET_SIGN_FOR_USER : {
            data = [self getDataForsetUserSignForUser:parameters[ParameterKey_userId]
                                                 Sign:parameters[ParameterKey_userSign]] ;
            break ;
        }
        //2520
        case JRM_REQUEST_OPERATION_TYPE_GET_SIGN_FOR_USER : {
            data = [self getDataForgetUserSignForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
#warning 2521
#warning 2522
        //2523
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_FRIENDLIST : {
            data = [self getDataForgetUserFriendListForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2524
        case JRM_REQUEST_OPERATION_TYPE_ADD_FRIEND : {
            data = [self getDataForcreateAddRequestToUser:parameters[ParameterKey_friendId]] ;
            break ;
        }
        //2525
        case JRM_REQUEST_OPERATION_TYPE_DEL_FRIEND : {
            data = [self getDataFordeleteFriend:parameters[ParameterKey_friendId]] ;
            break ;
        }
        //2526
        case JRM_REQUEST_OPERATION_TYPE_SHARE_CAMERA_TO_FRIEND : {
            data = [self getDataForshareCamera:parameters[ParameterKey_jipncId]
                                        toUser:parameters[ParameterKey_friendId]] ;
            break ;
        }
        //2527
        case JRM_REQUEST_OPERATION_TYPE_CANCEL_SHARING_CAMERA_TO_FRIEND : {
            data = [self getDataForstopSharingCamera:parameters[ParameterKey_jipncId]
                                              toUser:parameters[ParameterKey_friendId]] ;
            break ;
        }
        //2528
        case JRM_REQUEST_OPERATION_TYPE_GET_USER_CAMERALIST : {
            data = [self getDataForGetCameraListForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2529 ok
        case JRM_REQUEST_OPERATION_TYPE_BINDING_CAMERA_FOR_CURRENT_USER : {
            data = [self getDataForbindingCameraToCurrentUser:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //2530
        case JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER : {
            data = [self getDataForunbindingCameraToCurrentUser:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //2531
        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_SHARINGLISE : {
            data = [self getDataForgetCameraSharingListForOwner:parameters[ParameterKey_ownerId]
                                                         camera:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //2532
        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_INFO : {
            data = [self getDataForgetCameraInformationForCameraId:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //2533
        case JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_CAMERA : {
            data = [self getDataForSetNicknameForCamera:parameters[ParameterKey_jipncId]
                                               Nickname:parameters[ParameterKey_jipncNickname]] ;
            break ;
        }
        //2534
        case JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_OWNDERID : {
            data = [self getDataForgetCameraOwnerIdForCamera:parameters[ParameterKey_jipncId]] ;
            break ;
        }
        //2535
        case JRM_REQUEST_OPERATION_TYPE_GET_USERNAME_BY_ID : {
            data = [self getDataForgetUsernameForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2536
        case JRM_REQUEST_OPERATION_TYPE_GET_SERIES_BY_ID : {
            data = [self getDataForgetUserLoginSeriesForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2537
        case JRM_REQUEST_OPERATION_TYPE_REFRESH_SERIES_FOR_USER : {
            data = [self getDataForrefreshUserLoginSeriesForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2538
        case JRM_REQUEST_OPERATION_TYPE_BINDING_EMAIL_FOR_USER : {
            data = [self getDataForrequestBindingEmail:parameters[ParameterKey_userEmail]
                                               ForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2539
        case JRM_REQUEST_OPERATION_TYPE_UNBINDING_EMAIL_FOR_USER : {
            data = [self getDataForrequestUnbindingEmailForUser:parameters[ParameterKey_userId]] ;
            break ;
        }
        //2540
        case JRM_REQUEST_OPERATION_TYPE_GET_ID_FOR_THIRD_PART_LOGIN_USER : {
            data = [self getDataForgetUserIdForThirdPartLoginUserWithAccountTyoe:parameters[ParameterKey_accountType]
                                                                          openId:parameters[ParameterKey_openId]] ;
            break ;
        }
        //2541
        case JRM_REQUEST_OPERATION_TYPE_NEW_ACCOUNT_FOR_THIRD_PART_LOGIN_USER : {
            data = [self getDataFornewAccountForThirdPartLoginUserWithAccountTyoe:parameters[ParameterKey_accountType]
                                                                           openId:parameters[ParameterKey_openId]
                                                                         username:parameters[ParameterKey_username]] ;
            break ;
        }
        //2542
        case JRM_REQUEST_OPERATION_TYPE_SET_USERNAME_FOR_THIRD_PART_LOGIN_USER : {
            data = [self getDataForsetUsernameForThirdPartLoginWithAccountType:parameters[ParameterKey_accountType]
                                                                        openId:parameters[ParameterKey_openId]
                                                                      username:parameters[ParameterKey_username]] ;
            break ;
        }
        default:
            break;
    }
    
    return data ;
}

#pragma mark - 指定数据

/**
 *  2.1.1  设备登陆数据包
 *
 *  @return
 */
+ (NSData *)getDeviceLoginData {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:@(JOSEPH_DEVICE_JCLIENT)
                                        valueLen:4
                                       valueType:JRMValueType_Number] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:LOGIN2JRM_REQUEST_CMD
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.1 用户注册数据包
 *
 *  @param username 用户名(邮箱或手机号，安卓是数字或字母)
 *  @param password 密码(6-20位数字或密码....)
 *
 *  @return
 */
+ (NSData *)getUserRegisteDataWithUserName:(NSString *)username password:(NSString *)password {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:username
                                        valueLen:JRM_DATA_LEN_OF_KEY_username
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:password
                              valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_REG_NEW_USER
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.2 用户登录数据包
 *
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return
 */
+ (NSData *)getUserLoginDataWithUserName:(NSString *)username password:(NSString *)password {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:username
                                        valueLen:JRM_DATA_LEN_OF_KEY_username
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:password
                              valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket
                                packetWithCmd:DEVICE_LOGIN2JRM_CMD
                                JRMvalues:jvalues
                                ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.3 重设用户密码
 *
 *  @param userId      用户Id (string,16bytes)
 *  @param newPassword 新密码 (string,32bytes)
 */
+ (NSData *)getDataForResetPasswordForUser:(NSString *)userId password:(NSString *)newPassword {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:newPassword
                              valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_PASS
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.4 获取用户jpro服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
+ (NSData *)getDataForgetJRPOserverInfoForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_JPRO
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.5 获取用户jss服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
+ (NSData *)getDataForgetJSSserverInfoForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_JSS
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.6 获取相机jpro服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
+ (NSData *)getDataForgetJRPOserverInfoForCamera:(NSString *)jipnc_Id {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:jipnc_Id
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_IPNC_JPRO
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.7 获取相机jss服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
+ (NSData *)getDataForgetJSSserverInfoForCamera:(NSString *)jipnc_Id {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:jipnc_Id
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_IPNC_JSS
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.8 检查用户名是否绑定手机号
 *
 *  @param username  用户名
 *  @param telephone 手机号
 */
+ (NSData *)getDataForcheckUsernameBindingTelephone:(NSString *)username Telephone:(NSString *)telephone {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:username
                                        valueLen:JRM_DATA_LEN_OF_KEY_username
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:telephone
                              valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_CHECK_USERNAME_PHONE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.9 通过用户名获取用户Id
 *
 *  @param username 用户名
 */
+ (NSData *)getDataForUserIdByUsername:(NSString *)username {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:username
                                        valueLen:JRM_DATA_LEN_OF_KEY_username
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_ID
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.10 通过手机号获取用户Id
 *
 *  @param telephone 手机号
 */
+ (NSData *)getDataForgetUserIdByTelephone:(NSString *)telephone {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:telephone
                                        valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_ID_BY_PHONE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.11 通过邮箱获取用户Id
 *
 *  @param email 邮箱
 */
+ (NSData *)getDataForgetUserIdByEmail:(NSString *)email {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:email
                                        valueLen:JRM_DATA_LEN_OF_KEY_userEmail
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_ID_BY_EMAIL
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.12 设置用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */
+ (NSData *)getDataForBindingTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:telephone
                              valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_PHONE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.13 获取用户手机号
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetTelephoneByUserId:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_PHONE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}


/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId     用户Id
 *  @param telephone  手机号
 *  @param verifyCode 验证码
 */
+ (NSData *)getDataForVerifyTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone VerifyCode:(NSString *)verifyCode {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    //2
    jvalue = [JRMvalue objectWithValue:telephone
                              valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    //3
    jvalue = [JRMvalue objectWithValue:verifyCode
                              valueLen:JRM_DATA_LEN_OF_KEY_verifyCode
                             valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_VERIFY_USER_PHONE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:3] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.15 设置用户昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
+ (NSData *)getDataForsetNicknameForUser:(NSString *)userId Nickname:(NSString *)nickName {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:nickName
                              valueLen:JRM_DATA_LEN_OF_KEY_userNickname
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_NICKNAME
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.16 获取用户昵称
 *
 *  @param userId   用户Id
 */
+ (NSData *)getDataForgetNicknameForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_NICKNAME
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.17 设置用户所在地
 *
 *  @param userId   用户Id
 *  @param location 用户位置 例:@"江苏南京"
 */
+ (NSData *)getDataForsetUserLocationForUser:(NSString *)userId Location:(NSString *)location {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:location
                              valueLen:JRM_DATA_LEN_OF_KEY_userLocation
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_LOCATION
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.18 获取用户所在地
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUserLocationForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_LOCATION
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.19 设置用户个性签名
 *
 *  @param userId 用户Id
 *  @param sign   签名 128byes
 */
+ (NSData *)getDataForsetUserSignForUser:(NSString *)userId Sign:(NSString *)sign {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:sign
                              valueLen:JRM_DATA_LEN_OF_KEY_userSign
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_SIGN
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.20 获取用户个性签名
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUserSignForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_SIGN
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}


#warning 待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计
/**
 *  2.5.21 设置用户头像
 *
 *  @param userId 用户Id
 *  @param avatar 头像图片(待处理),头像最大大小
 */
+ (NSData *)getDataForsetUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar {
    QYDebugLog() ;
//    NSMutableArray *jvalues = [NSMutableArray array] ;
//    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
//                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
//                                       valueType:JRMValueType_String] ;
//    
//    
//    [jvalues addObject:jvalue] ;
//    
//    jvalue = [JRMvalue objectWithValue:password
//                              valueLen:JRM_DATA_LEN_OF_KEY_userPassword
//                             valueType:JRMValueType_String] ;
//    [jvalues addObject:jvalue] ;
//    
//    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USER_SCULPTURE
//                                                     JRMvalues:jvalues
//                                        ValueDescriptionsCount:2] ;
//    
//    return [packet JRMData] ;
    return nil ;
}

#pragma mark - 好友

#warning 待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计
/**
 *  2.5.22 获取用户头像
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUserAvatarForUser:(NSString *)userId {
    QYDebugLog() ;
//    NSMutableArray *jvalues = [NSMutableArray array] ;
//    JRMvalue *jvalue = [JRMvalue objectWithValue:username
//                                        valueLen:JRM_DATA_LEN_OF_KEY_username
//                                       valueType:JRMValueType_String] ;
//    
//    
//    [jvalues addObject:jvalue] ;
//    
//    jvalue = [JRMvalue objectWithValue:password
//                              valueLen:JRM_DATA_LEN_OF_KEY_userPassword
//                             valueType:JRMValueType_String] ;
//    [jvalues addObject:jvalue] ;
//    
//    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_REG_NEW_USER
//                                                     JRMvalues:jvalues
//                                        ValueDescriptionsCount:2] ;
//    
//    return [packet JRMData] ;
    return nil ;
}

/**
 *  2.5.23 获取用户好友列表
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUserFriendListForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_FRIEND_LIST
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.24 添加好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
+ (NSData *)getDataForcreateAddRequestToUser:(NSString *)friendId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:friendId
                                        valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_ADD_FRIEND
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.25 删除好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
+ (NSData *)getDataFordeleteFriend:(NSString *)friendId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:friendId
                                        valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_DEL_FRIEND
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}




#pragma mark - 相机相关

/**
 *  2.5.26 分享相机给好友
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
+ (NSData *)getDataForshareCamera:(NSString *)cameraId toUser:(NSString *)friendId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:friendId
                                        valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:cameraId
                              valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_ADD_IPNC_SHARE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.27 取消相机对好友的分享
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
+ (NSData *)getDataForstopSharingCamera:(NSString *)cameraId toUser:(NSString *)friendId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:friendId
                                        valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:cameraId
                              valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_DEL_IPNC_SHARE
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}


/**
 *  2.5.28 获取相机列表
 */
+ (NSData *)getDataForGetCameraListForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_IPNC_LIST
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.29 用户绑定相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForbindingCameraToCurrentUser:(NSString *)cameraId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:cameraId
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_ADD_MY_OWN_IPNC
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.30 用户解绑相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForunbindingCameraToCurrentUser:(NSString *)cameraId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:cameraId
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_DEL_MY_OWN_IPNC
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
    
}

/**
 *  2.5.31 获取相机的分享列表
 *
 *  @param ownerId  相机拥有者的userId
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForgetCameraSharingListForOwner:(NSString *)ownerId camera:(NSString *)cameraId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:ownerId
                                        valueLen:JRM_DATA_LEN_OF_KEY_ownerId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:cameraId
                              valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_IPNC_SHARE_FOR_FRIEND_LIST
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.32 获取指定相机信息
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForgetCameraInformationForCameraId:(NSString *)cameraId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:cameraId
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_IPNC_INFO
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.33 设置相机昵称
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForSetNicknameForCamera:(NSString *)cameraId Nickname:(NSString *)nickname {
    QYDebugLog() ;

    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:cameraId
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:nickname
                              valueLen:JRM_DATA_LEN_OF_KEY_jipncNickname
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_IPNC_NICKNAME
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.34 获取相机拥有者Id
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
+ (NSData *)getDataForgetCameraOwnerIdForCamera:(NSString *)cameraId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:cameraId
                                        valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_IPNC_OWNER_ID
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

#pragma mark - User

/**
 *  2.5.35 获取用户名
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUsernameForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_USER_USERNAME
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.36 查询登录串号
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForgetUserLoginSeriesForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_OLD_USER_SERIES
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.37 刷新登录串号
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForrefreshUserLoginSeriesForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_GET_NEW_USER_SERIES
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

#pragma mark - 邮箱绑定

/**
 *  2.5.38 用户绑定邮箱请求
 *
 *  @param userEmail 用户邮箱(string,32byes)
 *  @param userId    用户Id
 */
+ (NSData *)getDataForrequestBindingEmail:(NSString *)userEmail ForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:userEmail
                              valueLen:JRM_DATA_LEN_OF_KEY_userEmail
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_BIND_EMAIL_FOR_USER
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.39 用户解绑邮箱请求
 *
 *  @param userId 用户Id
 */
+ (NSData *)getDataForrequestUnbindingEmailForUser:(NSString *)userId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:userId
                                        valueLen:JRM_DATA_LEN_OF_KEY_userId
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_UNBIND_EMAIL_FOR_USER
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:1] ;
    
    return [packet JRMData] ;
}

#pragma mark - 第三方登录

/**
 *  2.5.40 第三方登录获取用户Id
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪
 *  @param openId      该账号类型下全局唯一
 */
+ (NSData *)getDataForgetUserIdForThirdPartLoginUserWithAccountTyoe:(NSString *)accountTyoe openId:(NSString *)openId {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:accountTyoe
                                        valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                       valueType:JRMValueType_String] ;
    
    
    [jvalues addObject:jvalue] ;
    
    jvalue = [JRMvalue objectWithValue:openId
                              valueLen:JRM_DATA_LEN_OF_KEY_openId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_LOGIN_BY_OPENID
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:2] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.41 第三方登录新建账户
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
+ (NSData *)getDataFornewAccountForThirdPartLoginUserWithAccountTyoe:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:accountType
                                        valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    //2
    jvalue = [JRMvalue objectWithValue:openId
                              valueLen:JRM_DATA_LEN_OF_KEY_openId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    //3
    jvalue = [JRMvalue objectWithValue:username
                              valueLen:JRM_DATA_LEN_OF_KEY_username
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_REGISTER_BY_OPENID
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:3] ;
    
    return [packet JRMData] ;
}

/**
 *  2.5.42 第三方登录修改用户名
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
+ (NSData *)getDataForsetUsernameForThirdPartLoginWithAccountType:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username {
    QYDebugLog() ;
    NSMutableArray *jvalues = [NSMutableArray array] ;
    JRMvalue *jvalue = [JRMvalue objectWithValue:accountType
                                        valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                       valueType:JRMValueType_String] ;
    
    [jvalues addObject:jvalue] ;
    
    //2
    jvalue = [JRMvalue objectWithValue:openId
                              valueLen:JRM_DATA_LEN_OF_KEY_openId
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    //3
    jvalue = [JRMvalue objectWithValue:username
                              valueLen:JRM_DATA_LEN_OF_KEY_username
                             valueType:JRMValueType_String] ;
    [jvalues addObject:jvalue] ;
    
    QY_JRMDataPacket *packet = [QY_JRMDataPacket packetWithCmd:JCLIENT_SET_USERNAME_BY_OPENID
                                                     JRMvalues:jvalues
                                        ValueDescriptionsCount:3] ;
    
    return [packet JRMData] ;
}


@end