//
//  QY_jclient_jrm_protocol_Marco.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_jclient_jrm_protocol_Marco_h
#define QianYan_Ios_QY_jclient_jrm_protocol_Marco_h

#define DEVICE_TYPE_SIZE 4
#define DEVICE_PASSWD_SIZE 32
#define DEVICE_ID_SIZE 16
#define USERID_SIZE 16
#define USERNAME_SIZE 32
#define USEREMAIL_SIZE 32

#define USERPWD_SIZE 32
#define USER_GENDER_SIZE 8
#define NICKNAME_SIZE 32
#define IP_MEM_SIZE 16
#define PORT_MEM_SIZE 8
#define MEDIA_SUB_SIZE 32
#define LOCATION_SIZE 64
#define USER_SIGN_SIZE 128
#define SCULPTURE_NAME_SIZE 128

#define USER_VERIFY_SIZE 16
#define JIPNC_INJSS_STREAM_ADDR_LEN 30
#define MAX_SINGLE_DATA_SIZE 128

typedef NS_ENUM(NSInteger, JOSEPH_DEVICE_TYPE) {
    JOSEPH_DEVICE_JDAS = 1,
    JOSEPH_DEVICE_JRM = 10,
    JOSEPH_DEVICE_JSS = 20,
    JOSEPH_DEVICE_JCLIENT = 30,
    JOSEPH_DEVICE_JIPNC = 130,
    JOSEPH_DEVICE_JVRS = 300,
    JOSEPH_DEVICE_TYPE_NULL	= -1
} ;

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
    
    
    //JIPNC
    JIPNC_REQUEST_JSS = 30,
    JIPNC_REPORT_VERSION,
    JIPNC_ADD_MY_OWNER,
    
    
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
    
    
    JSTORE_REPORT_JSTORE = 80,
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
    
    JCLIENT_ADD_MY_OWN_IPNC = 461,
    JCLIENT_DEL_MY_OWN_IPNC,
    
    JCLIENT_GET_USER_ID_BY_PHONE = 470,
    JCLIENT_GET_USER_ID_BY_EMAIL = 471,
    
    JCLIENT_FIND_PASSWARD_BY_EMAIL = 480,
    //JCLIENT_FIND_PASSWARD_BY_PHEONE = 481,
    JCLIENT_VERIFY_USER_BY_EMAIL = 482,
    JCLIENT_GET_OLD_USER_SERIES = 483,
    JCLIENT_GET_NEW_USER_SERIES = 484,
    
    JCLIENT_IPNC_SHARE_FOR_FRIEND_LIST = 490,
    
    // reserved
    JOSEPH_COMMAND_OK=65500,
    JOSEPH_COMMAND_ERR,
    JOSEPH_COMMAND_NULL
};

#endif