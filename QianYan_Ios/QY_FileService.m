//
//  QY_FileService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_FileService.h"

#import "QY_Common.h"

@implementation QY_FileService

#pragma mark - operation

+ (BOOL)saveAvatar:(UIImage *)avatar forUserId:(NSString *)userId {
    BOOL result = FALSE ;
    if ( !avatar || !userId ) return result ;
    
    NSString *path = [self getAvatarPathByUserId:userId] ;
    
    NSData *avatarData = UIImageJPEGRepresentation(avatar, 1.0f) ;
    if ( !avatarData ) {
        avatarData = UIImagePNGRepresentation(avatar) ;
    }
    
    result = [self saveFileAtPath:path Data:avatarData] ;
    
    return result ;
}

+ (UIImage *)getAvatarByUserId:(NSString *)userId {
    if ( !userId ) return nil ;
    return [self getImageDataAtPath:[self getAvatarPathByUserId:userId]] ;
}

+ (NSString *)getAvatarPathByUserId:(NSString *)userId {
    assert(userId) ;
    NSString *avatarDirPath = [self getAvatarPath] ;
    if ( !avatarDirPath ) return nil ;
    return [avatarDirPath stringByAppendingPathComponent:userId] ;
}

+ (NSString *)getAvatarPath {
    NSString *avatarPath = [[self getDocPath] stringByAppendingPathComponent:@"avatar"] ;
    if ( [self validateFolderForPath:avatarPath] ) return avatarPath ;
    return nil ;
}

+ (BOOL)saveCameraThumbnail:(UIImage *)image forCameraId:(NSString *)cameraId {
    BOOL result = FALSE ;
    if ( !image || !cameraId ) return result ;
    
    NSString *path = [self getCameraThumbnailPathByCameraId:cameraId] ;
    
    NSData *cameraImgData = UIImageJPEGRepresentation(image, 1.0f) ;
    if ( !cameraImgData ) {
        cameraImgData = UIImagePNGRepresentation(image) ;
    }
    
    result = [self saveFileAtPath:path Data:cameraImgData] ;
    
    return result ;
}

+ (UIImage *)getCameraThumbnailByCameraId:(NSString *)cameraId {
    if ( ( !cameraId )) return nil ;
    return [self getImageDataAtPath:[self getCameraThumbnailPathByCameraId:cameraId]] ;
}

+ (NSString *)getCameraThumbnailPathByCameraId:(NSString *)cameraId {
    assert(cameraId) ;
    NSString *imageDirPath = [self getCameraThumbnailPath] ;
    if ( !imageDirPath ) return nil ;
    return [imageDirPath stringByAppendingPathComponent:cameraId] ;
}

+ (NSString *)getCameraThumbnailPath {
    NSString *cameraThumbnailPath = [[self getDocPath] stringByAppendingPathComponent:@"cameraThumbnail"] ;
    if ( [self validateFolderForPath:cameraThumbnailPath] ) return cameraThumbnailPath ;
    return nil ;
}


/**
 *  检查头像文件夹是否存在，不存在就建一个。
 */
+ (BOOL)validateFolderForPath:(NSString *)avatarPath {
    assert(avatarPath) ;
    static BOOL result = FALSE ;
    
    if ( result ) return TRUE ;
    
    NSFileManager *manager = [self fileManager] ;
    BOOL isDir = YES ;
    if ( [manager fileExistsAtPath:avatarPath isDirectory:&isDir] == TRUE ) {
        result = YES ;
        return result ;
    }
    
    NSError *error ;
    
    [manager createDirectoryAtPath:avatarPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:&error] ;
    
    if ( error ) {
        result = FALSE ;
        QYDebugLog(@"创建文件夹失败 error = %@",error) ;
    } else {
        result = TRUE ;
    }

    return result ;
}


#pragma mark - Old

/**
 *  创建用户的专属文件夹
 *
 *  @param userId 用户Id
 *
 *  @return 是否创建成功
 */
+ (BOOL)createFolderForUser:(NSString *)userId {
    
    NSString *userFolderPath = [self getUserPathByUserId:userId] ;
    
    NSError *error ;
    BOOL isDir = YES ;
    
    NSFileManager *manager = [self fileManager] ;
    
    if ( [manager fileExistsAtPath:userFolderPath isDirectory:&isDir] == NO ) {
        //不存在就新建一个文件夹
        [manager createDirectoryAtPath:userFolderPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error] ;
        
        if ( error ) {
            QYDebugLog(@"创建文件夹失败 error = %@",error) ;
            [NSException raise:@"error when create dir" format:@"error"] ;
            return FALSE ;
        }
    }
    
    return TRUE ;
}

#pragma mark - Save File

/**
 *  保存文件到指定路径，指定文件名，文件扩展名，文件NSData数据
 *
 *  @param dirPath   dirPath = @"AppRootPath/userId/path"
 *  @param fileName  文件名 @"profile"
 *  @param extension 文件扩展名 @"xml"
 *  @param data
 *
 *  @return 结果
 */
+ (BOOL)saveFileAtDirPath:(NSString *)dirPath FileName:(NSString *)fileName FileExtension:(NSString *)extension Data:(NSData *)data {
    return [self saveFileAtDirPath:dirPath
          FileNameWithExtension:[self addPathExtensionForPath:fileName WithExtension:extension]
                           Data:data] ;
}

/**
 *  上述方法的变种，文件名和扩展名一起提供
 *  @param fullFileName @"fileName.extension"
 */
+ (BOOL)saveFileAtDirPath:(NSString *)dirPath FileNameWithExtension:(NSString *)fullFileName Data:(NSData *)data {
    NSString *filePath = [dirPath stringByAppendingPathComponent:fullFileName] ;
    return [self saveFileAtPath:filePath Data:data] ;
}

+ (BOOL)saveFileAtPath:(NSString *)pathWithFileNameAndFileExtension Data:(NSData *)data {
    NSString *filePath = pathWithFileNameAndFileExtension ;
    NSString *fileDir = [filePath stringByDeletingLastPathComponent] ;
        
    NSFileManager *manager = [NSFileManager defaultManager] ;
    
    BOOL isDir = YES ;
    if ( ![manager fileExistsAtPath:fileDir isDirectory:&isDir] ) {
        NSError *error ;
        [manager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error] ;
        
        if ( error ) {
            QYDebugLog(@"创建文件夹失败") ;
            return FALSE ;
        }
        QYDebugLog(@"创建文件夹成功") ;
    }
    
    NSError *error ;
    BOOL result = TRUE ;
    
    if ( [manager fileExistsAtPath:filePath] ) {
        result = [manager removeItemAtPath:filePath error:&error] ;
    }
    
    if ( error || result == NO ) {
        QYDebugLog(@"遇到错误,保存失败 error = %@",error) ;
        return FALSE ;
    }
    
    result = [data writeToFile:filePath atomically:YES] ;
    
    if ( result ) {
        QYDebugLog(@"保存成功") ;
    } else {
        QYDebugLog(@"保存失败") ;
    }
    
    return result ;
}

#pragma mark - remove file to another path

/**
 *  把一个文件从A移动到B(可重命名)
 *
 *  @param oldPath 旧路径
 *  @param newPath 新路径
 *
 *  @return 成功失败
 */
+ (BOOL)removeFileFrom:(NSString *)oldPath To:(NSString *)newPath {
    NSFileManager *manager = [self fileManager] ;
    
    if ( ![manager fileExistsAtPath:oldPath] ) {
        QYDebugLog(@"file not exists") ;
        return FALSE ;
    }
    
    NSString *newPathDir = [newPath stringByDeletingLastPathComponent] ;
    
    BOOL isDir = YES ;
    if ( ![manager fileExistsAtPath:newPathDir isDirectory:&isDir] ) {
        QYDebugLog(@"新路径文件不存在尝试创建") ;
        
        NSError *error ;
        [manager createDirectoryAtPath:newPathDir withIntermediateDirectories:YES attributes:nil error:&error] ;
        
        if ( error ) {
            QYDebugLog(@"尝试创建路径上文件夹失败 newPathDir = %@",newPathDir) ;
            return FALSE ;
        }
        
        QYDebugLog(@"尝试创建路径上文件夹成功newPathDir = %@",newPathDir) ;
    }
    
    if ( [manager fileExistsAtPath:newPath] ) {
        BOOL result = [manager removeItemAtPath:newPath error:NULL] ;
        if ( !result ) {
            QYDebugLog(@"新路径上存在文件，尝试删除新路径文件失败") ;
            return FALSE ;
        }
    }
    
    NSError *error ;
    BOOL result = [manager moveItemAtPath:oldPath toPath:newPath error:&error] ;
    
    if ( !error && result ) {
        QYDebugLog(@"移动成功") ;
    } else {
        QYDebugLog(@"移动失败") ;
    }
    
    return result ;
}

#pragma mark - Read File

/**
 *  获取文本数据
 *
 *  @param path 完整路径
 */
+ (NSString *)getTextContentAtPath:(NSString *)path {
    QYDebugLog(@"path = %@",path) ;
    NSError *error ;
    NSString *str = [[NSString alloc] initWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error] ;
    

    
    
    if ( error ) {
        QYDebugLog(@"error = %@",error) ;
        return nil ;
    }
    return str ;
    //第二种方式
//    NSData *data = [NSData dataWithContentsOfFile:path] ;
//    
//    NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
//    QYDebugLog(@"\n\ndata = %@\n\nstr = %@",data,str2) ;
//    
//    return str2 ;
}

/**
 *  获取图片数据
 *
 *  @param path 完整路径
 */
+ (UIImage *)getImageDataAtPath:(NSString *)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path] ;
    return image ;
}


#pragma mark - path format methods

/**
 *  获取一个临时文件路径
 */
+ (NSString *)getTempPath {
    return [[self getDocPath] stringByAppendingPathComponent:@"temp"] ;
}

/**
 *  获取沙盒下Documentation路径
 *
 *  @return @"../Library/Document"
 */
+ (NSString *)getDocPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
}

/**
 *  获取沙盒下Cache路径
 *
 *  @return sandBox/Cache/
 */
+ (NSString *)getCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] ;
}

/**
 *  获取沙盒下User路径
 *
 *  @return sandBox/document/user
 */
+ (NSString *)getUserPath {
    return [[self getDocPath] stringByAppendingPathComponent:@"user"] ;
}

/**
 *  获取给单独user的一个文件夹
 *
 *  @param userId QY用户系统的userId
 *
 *  @return @"../Library/Documentation"
 */
+ (NSString *)getUserPathByUserId:(NSString *)userId {
    if ( !userId ) {
        return @"" ;
    }
    NSString *path = [[self getUserPath] stringByAppendingPathComponent:userId] ;
    
    QYDebugLog(@"user Path = %@",path) ;
    
    return path ;
}

/**
 *  获取沙盒下Camera的路径
 *
 *  @return sandBox/document/camera
 */
+ (NSString *)getCameraPath {
    return [[self getDocPath] stringByAppendingPathComponent:@"camera"] ;
}

/**
 *  获取分配给单独camera的一个文件夹
 *
 *  @param cameraId QY相机系统的cameraId
 *
 *  @return sandBox/document/camera/cameraId
 */
+ (NSString *)getCameraPathByCameraId:(NSString *)cameraId {
    if ( !cameraId ) {
        return @"" ;
    }
    NSString *path = [[self getCameraPath] stringByAppendingPathComponent:cameraId] ;
    
    QYDebugLog(@"camera Path = %@",path) ;
    
    return path ;
}


/**
 *  给制定路径添加后缀名
 *
 *  @param filePath
 *  @param extension 扩展名
 *
 *  @return @"filePaht.extension"
 */
+ (NSString *)addPathExtensionForPath:(NSString *)filePath WithExtension:(NSString *)extension {
    return [filePath stringByAppendingPathExtension:extension] ;
}


/**
 *  生成一个UUID
 *
 *  @return 24位的UUID
 */
+ (NSString*)uuid{
    NSString *chars = @"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" ;
    assert(chars.length == 62) ;
    int len = (int)chars.length ;
    NSMutableString* result = [[NSMutableString alloc] init] ;
    for(int i = 0 ; i < 24 ; i++ ){
        int p = arc4random_uniform(len) ;
        NSRange range = NSMakeRange(p, 1) ;
        [result appendString:[chars substringWithRange:range]] ;
    }
    return result ;
}

#pragma mark - 验证

/**
 *  检查路径URL,返回True时，能够写入
 */
+ (BOOL)checkFileURL:(NSURL *)fileURL {
    if ( !fileURL ) return FALSE ;
    if ( ![fileURL isFileURL] ) return FALSE ;
    return [self checkFilePath:[fileURL path]] ;
}

/**
 *  检查路径文件,返回True时，能够写入
 */
+ (BOOL)checkFilePath:(NSString *)filePath {
    
    NSString *fileDir = [filePath stringByDeletingLastPathComponent] ;
    BOOL dirExist = [self checkFileDir:fileDir] ;
    
    if ( !dirExist ) return FALSE ;
    
    NSFileManager *manager = [self fileManager] ;
    //检路径文件存在与否
    BOOL isDir = NO ;
    if ( [manager fileExistsAtPath:filePath isDirectory:&isDir]) {
        NSError *error ;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] ;
        
        if ( error ) {
            QYDebugLog(@"原路径存在文件,尝试移除失败") ;
            return FALSE ;
        }
        QYDebugLog(@"愿路径存在文件，移除成功") ;
    }
    return TRUE ;
}

/**
 *  检查路径文件夹,返回True时，能够写入
 */
+ (BOOL)checkFileDir:(NSString *)fileDir {
    BOOL isDir = YES ;
    NSFileManager *manager = [self fileManager] ;
    if ( ![manager fileExistsAtPath:fileDir isDirectory:&isDir] ) {
        NSError *error ;
        [manager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error] ;
        if ( error ) {
            QYDebugLog(@"创建文件夹失败") ;
            return FALSE ;
        }
        QYDebugLog(@"创建文件夹成功") ;
    }
    return TRUE ;
}

/**
 *  获取NSFileManager单例
 */
+ (NSFileManager *)fileManager {
    return [NSFileManager defaultManager] ;
}

@end