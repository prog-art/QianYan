//
//  QY_JPROHttpService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JPROHttpService.h"

#import "QY_Common.h"

#import "QY_FileService.h"

#import "QY_JPROUrlFactor.h"

/**
 *  超文本标记语言文本 .html,.html text/html
 *  普通文本 .txt text/plain
 *  RTF文本 .rtf application/rtf
 *  GIF图形 .gif image/gif
 *  JPEG图形 .ipeg,.jpg image/jpeg
 *  au声音文件 .au audio/basic
 *  MIDI音乐文件 mid,.midi audio/midi,audio/x-midi
 *  RealAudio音乐文件 .ra, .ram audio/x-pn-realaudio
 *  MPEG文件 .mpg,.mpeg video/mpeg
 *  AVI文件 .avi video/x-msvideo
 *  GZIP文件 .gz application/x-gzip
 *  TAR文件 .tar application/x-tar
 */

#define MIMETYPE_TEXTXML @"multipart/form-data"

#define DOWNLOAD_BASEURL(host,port,userId) [NSString stringWithFormat:@"http://%@:%@/archives/user/%@/profile.xml",host,port,userId]
#define UPLOAD_BASEURL(host,port,userId) [NSString stringWithFormat:@"http://%@:%@/files/upload/?path=user/%@/profile.xml",host,port,userId]



@implementation QY_JPROHttpService

#pragma mark - 下载 2.1.2 

//档案下载接口 GET http://qycam.com:50551/archives/user/"userId"/profile.xml

+ (void)downLoadTest {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]  initWithSessionConfiguration:config] ;
    NSString *urlStr = DOWNLOAD_BASEURL(@"qycam.com", @"50060", @"10000133") ;
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    NSURL *url = [NSURL URLWithString:urlString] ;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //指定下载文件保存的路径
        NSString *cacheDir = [QY_FileService getUserPathByUserId:@"10000133"] ;
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename] ;
        QYDebugLog(@"cacheDir = %@",cacheDir) ;
        {
            //检查路径文件夹
            BOOL isDir = YES ;
            if ( ![[NSFileManager defaultManager] fileExistsAtPath:cacheDir isDirectory:&isDir]) {
                NSError *error ;
                [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error] ;
                if ( error ) {
                    QYDebugLog(@"创建文件夹失败") ;
                    return nil ;
                }
                QYDebugLog(@"创建文件夹成功") ;
            }
        }
        
        {
            //检路径文件存在与否
            BOOL isDir = NO ;
            if ( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
                NSError *error ;
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error] ;
                
                if ( error ) {
                    QYDebugLog(@"原路径存在文件,尝试移除失败") ;
                    return nil ;
                }
                QYDebugLog(@"愿路径存在文件，移除成功") ;
            }
        }

        NSURL *fileURL = [NSURL fileURLWithPath:path] ;
        return fileURL ;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        QYDebugLog(@"filePath = %@\n error = %@",filePath,error) ;
        
        QYDebugLog(@"fileExists? = %@",[[QY_FileService fileManager] fileExistsAtPath:[filePath path]] ? @"存在" : @"不存在") ;

        QYDebugLog(@"file content = %@",[QY_FileService getTextContentAtPath:[filePath path]]) ;
    }] ;
    
    [task resume] ;
    
}

+ (void)uploadTest {
    {
        //create temp file ;
        NSURL *fileUrl = [NSURL fileURLWithPath:[QY_FileService getTempPath]] ;;
        {
            BOOL isDir = YES ;
            if ( ![[QY_FileService fileManager] fileExistsAtPath:[fileUrl path] isDirectory:&isDir] ) {
                NSError *error ;
                [[QY_FileService fileManager] createDirectoryAtPath:[fileUrl path] withIntermediateDirectories:YES attributes:nil error:&error] ;
                
                if ( error ) {
                    QYDebugLog(@"创建出错") ;
                    return ;
                }
                QYDebugLog(@"创建成功") ;
            }
        }
        
        {
            NSString *filePath = [fileUrl path] ;
            filePath = [filePath stringByAppendingPathComponent:@"temp.xml"] ;
            
            NSString *testStr = @"<?xml version='1.0' encoding='utf-8'?>\n<user id=\"10000133\"><username>liucw2</username><nickname>liucw2</nickname><location>中国</location></user>" ;
            
            NSError *error ;
            [testStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error] ;
            
            if ( error ) {
                QYDebugLog(@"写入文件失败") ;
                return ;
            }
            QYDebugLog(@"写入文件成功") ;
        }
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;

    
//    NSString *urlStr = UPLOAD_BASEURL(@"qycam.com", @"50060", @"10000133") ;
//    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
//    #define UPLOAD_BASEURL(host,port,userId) [NSString stringWithFormat:@"http://%@:%@/files/upload/?path=user/%@/profile.xml",host,port,userId]
    NSString *baseUrl = @"http://jdas.qycam.com:50060/files/upload/" ;
    NSDictionary *paramteters = @{@"path":@"user/10000133/profile.xml"} ;
    
    QYDebugLog(@"开始测试上传 \nbaseUrl = %@ \n para = %@",baseUrl,paramteters) ;
    
//    NSURL *url = [NSURL URLWithString:urlString] ;
    [manager POST:baseUrl parameters:paramteters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *fileUrl = [NSURL fileURLWithPath:[QY_FileService getTempPath]] ;;
        
        BOOL isDir = FALSE ;
        if ([[QY_FileService fileManager] fileExistsAtPath:fileUrl.path isDirectory:&isDir] ) {
            QYDebugLog(@"文件存在！") ;
        } ;
        
        NSError *error ;
        [formData appendPartWithFileURL:fileUrl
                                     name:@"temp.xml"
                                 fileName:@"profile.xml"
                                 mimeType:MIMETYPE_TEXTXML
                                    error:&error] ;
        if ( error ) {
            QYDebugLog(@"error = %@",error) ;
        }
        QYDebugLog(@"appendPart没有错误") ;
          
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success responseObj = \n %@",responseObject) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"faild error = \n %@",error) ;
        
    }] ;
    
}

#pragma mark - 上传 2.1.1 

//档案上传接口 POST http://qycam.com:50551/files/upload/?path=user/"userId"/profile.xml

+ (void)upLoadUserProfileWithHost:(NSString *)host
                             Port:(NSString *)port
                          FileUrl:(NSURL *)fileUrl
                         Successe:(QY_AFSuccessBlock)success                                Fail:(QY_AFFailBlock)fail{
    NSString *urlStr = @"" ;
    
    [self postUploadWithUrl:urlStr
                    fileUrl:fileUrl
                   fileName:@"profile.xml"
                   fileType:@"text/xml"
                   Successe:success
                       Fail:fail] ;
}

#pragma mark - 删除 2。1.3 

//档案（目录）删除接口 GET http://qycam.com:50551/files/clear/?path=user/"userId"/

#pragma mark - 列表获取 2.1.4

//档案目录列表获取借口 GET http://qycam.com:50551/files/list?path=user/"userId"/friendlist

#pragma mark - Private


/**
 *  上传文件到指定url
 *
 *  @param urlStr   目标url
 *  @param fileUrl  文件url
 *  @param fileName 文件名
 *  @param fileType 文件类型
 *  @param success  成功回调
 *  @param fail     失败回调
 */
+ (void)postUploadWithUrl:(NSString *)urlStr
                  fileUrl:(NSURL *)fileUrl
                 fileName:(NSString *)fileName
                 fileType:(NSString *)fileType
                 Successe:(QY_AFSuccessBlock)success
                     Fail:(QY_AFFailBlock)fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileURL:fileUrl
                                   name:@"temp.xml"
                               fileName:fileName
                               mimeType:fileType
                                  error:NULL] ;
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYDebugLog(@"成功")
        if ( success ) {
            success(operation,responseObject) ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QYDebugLog(@"失败")
        if ( fail ) {
            fail(operation,error) ;
        }
        
    }] ;
    
}

/**
 *  文件下载
 *
 *  @param urlStr   服务器Url
 *  @param fileUrl  下载文件保存的url
 *  @param fileName 保存的名字
 *  @param fileType 保存的类型
 */
+ (void)downloadWith:(NSString *)urlStr
             fileUrl:(NSURL *)fileUrl
            fileName:(NSString *)fileName
            fileType:(NSString *)fileType
         complection:(QYBlock)complection{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]  initWithSessionConfiguration:config] ;
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        if ([QY_FileService checkFileURL:fileUrl])
            return fileUrl ;
          else
            return nil ;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        QYDebugLog(@"filePath = %@\n error = %@",filePath,error) ;
        
        QYDebugLog(@"fileExists? = %hhd",[[QY_FileService fileManager] fileExistsAtPath:[filePath path]]) ;
        
        QYDebugLog(@"file content = %@",[QY_FileService getTextContentAtPath:[filePath path]]) ;
        
        if ( complection ) {
            complection() ;
        }
    }] ;
    
    [task resume] ;
}

@end