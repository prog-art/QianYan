//
//  QY_Image_configure_cmd.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_Image_configure_cmd_h
#define QianYan_Ios_QY_Image_configure_cmd_h


/*Image configure cmd*/


#define IMAGE_QUALITY_CONF  240
//图像质量配置 （0-100,default 50）;
#define IMAGE_QUALITY_CONF_ACK  241 
//ACK
#define IMAGE_QUALITY_READ  242 
//图像质量读 ;
#define IMAGE_QUALITY_READ_ACK  243  
//图像质量配置ACK（0-100,default 50）;

#define IMAGE_BRITNESS_CONF   250 
//图像亮度配置 (0-100.default 50)luma
#define IMAGE_BRITNESS_CONF_ACK   251 
//ACK
#define IMAGE_BRITNESS_READ   252 
//图像亮度读
#define IMAGE_BRITNESS_READ_ACK   253
//图像亮度配置ACK(0-100,)luma

#define IMAGE_CONTRAST_CONF   260 
//图像对比度 （0-100,default 50）contr；
#define IMAGE_CONTRAST_CONF_ACK    261 
//ACK
#define IMAGE_CONTRAST_READ   262 
//图像对比度READ
#define IMAGE_CONTRAST_READ_ACK    263 
//图像对比度ACK（0-100,default 50）contr

#define IMAGE_SATURATION_CONF 270 
//图像饱和度配置 (0-100,default 50)satu
#define IMAGE_SATURATION_CONF_ACK  271
//ACK
#define IMAGE_SATURATION_READ 272 
//图像饱和度读
#define IMAGE_SATURATION_READ_ACK  273
//图像饱和度配置ACK(0-100)satu

#define IMAGE_CHROMA_CONF  280 
//图像色度配置 (0-100,default 50)hue
#define IMAGE_CHROMA_CONF_ACK  281  
//ACK
#define IMAGE_CHROMA_READ  282 
//图像色度读
#define IMAGE_CHROMA_READ_ACK  283 
//图像色度ACK(0-100)hue

/*自动白平衡还为做*/
#define IMAGE_WHITE_BALANCE_AUTO  290 
//自动白平衡（开或关）
#define IMAGE_WHITE_BALANCE_AUTO_ACK  291
#define IMAGE_WHITE_BALANCE_READ  292 
//自动白平衡读取
#define IMAGE_WHITE_BALANCE_READ_ACK  293 
//自动白平衡ACK（开或关）

#define IMAGE_EXPOSURE_TIME 300 
//图像曝光时间 （1／5，1／50 1／100）
#define IMAGE_EXPOSURE_TIME_ACK 301 
//图像曝光时间ACK（1／5，1／50 1／100）
#define IMAGE_EXPOSURE_TIME_READ 302 
//图像曝光时间读取
#define IMAGE_EXPOSURE_TIME_READ_ACK 303 
//图像曝光时间ACK（1／5，1／50 1／100）

#define VIDEO_STAND_CONF    310 
//视频制式配置 （50 或 60,default 50）
#define VIDEO_STAND_CONF_ACK    311  
//视频制式配置ACK （50 或 60）
#define VIDEO_STAND_READ    312 
//视频制式读取
#define VIDEO_STAND_READ_ACK    313  
//视频制式配置ACK （50 或 60）


#define CODE_STREAM_TYPE_CONF 320
//码流类型配置 （主码流（720p 不可设）、子码流,default VGA(7)）
#define CODE_STREAM_TYPE_CONF_ACK 321  
//码流类型配置ACK(主码流（720p 不可设）、子码流）
#define CODE_STREAM_TYPE_READ 322 
//码流类型读取
#define CODE_STREAM_TYPE_READ_ACK 323  
//码流类型配置ACK(主码流（720p 不可设）、子码流）

/*分辨率（720-1280＊720、D1-704＊576、VGA-640*380、CIF-352＊288、QVGA-320＊240）*/
#define RESOLUTION_CONF  330 
//分辨率设置
#define RESOLUTION_CONF_ACK  331 
//分辨率设置ACK
#define RESOLUTION_READ  332 
//分辨率读取
#define RESOLUTION_READ_ACK  333 
//分辨率设置ACK

#define CODE_RATE_TYPE_CONF 340 
//码率类型设置（可变码率vbr）
#define CODE_RATE_TYPE_CONF_ACK  341 
//码率类型设置ACK（可变码率vbr）
#define CODE_RATE_TYPE_READ 342 
//码率类型读取
#define CODE_RATE_TYPE_READ_ACK  343 
//码率类型设置ACK（可变码率vbr）

#define FRAME_RATE_CONF   350 
//帧率配置(5-25,default 25)
#define FRAME_RATE_CONF_ACK    351 
//帧率配置ACK(5-25,)
#define FRAME_RATE_READ   352 
//帧率读取
#define FRAME_RATE_READ_ACK    353 
//帧率配置ACK(5-25,)

#define FRAME_I_INTERVAL_CONF 360 
//I_帧间隔配置：(2〜150,default 25)
#define FRAME_I_INTERVAL_CONF_ACK  361
//I_帧间隔配置ACK(2〜150)
#define FRAME_I_INTERVAL_READ 362
//I__帧间隔读取
#define FRAME_I_INTERVAL_READ_ACK  363
//I_帧间隔配置ACK(2〜150)

#define IMAGE_MIRRO_ISOPEN_CONF 390 
//水平镜像配置（打开或关闭,default close）
#define IMAGE_MIRRO_ISOPEN_CONF_ACK 391
//镜像打开配置ACK（打开或关闭）
#define IMAGE_MIRRO_ISOPEN_READ 392 
//镜像打开读取
#define IMAGE_MIRRO_ISOPEN_READ_ACK 393 
//镜像打开配置ACK（打开或关闭）

#define CODE_RATE_UPPER_CONF  400
//码率上限配置 （32-5012kbps,default 4096）(1024*3*3)
#define CODE_RATE_UPPER_CONF_ACK  401
#define CODE_RATE_UPPER_READ  402
//码率上限读取
#define CODE_RATE_UPPER_READ_ACK  403
//码率上限配置ACK（32-5012kbps）(1024*3*3)

/*重启才生效*/
#define DYA_ISOPEN_CONF 410
//动态侦测打开配置（开或关,default close）
#define DYA_ISOPEN_CONF_ACK 411
//动态侦测打开配置（开或关）提示重起生效
#define DYA_ISOPEN_READ 412
//动态侦测状态读取
#define DYA_ISOPEN_READ_ACK 413
//动态侦测打开配置ACK（开或关）


/*sounds configure cmd*/
#define IPNC_MICPHONE_ISOPEN_CONF 420 
//射像头话筒开启与否
#define IPNC_MICPHONE_ISOPEN_CONF_ACK 421  
//射像头话筒开启与否ACK
#define IPNC_MICPHONE_ISOPEN_READ 422 
//射像头话筒开启与否读取
#define IPNC_MICPHONE_ISOPEN_READ_ACK 423  
//射像头话筒开启与否ACK

#define IPNC_MICPHONE_ADJUST_SET   425  
//射像头话筒调节（0〜31）
#define IPNC_MICPHONE_ADJUST_SET_ACK 426 
//射像头话筒调节ACK(0-31)
#define IPNC_MICPHONE_ADJUST_READ  427  
//射像头话筒调节读取
#define IPNC_MICPHONE_ADJUST_READ_ACK 428 
//射像头话筒调节ACK(0-31)

#define IPNC_SEAKER_ISOPEN_CONF  430 
//射像头喇叭开起与否
#define IPNC_SEAKER_ISOPEN_CONF_ACK   431 
//射像头喇叭开起与否ACK
#define IPNC_SEAKER_ISOPEN_READ  432 
//射像头喇叭开起与否读取
#define IPNC_SEAKER_ISOPEN_READ_ACK   433 
//射像头喇叭开起与否ACK

#define IPNC_VOLUME_ADJUST_SET   440  
//射像头音量调节（0〜31）
#define IPNC_VOLUME_ADJUST_SET_ACK 441 
//射像头音量调节ACK(0-31)
#define IPNC_VOLUME_ADJUST_READ  442  
//射像头音量调节读取
#define IPNC_VOLUME_ADJUST_READ_ACK 443 
//射像头音量调节ACK(0-31)

/*alarm configure cmd*/
#define MOVE_TRIGGER_ALARM_ISOPEN_SET  450
//移动触发开启关闭
#define MOVE_TRIGGER_ALARM_ISOPEN_SET_ACK  451
//回移动触发开启关闭ACK
#define MOVE_TRIGGER_ALARM_ISOPEN_READ  452
//读移动触发开启关闭
#define MOVE_TRIGGER_ALARM_ISOPEN_READ_ACK  453
//回移动触发开启关闭ACK

#define MOVE_TRIGGER_ALARM_SENSITIVE_SET 454 
//移动触发（灵敏度 0-10）
#define MOVE_TRIGGER_ALARM_SENSITIVE_SET_ACK 455 
//移动触发读灵敏度ACK（灵敏度 0-10,default 5）
#define MOVE_TRIGGER_ALARM_SENSITIVE_READ 456 
//移动触发读灵敏度
#define MOVE_TRIGGER_ALARM_SENSITIVE_READ_ACK 457 
//移动触发读灵敏度ACK（灵敏度 0-10,default 5）

#define SOUND_TRIGGER_ALARM_ISOPEN_SET  460
//声音触发开启关闭报警 （灵敏度 0-10,default ? ）
#define SOUND_TRIGGER_ALARM_ISOPEN_SET_ACK  461
//移动触发开启关闭报警ACK（灵敏度 0-10 ）
#define SOUND_TRIGGER_ALARM_ISOPEN_READ  462
//声音触发开启关闭报警
#define SOUND_TRIGGER_ALARM_ISOPEN_READ_ACK  463
//移动触发开启关闭报警ACK（灵敏度 0-10 ）

#define SOUND_TRIGGER_ALARM_SENSITIVE_SET  464
//声音触发开启关闭报警 （灵敏度 0-10 ）
#define SOUND_TRIGGER_ALARM_SENSITIVE_SET_ACK  465
//声音触发开启关闭报警ACK （灵敏度 0-10 ）
#define SOUND_TRIGGER_ALARM_SENSITIVE_READ  466 
//声音触发开启关闭报警灵敏度读
#define SOUND_TRIGGER_ALARM_SENSITIVE_READ_ACK  467
//声音触发开启关闭报警ACK （灵敏度 0-10 ）

/*jrm 有 IPNC 没有*/
#define DEL_ALARM_INFO          1080 
//删除报警信息
#define DEL_ALARM_INFO_ACK          1081 
//删除报警信息ACK

#define LOOK_OVER_ALARM_INFO   1090 
//查看报警信息
#define LOOK_OVER_ALARM_INFO_ACK   1091 
//查看报警信ACK

/*videotape configure cmd*/
#define MOVE_TRIGGER_VIDEOTAPE_ISOPEN_SET 1100 
//移动侦测录像(开关)
#define MOVE_TRIGGER_VIDEOTAPE_ISOPEN_SET_ACK 1101 
//移动侦测录像ACK(开关）
#define MOVE_TRIGGER_VIDEOTAPE_ISOPEN_READ 1102 
//移动侦测录像读取
#define MOVE_TRIGGER_VIDEOTAPE_ISOPEN_READ_ACK 1103 
//移动侦测录像ACK(开关）

#define MOVE_TRIGGER_VIDEOTAPE_SENSITIVE_SET 1104 
//移动侦测灵敏度设置(0-10)
#define MOVE_TRIGGER_VIDEOTAPE_SENSITIVE_SET_ACK 1105 
//移动侦测灵敏度读取ACK(0-10)
#define MOVE_TRIGGER_VIDEOTAPE_SENSITIVE_READ 1106 
//移动侦测灵敏度读取
#define MOVE_TRIGGER_VIDEOTAPE_SENSITIVE_READ_ACK 1107 
//移动侦测灵敏度读取ACK(0-10)


#define SOUND_TRIGGER_VIDEOTAPE_ISOPEN_SET 1110 
//声音触发录像(开关)
#define SOUND_TRIGGER_VIDEOTAPE_ISOPEN_SET_ACK 1111 
//声音触发录像读取ACK(开关)
#define SOUND_TRIGGER_VIDEOTAPE_ISOPEN_READ 1112 
//声音触发录像读取
#define SOUND_TRIGGER_VIDEOTAPE_ISOPEN_READ_ACK 1113 
//声音触发录像读取ACK(开关)

#define SOUND_TRIGGER_VIDEOTAPE_SENSITIVE_SET 1115 
//声音触发录像 （灵敏度 0-10）
#define SOUND_TRIGGER_VIDEOTAPE_SENSITIVE_SET_ACK 1116 
//声音触发录像ACK （灵敏度 0-10）
#define SOUND_TRIGGER_VIDEOTAPE_SENSITIVE_READ 1117 
//声音触发录像读
#define SOUND_TRIGGER_VIDEOTAPE_SENSITIVE_READ_ACK 1118 
//声音触发录像ACK （灵敏度 0-10）


/*jrm 有 ipnc 无*/
#define VIDEOTAPE_PLAN 1120 
//录像计划  （未实现,暂时不做）
#define VIDEOTAPE_PLAN_ACK 1121 
//录像计划 ACK

/*The night mode switch*/
#define NIGHT_MODE_SWITCH_AT_ONCE 1130 
//切换夜间模式
#define NIGHT_MODE_SWITCH_AT_ONCE_ACK 1131 
//切换夜间模式ACK

#define DAY_MODE_SWITCH_AT_ONCE 1140   
//日间模式切换
#define DAY_MODE_SWITCH_AT_ONCE_ACK  1141  
//日间模式切换ACK

#define DAY_MODE_READ   1142
//夜间或日间模式读取
#define DAY_MODE_READ_ACK  1143
//模式应答

/*captons（未实现）*/

#define CAPTION_CH_NAME_ISOPEN  1150 
//通道开起：上左、下左、上右、下右
#define CAPTION_CH_NAME_ISOPEN_ACK  1151 
//通道开起ACK：上左、下左、上右、下右

#define CAPTIONT_TIME_ISOPEN   1160 
//时间戳：上左、下左、上右、下右
#define CAPTIONT_TIME_ISOPEN_ACK   1161 
//时间戳ACK：上左、下左、上右、下右

#define CAPTIONT_CONSUME_RENEW    1170    
//消费续费提醒：
#define CAPTIONT_CONSUME_RENEW_ACK    1171    
//消费续费提醒ACK：



/*ipnc power master*/

#define IPNC_TIMING_SHUTDOWN  1180 
//定时关机（时间:相对时间）
#define IPNC_TIMING_SHUTDOWN_ACK  1181 
//定时关机ACK
#define IPNC_TIMING_SHUTDOWN_READ  1182 
//定时关机读取
#define IPNC_TIMING_SHUTDOWN_READ_ACK  1183 
//定时关机ACK
#define IPNC_TIMING_SHUTDOWN_CANCLE 1184 
//定时关机取消
#define IPNC_TIMING_SHUTDOWN_CANCLE_ACK 1185  
//定时关机取消ACK

#define IPNC_TIMING_SHUTDOWN_AB  1186 
//定时关机（时间:绝对时间）
#define IPNC_TIMING_SHUTDOWN_AB_ACK  1187 
//定时关机读取
#define IPNC_TIMING_SHUTDOWN_AB_READ  1188 
//定时关机读取
#define IPNC_TIMING_SHUTDOWN_AB_READ_ACK  1189 
//定时关机读取

#define IPNC_TIMING_BOOT   1190   
//定时启动 （时间:相对时间）
#define IPNC_TIMING_BOOT_ACK   1191   
//定时启动ACK
#define IPNC_TIMING_BOOT_READ   1192   
//定时启动读取
#define IPNC_TIMING_BOOT_READ_ACK   1193   
//定时启动ACK
#define IPNC_TIMING_BOOT_CANCLE 1194 
//定时关机取消
#define IPNC_TIMING_BOOT_CANCLE_ACK 1195

#define IPNC_TIMING_BOOT_AB   1196   
//定时启动 （时间:绝对时间）
#define IPNC_TIMING_BOOT_AB_ACK   1197   
//定时启动读取
#define IPNC_TIMING_BOOT_AB_READ   1198   
//定时启动读取
#define IPNC_TIMING_BOOT_AB_READ_ACK   1199   
//定时启动读取


#define IPNC_TIMING_SLEEP   1200  
//定时休眠 （时间:相对时间）
#define IPNC_TIMING_SLEEP_ACK   1201  
//定时休眠ACK
#define IPNC_TIMING_SLEEP_READ   1202  
//定时休眠读取
#define IPNC_TIMING_SLEEP_READ_ACK   1203  
//定时休眠ACK
#define IPNC_TIMING_SLEEP_CANCLE   1204  
//定时休眠取消
#define IPNC_TIMING_SLEEP_CANCLE_ACK 1205  
//定时休眠取消

#define IPNC_TIMING_SLEEP_AB   1206  
//定时休眠 （时间:相对时间还是绝对时间）
#define IPNC_TIMING_SLEEP_AB_ACK   1207  
//定时休眠读取
#define IPNC_TIMING_SLEEP_AB_READ   1208  
//定时休眠读取
#define IPNC_TIMING_SLEEP_AB_READ_ACK   1209  
//定时休眠读取


/*远程启动不用*/
#define IPNC_REMOTE_BOOT   1210   
//远程启动
#define IPNC_REMOTE_BOOT_ACK   1211   
//远程启动ACK

/////////////////////////////////////////////
#define IPNC_REMOTE_SHUTDOWN  1220 
//远程关机
#define IPNC_REMOTE_SHUTDOWN_ACK  1221 
//远程关机ACK

/*先不做*/
#define IPNC_REMOTE_SLEEP   1230 
//远程休眠
#define IPNC_REMOTE_SLEEP_ACK   1231 
//远程休眠ACK

/*update firmware（未实现）*/
#define IPNC_UPDATE_FIRMWARE 1240 
//固件升级
#define IPNC_UPDATE_FIRMWARE_ACK  1241 
//固件升级ACK

/*times calibration*/
#define CUSTERM_SLECT_GMT  1250 
//用户时区选择
#define CUSTERM_SLECT_GMT_ACK  1251 
//用户时区选择ACK
#define CUSTERM_GMT_READ  1252 
//用户时区读取
#define CUSTERM_GMT_READ_ACK  1253 
//用户时区选择ACK

#define SLEEP_MODE_AUTO_CALIBRATE  1260 
//睡眠模式自动校时
#define SLEEP_MODE_AUTO_CALIBRATE_ACK 1261 
//睡眠模式自动校时ACK



#define RSET_SET      1270      
//恢复出厂设置
#define RSET_SET_ACK      1271  
//恢复出厂设置ACK

#define REBOOT_SET    1280     
//重启设置
#define REBOOT_SET_ACK    1281  
//重启设置ACK

#define IPNC_VERSION_GET 1290   
//获得版本信息
#define IPNC_VERSION_GET_ACK 1291   
//获得版本信息ACK

#define IPNC_NICKNAME_SET 1300  
//设置昵称
#define IPNC_NICKNAME_SET_ACK 1301  
//ACK
#define IPNC_NICKNAME_READ 1302 
//设置昵称读
#define IPNC_NICKNAME_READ_ACK 1303 
//ACK

#define SET_JIPNC_INFO 1310
//set ipnc id key and device_type
#define SET_JIPNC_INFO_ACK 1311  
//ACK

#define IPNC_IS_ONLINE 1340
//jclient check online
#define IPNC_IS_ONLINE_ACK 1341
//ACK

#define IPNC_UPDATA 1350
//ipnc updata cmd
#define IPNC_UPDATA_ACK 1351
//ACK

#define IPNC_GET_PREV_PIC 1360
// get ipnc preview
#define IPNC_GET_PREV_PIC_ACK 1361
//get ipnc replay
#define IPNC_PLAY_AUDIO 1365
#define IPNC_PLAY_AUDIO_ACK 1366

#define JOSEPH_ALARM_MESSAGE 1370
//alarm message send to owner

#define IPNC_LED_SET_STATUS 1380
//set ipnc led
#define IPNC_LED_SET_STATUS_ACK 1381
//set ipnc led
#define IPNC_LED_READ_STATUS 1382
//get ipnc led
#define IPNC_LED_READ_STATUS_ACK 1383
//ack

#define IPNC_RESTART_AV 1390
//restart av_server 设置修改重启相机
#define IPNC_RESTART_AV_ACK 1391
//ACK

#define IPNC_TELNET_OPEN_CLOSE 1400
// open and close TELNET
#define IPNC_TELNET_OPEN_CLOSE_ACK 1401
//ACK

#define IPNC_TELNET_READ_STATUS 1402
//get telnet status
#define IPNC_TELNET_READ_STATUS_ACK 1403
//ACK

#define IPNC_LIGHT_OPEN_CLOSE 1410
// open and close light
#define IPNC_LIGHT_OPEN_CLOSE_ACK 1411
//ACK
#define IPNC_LIGHT_READ 1420
// read light
#define IPNC_LIGHT_READ_ACK 1421
//ACK

#define IPNC_SET_A_STREAM_STATUS 1430
// set audio stream opend or closed
#define IPNC_SET_A_STREAM_STATUS_ACK 1431
//ACK
#define IPNC_READ_A_STREAM_STATUS 1440
// read audio strem status
#define IPNC_READ_A_STREAM_STATUS_ACK 1441
//ACK

#endif
