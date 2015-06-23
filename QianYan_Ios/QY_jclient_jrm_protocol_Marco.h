//
//  QY_jclient_jrm_protocol_Marco.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_jclient_jrm_protocol_Marco_h
#define QianYan_Ios_QY_jclient_jrm_protocol_Marco_h

typedef NS_ENUM (NSInteger,JRM_REQUEST_OPERATION_TYPE) {
    JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN                           = 211 ,
    JRM_REQUEST_OPERATION_TYPE_USER_REGISTE                           = 251 ,
    JRM_REQUEST_OPERATION_TYPE_USER_LOGIN                             = 252 ,
    JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD                    = 253 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO                          = 254 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_JSS                           = 255 ,
    JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JPRO                        = 256 ,
    JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JSS                         = 257 ,
    JRM_REQUEST_OPERATION_TYPE_CHECK_USERNAME_B_TEL                   = 258 ,
    JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_USERNAME                     = 259 ,
    JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_TEL                          = 2510 ,
    JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_EMAIL                        = 2511 ,
    JRM_REQUEST_OPERATION_TYPE_SET_TEL_FOR_USER                       = 2512 ,
    JRM_REQUEST_OPERATION_TYPE_GET_TEL_BY_ID                          = 2513 ,
    JRM_REQUEST_OPERATION_TYPE_VALIDATE_USER_TEL                      = 2514 ,
    JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_USER                  = 2515 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_NICKNAME                      = 2516 ,
    JRM_REQUEST_OPERATION_TYPE_SET_LOCATION_FOR_USER                  = 2517 ,
    JRM_REQUEST_OPERATION_TYPE_GET_LOCATION_FOR_USER                  = 2518 ,
    JRM_REQUEST_OPERATION_TYPE_SET_SIGN_FOR_USER                      = 2519 ,
    JRM_REQUEST_OPERATION_TYPE_GET_SIGN_FOR_USER                      = 2520 ,
    JRM_REQUEST_OPERATION_TYPE_SET_AVATAR_FOR_USER                    = 2521 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_AVATAR                        = 2522 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_FRIENDLIST                    = 2523 ,
    JRM_REQUEST_OPERATION_TYPE_ADD_FRIEND                             = 2524 ,
    JRM_REQUEST_OPERATION_TYPE_DEL_FRIEND                             = 2525 ,
    JRM_REQUEST_OPERATION_TYPE_SHARE_CAMERA_TO_FRIEND                 = 2526 ,
    JRM_REQUEST_OPERATION_TYPE_CANCEL_SHARING_CAMERA_TO_FRIEND        = 2527 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USER_CAMERALIST                    = 2528 ,
    JRM_REQUEST_OPERATION_TYPE_BINDING_CAMERA_FOR_CURRENT_USER        = 2529 ,
    JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER      = 2530 ,
    JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_SHARINGLISE                 = 2531 ,
    JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_INFO                        = 2532 ,
    JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_CAMERA                = 2533 ,
    JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_OWNDERID                    = 2534 ,
    JRM_REQUEST_OPERATION_TYPE_GET_USERNAME_BY_ID                     = 2535 ,
    JRM_REQUEST_OPERATION_TYPE_GET_SERIES_BY_ID                       = 2536 ,
    JRM_REQUEST_OPERATION_TYPE_REFRESH_SERIES_FOR_USER                = 2537 ,
    JRM_REQUEST_OPERATION_TYPE_BINDING_EMAIL_FOR_USER                 = 2538 ,
    JRM_REQUEST_OPERATION_TYPE_UNBINDING_EMAIL_FOR_USER               = 2539 ,
    JRM_REQUEST_OPERATION_TYPE_GET_ID_FOR_THIRD_PART_LOGIN_USER       = 2540 ,
    JRM_REQUEST_OPERATION_TYPE_NEW_ACCOUNT_FOR_THIRD_PART_LOGIN_USER  = 2541 ,
    JRM_REQUEST_OPERATION_TYPE_SET_USERNAME_FOR_THIRD_PART_LOGIN_USER = 2542
};

#define QY_CMD JOSEPH_COMMAND 


/**
 *  依据协议版本 <<JRM通信协议(2015-4-29 10.41.11 3120)>>
 */

//------------------------   宏定义个部分参数的Key   ---------------------------------------------------

#define ParameterKey_username        @"username"
#define ParameterKey_password        @"password"
#define ParameterKey_userId          @"userId"
#define ParameterKey_jproIp          @"jproIp"
#define ParameterKey_jproPort        @"jproPort"
#define ParameterKey_jproPassword    @"jpropassword"

#define ParameterKey_jssId           @"jssId"
#define ParameterKey_jssIp           @"jssIp"
#define ParameterKey_jssPort4jipnc   @"jssPort4jipnc"
#define ParameterKey_jssPort4jclient @"jssPort4jclient"
#define ParameterKey_jssPassword     @"jssPassword"
#define ParameterKey_jssPort         @"jssPort"

#define ParameterKey_jipncId         @"jipncId"
#define ParameterKey_jipncPassword   @"jipncPassword"
#define ParameterKey_jipncNickname   @"jipncNickname"

#define ParameterKey_jipncMediaAddr  @"jipncMediaAddr"

#define ParameterKey_userPhone       @"userPhone"
#define ParameterKey_userEmail       @"userEmail"
#define ParameterKey_verifyCode      @"verifyCode"

#define ParameterKey_userNickname    @"userNickname"

#define ParameterKey_userLocation    @"userLocation"

#define ParameterKey_userSign        @"userSign"

#define ParameterKey_sculptureSize   @"sculptureSize"

#define ParameterKey_friendList      @"friendList"
#define ParameterKey_friendId        @"friendId"

#define ParameterKey_jipncList       @"jipncList"

#define ParameterKey_errno           @"errno"
#define ParameterKey_ownerId         @"ownerId"

#define ParameterKey_sharedList      @"sharedList"

#define ParameterKey_userLoginSeries @"userLoginSeries"

#define ParameterKey_accountType     @"accountType"
#define ParameterKey_openId          @"openId"

#define ParameterKey_avatar          @"avatar"

//------------------------   宏定义个部分参数的长度   ---------------------------------------------------


#define JRM_DATA_LEN_OF_KEY_LEN               2
#define JRM_DATA_LEN_OF_KEY_CMD               4

#define JRM_DATA_LEN_OF_KEY_JmsIP             16
#define JRM_DATA_LEN_OF_KEY_JmsPort           8

#define JRM_DATA_LEN_OF_KEY_username          16
#define JRM_DATA_LEN_OF_KEY_userPassword      32
#define JRM_DATA_LEN_OF_KEY_userId            16
#define JRM_DATA_LEN_OF_KEY_jproIp            32
#define JRM_DATA_LEN_OF_KEY_jproPort          8
#define JRM_DATA_LEN_OF_KEY_jproPassword      32

#define JRM_DATA_LEN_OF_KEY_jssId             16
#define JRM_DATA_LEN_OF_KEY_jssIp             32
#define JRM_DATA_LEN_OF_KEY_jssPort4jipnc     8
#define JRM_DATA_LEN_OF_KEY_jssPort4jclient   8
#define JRM_DATA_LEN_OF_KEY_jssPassword       32
#define JRM_DATA_LEN_OF_KEY_jssPort           8


#define JRM_DATA_LEN_OF_KEY_jipncId           16
#define JRM_DATA_LEN_OF_KEY_jipncPassword     32
#define JRM_DATA_LEN_OF_KEY_jipncNickname     32

//jipnc的多媒体地址 如 "c000 0000 0000 001"
#define JRM_DATA_LEN_OF_KEY_jipncMediaAddr    32



#define JRM_DATA_LEN_OF_KEY_userPhone         32
#define JRM_DATA_LEN_OF_KEY_userEmail         16
#define JRM_DATA_LEN_OF_KEY_verifyCode        32

#define JRM_DATA_LEN_OF_KEY_userNickname      32

//@"江苏南京"
#define JRM_DATA_LEN_OF_KEY_userLocation      32

#define JRM_DATA_LEN_OF_KEY_userSign          128

//#warning (unsigned int,4bytes)后跟4bytes描述的长度的image data.
#define JRM_DATA_LEN_OF_KEY_sculptureSize     4

#define JRM_DATA_LEN_OF_KEY_FriendList(count) 16*count

#define JRM_DATA_LEN_OF_KEY_FriendId          16
#define JRM_DATA_LEN_OF_KEY_jipncList(count)  16*count

//#warning (unsigned int , 4bytes) errorCode  (1:表示参数出错，2:表示绑定出错，3:表示已绑定给其他用户)
#define JRM_DATA_LEN_OF_KEY_errno             4

#define JRM_DATA_LEN_OF_KEY_ownerId           16
#define JRM_DATA_LEN_OF_KEY_sharedList(count) 16*count

//user的登录串号 "20150403093030 0000 0000"
#define JRM_DATA_LEN_OF_KEY_userLoginSeries   32

//#warning accountType ("1":表示QQ , "2":表示微信 , "3":表示新浪)
#define JRM_DATA_LEN_OF_KEY_accountType       8
#define JRM_DATA_LEN_OF_KEY_openId            64





//------------------------   协议中的:宏定义个部分参数的长度  -----------------------------------------

#define DEVICE_TYPE_SIZE            4
#define DEVICE_PASSWD_SIZE          32
#define DEVICE_ID_SIZE              16
#define USERID_SIZE                 16
#define USERNAME_SIZE               32
#define USEREMAIL_SIZE              32

#define USERPWD_SIZE                32
#define USER_GENDER_SIZE            8
#define NICKNAME_SIZE               32
#define IP_MEM_SIZE                 16
#define PORT_MEM_SIZE               8
#define MEDIA_SUB_SIZE              32
#define LOCATION_SIZE               64
#define USER_SIGN_SIZE              128
#define SCULPTURE_NAME_SIZE         128

#define USER_VERIFY_SIZE            16
#define JIPNC_INJSS_STREAM_ADDR_LEN 30
#define MAX_SINGLE_DATA_SIZE        128

typedef NS_ENUM(NSInteger, JOSEPH_COMMAND) {
    //JSS
    JSS_ID2JRM_ERR = 1,
    JRM_ACTIVED_JSS,
    JSS_REPORT_JIPNC_ADDR,
    JSS_REPORT_JIPNC_ADDR_REPLY,
    JSS2JRM_HB_REPLY,
    
    //JPC
    
    JPC_REQUEST_HOWMANY_IPNC = 10,
    JPC_REPLY2JPC_HOWMANY_IPNC,
    JPC_REQUEST_IPNC_INFO,
    JRM2JPC_IPNC_INFO,
    JPC_PUSH_IPNC_REMARK,
    JPC_PUSH_IPNC_REMARK_REPLY,
    
    
    
    JCLIENT_REQUEST_LOGIN = 20,
    JCLIENT_REQUEST_LOGIN_REPLY,
    JCLIENT_GET_IPNC_LIST,
    JCLIENT_GET_IPNC_LIST_REPLY,
    
    
    JCLIENT_GET_IPNC_INFO,
    JCLIENT_GET_IPNC_INFO_REPLY,
    JCLIENT_GET_IPNC_VER,
    JCLIENT_GET_IPNC_INFO_WITH_DOMAIN,
    
    
    //JIPNC
    JIPNC_REQUEST_JSS = 30,
    JIPNC_REPORT_VERSION,
    JIPNC_ADD_MY_OWNER,
    JIPNC_REQUEST_MY_OWNER,
    JIPNC_REQUEST_JSTORE,
    JIPNC_REQUEST_JSTORE_WITH_DOMAIN,
    JIPNC_REQUEST_JSS_WITH_DOMAIN,
    JIPNC_REQUEST_JPRO_WITH_DOMAIN,
    
    
    // NEW ....................................................
    
    // ALL
    LOGIN2JRM_REQUEST_CMD = 40,
    LOGIN2JRM_REPLY_CMD,
    LOGIN2JRM_REPLY_ERR,
    
    DEVICE_LOGIN2JRM_CMD = 43,
    DEVICE_LOGIN2JRM_OK,
    DEVICE_LOGIN2JRM_ERR,
    
    DEVICE2JRM_HB,
    DEVICE2JRM_HB_REPLY,
    
    
    
    // JSS-JIPNC
    JSS_REPORT_JIPNC,
    JSS_REPORT_JSS,
    JSS_REPORT_JSS_WITH_DOMAIN,
    JSS_REQUEST_JPRO_WITH_DOMAIN,
    
    
    JSTORE_REPORT_JSTORE = 80,
    JSTORE_REPORT_JSTORE_WITH_DOMAIN,
    REQUEST_JRM = 100,
    REQUEST_JRM_REPLY,
    
    CONNECT_JSS = 200,
    CONNECT_JSS_OK,
    
    
    JCLIENT_GET_IPNC_HOWMANY = 300,
    JCLIENT_GET_IPNC_HOWMANY_REPLY,
    JCLIENT_GET_FRIEND_HOWMANY,
    JCLIENT_GET_FRIEND_HOWMANY_REPLY,
    
    JCLIENT_GET_FRIEND_LIST,
    JCLIENT_GET_FRIEND_LIST_REPLY,
    
    JCLIENT_ADD_FRIEND,
    JCLIENT_DEL_FRIEND,
    
    
    JCLIENT_GET_USER_INFO = 400,
    JCLIENT_GET_USER_INFO_REPLY,
    
    JCLIENT_SET_USER_INFO,
    JCLIENT_SET_USER_INFO_REPLY,
    JCLIENT_SET_USER_INFO_REPLY_ERR,
    
    JCLIENT_GET_USER_SCULPTURE,
    JCLIENT_GET_USER_SCULPTURE_REPLY,
    
    JCLIENT_SET_USER_SCULPTURE,
    JCLIENT_SET_USER_SCULPTURE_REPLY,
    
    JCLIENT_CHECK_USERNAME_INDB = 409,
    JCLIENT_CHECK_USERNAME_IS_INDB,
    JCLIENT_CHECK_USERNAME_NOT_INDB = 411,
    
    JCLIENT_REG_NEW_USER,
    JCLIENT_REG_NEW_USER_REPLY,
    JCLIENT_REG_NEW_USER_NAME_INVALID,
    
    JCLIENT_SET_USER_USERNAME = 415,
    JCLIENT_GET_USER_USERNAME,
    JCLIENT_SET_USER_PASS,
    
    JCLIENT_GET_USER_PASS =418,
    JCLIENT_SET_USER_PHONE,
    JCLIENT_GET_USER_PHONE,
    JCLIENT_SET_USER_EMAIL,
    JCLIENT_GET_USER_EMAIL,
    JCLIENT_SET_USER_NICKNAME,
    JCLIENT_GET_USER_NICKNAME,
    JCLIENT_SET_USER_SIGN = 425,
    JCLIENT_GET_USER_SIGN,
    JCLIENT_SET_USER_LOCATION,
    JCLIENT_GET_USER_LOCATION,
    JCLIENT_SET_USER_GENDER,
    JCLIENT_GET_USER_GENDER,
    
    JCLIENT_SET_FRIEND_NICKNAME = 431,
    JCLIENT_GET_FRIEND_NICKNAME,
    JCLIENT_SET_FRIEND_DESCRIBE,
    JCLIENT_GET_FRIEND_DESCRIBE,
    
    
    JCLIENT_ADD_IPNC_SHARE = 435,
    JCLIENT_DEL_IPNC_SHARE,
    
    
    JCLIENT_SET_IPNC_NICKNAME,
    JCLIENT_GET_IPNC_NICKNAME,
    
    JCLIENT_GET_USER_ID = 439,
    
    JCLIENT_GET_FRIEND_SCULPTURE,
    GET_JMSG_ADDR =441,
    
    GET_JIPNC_SUBADDR_IN_JSS,
    
    JCLIENT_GET_IPNC_OWNER_ID,
    
    JCLIENT_ADD_MY_OWN_IPNC = 461,
    JCLIENT_DEL_MY_OWN_IPNC,
    
    JCLIENT_GET_USER_ID_BY_PHONE = 470,
    JCLIENT_GET_USER_ID_BY_EMAIL = 471,
    
    JCLIENT_BIND_EMAIL_FOR_USER = 479,
    JCLIENT_RESET_PASSWD_BY_EMAIL = 480,
    JCLIENT_RESET_PASSWD_BY_PHONE = 481,
    JCLIENT_VERIFY_USER_BY_EMAIL = 482,
    
    JCLIENT_GET_OLD_USER_SERIES = 483,
    JCLIENT_GET_NEW_USER_SERIES = 484,
    JCLIENT_IPNC_SHARE_FOR_FRIEND_LIST = 490,
    JCLIENT_VERIFY_USER_PHONE = 491,
    JCLIENT_UNBIND_EMAIL_FOR_USER = 492,
    
    JCLIENT_GET_PUBLIC_IPNC_HOWMANY = 501,
    JCLIENT_GET_PUBLIC_IPNC_LIST = 502,
    JCLIENT_GET_PUBLIC_IPNC_INFO = 503,
    JCLIENT_GET_UPDATE_INFO = 504,
    JCLIENT_GET_USER_JPRO = 505,
    JCLIENT_GET_USER_JSS = 506,
    JCLIENT_GET_IPNC_JPRO = 507,
    JCLIENT_GET_IPNC_JSS = 508,
    JCLIENT_CHECK_USERNAME_PHONE = 509,
    JCLIENT_LOGIN_BY_OPENID = 510,
    JCLIENT_REGISTER_BY_OPENID = 511,
    JCLIENT_SET_USERNAME_BY_OPENID = 512,
    
    DEVICE_LOGIN2JRM_OPEN_CMD=600,
    JCLIENT_OPEN_REG_NEW_USER,
    JCLIENT_OPEN_REG_NEW_USER_REPLY,
    
    // reserved
    USER_IS_NULL = 65498,
    USEREMAIL_IS_NULL = 65499,
    JOSEPH_COMMAND_OK=65500,
    JOSEPH_COMMAND_ERR,
    JOSEPH_COMMAND_NULL
};

//安卓和IOS 都是 JOSEPH_DEVICE_JCLIENT = 30 ;
typedef NS_ENUM(NSInteger, JOSEPH_DEVICE_TYPE) {
    //*****************res 1**************************
    JOSEPH_DEVICE_JDAS = 1,
    JOSEPH_DEVICE_JRM = 10,
    JOSEPH_DEVICE_JSS = 20,
    JOSEPH_DEVICE_JCLIENT = 30,
    JOSEPH_DEVICE_JIPNC = 130,
    JOSEPH_DEVICE_JSTORE= 140,
    JOSEPH_DEVICE_JVRS =300,
    
    //*****************wuxi 1**************************
    JOSEPH_DEVICE_JSS_WUXI_1 = 611,
    JOSEPH_DEVICE_JCLIENT_WUXI_1 = 612,
    JOSEPH_DEVICE_JIPNC_WUXI_1 = 613,
    JOSEPH_DEVICE_JSTORE_WUXI_1= 614,
    JOSEPH_DEVICE_JVRS_WUXI_1 =615,
    
    //*****************wuxi 2**************************
    JOSEPH_DEVICE_JSS_WUXI_2 = 621,
    JOSEPH_DEVICE_JCLIENT_WUXI_2 = 622,
    JOSEPH_DEVICE_JIPNC_WUXI_2 = 623,
    JOSEPH_DEVICE_JSTORE_WUXI_2= 624,
    JOSEPH_DEVICE_JVRS_WUXI_2 =625,
    
    //*****************nanjing 1**************************
    JOSEPH_DEVICE_JSS_NANJING_1 = 711,
    JOSEPH_DEVICE_JCLIENT_NANJING_1 = 712,
    JOSEPH_DEVICE_JIPNC_NANJING_1 = 713,
    JOSEPH_DEVICE_JSTORE_NANJING_1= 714,
    JOSEPH_DEVICE_JVRS_NANJING_1 =715,
    
    //*****************nanjing 2**************************
    JOSEPH_DEVICE_JSS_NANJING_2 = 721,
    JOSEPH_DEVICE_JCLIENT_NANJING_2 = 722,
    JOSEPH_DEVICE_JIPNC_NANJING_2 = 723,
    JOSEPH_DEVICE_JSTORE_NANJING_2= 724,
    JOSEPH_DEVICE_JVRS_NANJING_2 =725,
    
    //*****************nanjing 3**************************
    JOSEPH_DEVICE_JSS_NANJING_3 = 731,
    JOSEPH_DEVICE_JCLIENT_NANJING_3 = 732,
    JOSEPH_DEVICE_JIPNC_NANJING_3 = 733,
    JOSEPH_DEVICE_JSTORE_NANJING_3= 734,
    JOSEPH_DEVICE_JVRS_NANJING_3 =735,
    
    //*****************nanjing 4**************************
    JOSEPH_DEVICE_JSS_NANJING_4 = 741,
    JOSEPH_DEVICE_JCLIENT_NANJING_4 = 742,
    JOSEPH_DEVICE_JIPNC_NANJING_4 = 743,
    JOSEPH_DEVICE_JSTORE_NANJING_4= 744,
    JOSEPH_DEVICE_JVRS_NANJING_4 =745,
    
    //*****************nanjing 5**************************
    JOSEPH_DEVICE_JSS_NANJING_5 = 751,
    JOSEPH_DEVICE_JCLIENT_NANJING_5 = 752,
    JOSEPH_DEVICE_JIPNC_NANJING_5 = 753,
    JOSEPH_DEVICE_JSTORE_NANJING_5= 754,
    JOSEPH_DEVICE_JVRS_NANJING_5 =755,
    
    //*****************reserved 1**************************
    JOSEPH_DEVICE_JSS_RESERVED_1 = 811,
    JOSEPH_DEVICE_JCLIENT_RESERVED_1 = 812,
    JOSEPH_DEVICE_JIPNC_RESERVED_1 = 813,
    JOSEPH_DEVICE_JSTORE_RESERVED_1= 814,
    JOSEPH_DEVICE_JVRS_RESERVED_1 =815,
    
    //*****************reserved 2**************************
    JOSEPH_DEVICE_JSS_RESERVED_2 = 821,
    JOSEPH_DEVICE_JCLIENT_RESERVED_2 = 822,
    JOSEPH_DEVICE_JIPNC_RESERVED_2 = 823,
    JOSEPH_DEVICE_JSTORE_RESERVED_2= 824,
    JOSEPH_DEVICE_JVRS_RESERVED_2 =825,
    
    //*****************reserved 3**************************
    JOSEPH_DEVICE_JSS_RESERVED_3 = 831,
    JOSEPH_DEVICE_JCLIENT_RESERVED_3 = 832,
    JOSEPH_DEVICE_JIPNC_RESERVED_3 = 833,
    JOSEPH_DEVICE_JSTORE_RESERVED_3= 834,
    JOSEPH_DEVICE_JVRS_RESERVED_3 =835,
    
    //*****************reserved 4**************************
    JOSEPH_DEVICE_JSS_RESERVED_4 = 841,
    JOSEPH_DEVICE_JCLIENT_RESERVED_4 = 842,
    JOSEPH_DEVICE_JIPNC_RESERVED_4 = 843,
    JOSEPH_DEVICE_JSTORE_RESERVED_4= 844,
    JOSEPH_DEVICE_JVRS_RESERVED_4 =845,
    
    //*****************reserved 5**************************
    JOSEPH_DEVICE_JSS_RESERVED_5 = 851,
    JOSEPH_DEVICE_JCLIENT_RESERVED_5 = 852,
    JOSEPH_DEVICE_JIPNC_RESERVED_5 = 853,
    JOSEPH_DEVICE_JSTORE_RESERVED_5= 854,
    JOSEPH_DEVICE_JVRS_RESERVED_5 =855,
    
    //**************************************************
    JOSEPH_DEVICE_TYPE_NULL	= -1
} ;

#endif
