//
//  QY_FileService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QY_FileService : NSObject

#pragma mark - operation 

+ (BOOL)saveAvatar:(UIImage *)avatar forUserId:(NSString *)userId ;

+ (UIImage *)getAvatarByUserId:(NSString *)userId ;

+ (BOOL)saveCameraThumbnail:(UIImage *)image forCameraId:(NSString *)cameraId ;

+ (UIImage *)getCameraThumbnailByCameraId:(NSString *)cameraId ;

+ (NSString *)getAlertMessageVideoDirPath ;

+ (NSURL *)getAlertMessageVideoDirUrl;

#pragma mark - old

/**
 *  检查是否存在用户专用文件夹，不存在就创建用户的专属文件夹。
 *  Usage : 1.用户注册成功时使用
 *          2.用户登录获取到userId后检查
 *
 *  @param userId 用户Id
 *
 *  @return 是否创建成功
 */
+ (BOOL)createFolderForUser:(NSString *)userId ;

#pragma mark - Save File

/**
 *  保存文件到指定路径，指定文件名，文件扩展名，文件NSData数据
 *
 *  @param ath   path = @"AppRootPath/userId/path"
 *  @param fileName  文件名 @"profile"
 *  @param extension 文件扩展名 @"xml"
 *  @param data
 *
 *  @return 结果
 */
+ (BOOL)saveFileAtDirPath:(NSString *)path FileName:(NSString *)fileName FileExtension:(NSString *)extension Data:(NSData *)data ;

/**
 *  上述方法的变种，文件名和扩展名一起提供
 *  @param fullFileName @"fileName.extension"
 */
+ (BOOL)saveFileAtDirPath:(NSString *)path FileNameWithExtension:(NSString *)fullFileName Data:(NSData *)data ;


+ (BOOL)saveFileAtPath:(NSString *)pathWithFileNameAndFileExtension Data:(NSData *)data ;


#pragma mark - remove file to another path 

/**
 *  移动文件到另一个地方
 *
 *  @param oldPath 旧地址
 *  @param newPath 新地址
 *
 *  @return 成功失败
 */
+ (BOOL)removeFileFrom:(NSString *)oldPath To:(NSString *)newPath ;

#pragma mark - Read File 

/**
 *  获取文本数据
 *
 *  @param path 完整路径
 */
+ (NSString *)getTextContentAtPath:(NSString *)path ;

/**
 *  获取图片数据
 *
 *  @param path 完整路径
 */
+ (UIImage *)getImageDataAtPath:(NSString *)path ;




#pragma mark - path format methods

/**
 *  获取一个临时文件路径
 */
+ (NSString *)getTempPath ;

/**
 *  获取沙盒下Documentation路径
 *
 *  @return sandBox/document/
 */
+ (NSString *)getDocPath ;

/**
 *  获取沙盒下Cache路径
 *
 *  @return sandBox/Cache/
 */
+ (NSString *)getCachePath ;

/**
 *  获取沙盒下User路径
 *
 *  @return sandBox/document/user
 */
+ (NSString *)getUserPath ;

/**
 *  获取分配给单独user的一个文件夹
 *
 *  @param userId QY用户系统的userId
 *
 *  @return sandBox/document/user/userId
 */
+ (NSString *)getUserPathByUserId:(NSString *)userId ;

/**
 *  获取沙盒下Camera的路径
 *
 *  @return sandBox/document/camera
 */
+ (NSString *)getCameraPath ;

/**
 *  获取分配给单独camera的一个文件夹
 *
 *  @param cameraId QY相机系统的cameraId
 *
 *  @return sandBox/document/camera/cameraId
 */
+ (NSString *)getCameraPathByCameraId:(NSString *)cameraId ;

/**
 *  给制定路径添加后缀名
 *
 *  @param filePath
 *  @param extension 扩展名
 *
 *  @return @"filePaht.extension"
 */
+ (NSString *)addPathExtensionForPath:(NSString *)filePath WithExtension:(NSString *)extension ;

#pragma mark - 验证

/**
 *  检查路径URL,返回True时，能够写入
 */
+ (BOOL)checkFileURL:(NSURL *)fileURL ;

/**
 *  检查路径文件,返回True时，能够写入
 */
+ (BOOL)checkFilePath:(NSString *)filePath ;

/**
 *  检查路径文件夹,返回True时，能够写入
 */
+ (BOOL)checkFileDir:(NSString *)fileDir ;


#pragma mark -

/**
 *  获取NSFileManager单例
 */
+ (NSFileManager *)fileManager ;

@end