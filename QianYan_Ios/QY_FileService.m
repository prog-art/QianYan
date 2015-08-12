//
//  QY_FileService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_FileService.h"

#import "QY_Common.h"

#define kUserDirPathComponent @"user"
#define kUserDirScreenShotPathComponent @"screenShot"

@implementation QY_FileService

#pragma mark - 头像

+ (BOOL)saveAvatar:(UIImage *)avatar forUserId:(NSString *)userId {
    BOOL result = FALSE ;
    if ( !avatar || !userId ) return result ;
    NSString *path = [self getAvatarPathByUserId:userId] ;
    result = [self saveImage:avatar atPath:path] ;
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
    if ( [self validateDirectoryAtPath:avatarPath] ) return avatarPath ;
    return nil ;
}

#pragma mark - 相机缩略图

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
    if ( [self validateDirectoryAtPath:cameraThumbnailPath] ) return cameraThumbnailPath ;
    return nil ;
}

#pragma mark - 报警信息

+ (NSString *)getAlertMessageVideoDirPath {
    NSString *path = [[self getDocPath] stringByAppendingPathComponent:@"alertMessageVideo"] ;
    if ( [self validateDirectoryAtPath:path] ) return path ;
    return nil ;
}

+ (NSURL *)getAlertMessageVideoDirUrl {
    NSString *path = [self getAlertMessageVideoDirPath] ;
    return path ? [NSURL fileURLWithPath:path] : nil ;
}

#pragma mark - User

/**
 *  获取沙盒下User路径
 *
 *  @return sandBox/document/user
 */
+ (NSString *)getUserPath {
    NSString *path = [[self getDocPath] stringByAppendingPathComponent:kUserDirPathComponent] ;
    if ( [self validateDirectoryAtPath:path] ) return path ;
    return nil ;
}

/**
 *  获取分配给单独user的一个文件夹
 *
 *  @param userId QY用户系统的userId
 *
 *  @return sandBox/document/user/userId
 */
+ (NSString *)getUserPathByUserId:(NSString *)userId {
    assert(userId) ;
    NSString *path = [[self getUserPath] stringByAppendingPathComponent:userId] ;
    if ( [self validateDirectoryAtPath:path] ) return path ;
    return nil ;
}

#pragma mark - 截图

+ (NSString *)getScreenShotPathForUserId:(NSString *)userId {
    NSString *path = [[self getUserPathByUserId:userId] stringByAppendingPathComponent:kUserDirScreenShotPathComponent] ;
    return path ;
}

+ (BOOL)saveScreenShotImage:(UIImage *)image forUserId:(NSString *)userId {
    BOOL result = FALSE ;
    if ( !userId || !image ) return result ;
    
    NSString *dirPath = [self getScreenShotPathForUserId:userId] ;
    
    if ( ![self validateDirectoryAtPath:dirPath] ) {
        return result ;
    }
    
    NSString *fileName,*filePath ;
    {
        NSString *dateStr = [QYUtils date2timestampStr:[NSDate date]] ;
        NSArray *tArr = @[userId,dateStr,@"screenShot"] ;
        
        fileName = [tArr componentsJoinedByString:@"_"] ;
    }
    filePath = [dirPath stringByAppendingPathComponent:fileName];
    
    QYDebugLog(@"filePath = %@",filePath) ;
    result = [self saveImage:image atPath:filePath] ;
    
    return result ;
}

+ (void)displayScreenShotImageFileName:(NSString *)fileName forUserId:(NSString *)userId atImageView:(UIImageView *)imageView {
    assert(userId) ;
    assert(fileName) ;
    assert(imageView) ;
    NSString *path = [self getScreenShotPathForUserId:userId] ;
    path = [path stringByAppendingPathComponent:fileName] ;
#warning 异步可能会导致加载慢出现问题？预留。未证实
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:path] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image ;
        }) ;
    }) ;
}

+ (NSDirectoryEnumerator *)test {
    return [[NSFileManager defaultManager] enumeratorAtPath:[self getScreenShotPathForUserId:@"10000133"]] ;
}

+ (void)test2 {
    NSString *path = [self getAvatarPath] ;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path] ;
    NSString *fileName ;
    while ( fileName = [enumerator nextObject] ) {
        NSLog(@"obj = %@",fileName) ;
    }
}


#pragma mark - Read File Helper

/**
 *  获取文本数据[UTF8]
 *
 *  @param path 完整路径
 */
+ (NSString *)getTextContentAtPath:(NSString *)path {
    NSString *text = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path]
                                           encoding:NSUTF8StringEncoding] ;
    return text ;
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

#pragma mark - SandBox path Helper

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

#pragma mark - Helper

+ (BOOL)saveImage:(UIImage *)image atPath:(NSString *)path {
    BOOL result = FALSE ;
    if ( !image || !path ) return result ;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f) ;
    QYDebugLog(@"JPEG Data!") ;
    if ( !imageData ) {
        QYDebugLog(@"PNG Data!") ;
        imageData = UIImagePNGRepresentation(image) ;
    }
    
    result = [self saveFileAtPath:path Data:imageData] ;
    
    return result ;
}

/**
 *  在路径上存储文件数据
 *
 *  @param path 完整的路径
 *  @param data 二进制数据
 *
 *  @return 保存成功还是失败
 */
+ (BOOL)saveFileAtPath:(NSString *)path Data:(NSData *)data {
    NSString *filePath = path ;
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

/**
 *  检查文件夹是否存在，不存在就新建一个。
 */
+ (BOOL)validateDirectoryAtPath:(NSString *)path {
    assert(path) ;
    static BOOL result = FALSE ;
    
    if ( result ) return TRUE ;
    
    NSFileManager *manager = [self fileManager] ;
    BOOL isDir = YES ;
    if ( [manager fileExistsAtPath:path isDirectory:&isDir] == TRUE ) {
        result = YES ;
        return result ;
    }
    
    NSError *error ;
    
    [manager createDirectoryAtPath:path
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

/**
 *  获取NSFileManager单例
 */
+ (NSFileManager *)fileManager {
    return [NSFileManager defaultManager] ;
}

//
///**
// *  把一个文件从A移动到B(可重命名)
// *
// *  @param oldPath 旧路径
// *  @param newPath 新路径
// *
// *  @return 成功失败
// */
//+ (BOOL)removeFileFrom:(NSString *)oldPath To:(NSString *)newPath {
//    NSFileManager *manager = [self fileManager] ;
//
//    if ( ![manager fileExistsAtPath:oldPath] ) {
//        QYDebugLog(@"file not exists") ;
//        return FALSE ;
//    }
//
//    NSString *newPathDir = [newPath stringByDeletingLastPathComponent] ;
//
//    BOOL isDir = YES ;
//    if ( ![manager fileExistsAtPath:newPathDir isDirectory:&isDir] ) {
//        QYDebugLog(@"新路径文件不存在尝试创建") ;
//
//        NSError *error ;
//        [manager createDirectoryAtPath:newPathDir withIntermediateDirectories:YES attributes:nil error:&error] ;
//
//        if ( error ) {
//            QYDebugLog(@"尝试创建路径上文件夹失败 newPathDir = %@",newPathDir) ;
//            return FALSE ;
//        }
//
//        QYDebugLog(@"尝试创建路径上文件夹成功newPathDir = %@",newPathDir) ;
//    }
//
//    if ( [manager fileExistsAtPath:newPath] ) {
//        BOOL result = [manager removeItemAtPath:newPath error:NULL] ;
//        if ( !result ) {
//            QYDebugLog(@"新路径上存在文件，尝试删除新路径文件失败") ;
//            return FALSE ;
//        }
//    }
//
//    NSError *error ;
//    BOOL result = [manager moveItemAtPath:oldPath toPath:newPath error:&error] ;
//
//    if ( !error && result ) {
//        QYDebugLog(@"移动成功") ;
//    } else {
//        QYDebugLog(@"移动失败") ;
//    }
//
//    return result ;
//}

///**
// *  检查路径URL,返回True时，能够写入
// */
//+ (BOOL)checkFileURL:(NSURL *)fileURL {
//    if ( !fileURL ) return FALSE ;
//    if ( ![fileURL isFileURL] ) return FALSE ;
//    return [self checkFilePath:[fileURL path]] ;
//}

///**
// *  检查路径文件,返回True时，能够写入
// */
//+ (BOOL)checkFilePath:(NSString *)filePath {
//
//    NSString *fileDir = [filePath stringByDeletingLastPathComponent] ;
//    BOOL dirExist = [self checkFileDir:fileDir] ;
//
//    if ( !dirExist ) return FALSE ;
//
//    NSFileManager *manager = [self fileManager] ;
//    //检路径文件存在与否
//    BOOL isDir = NO ;
//    if ( [manager fileExistsAtPath:filePath isDirectory:&isDir]) {
//        NSError *error ;
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] ;
//
//        if ( error ) {
//            QYDebugLog(@"原路径存在文件,尝试移除失败") ;
//            return FALSE ;
//        }
//        QYDebugLog(@"愿路径存在文件，移除成功") ;
//    }
//    return TRUE ;
//}

///**
// *  检查路径文件夹,返回True时，能够写入
// */
//+ (BOOL)checkFileDir:(NSString *)fileDir {
//    BOOL isDir = YES ;
//    NSFileManager *manager = [self fileManager] ;
//    if ( ![manager fileExistsAtPath:fileDir isDirectory:&isDir] ) {
//        NSError *error ;
//        [manager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error] ;
//        if ( error ) {
//            QYDebugLog(@"创建文件夹失败") ;
//            return FALSE ;
//        }
//        QYDebugLog(@"创建文件夹成功") ;
//    }
//    return TRUE ;
//}

@end