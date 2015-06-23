//
//  QYFile.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/17.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  千衍文件
 *  描述:
 *      一个modle，用于参与jpro文件的各个部分。
 *  需求:
 *      1.name
 *      2.remoteUrl
 *      3.localUrl
 *      4.文件是否应该上传
 *      5.文件是否应该被下载
 *  功能:
 *      1.
 *
 *  应用场景:
 *      1.QYUser生成的temp.xml
 *      2.QYUser的remoteUrl+localUrl-->下载并生成-->obj
 */
@interface QYFile : NSObject

#pragma mark - 

+ (instancetype)fileWithRemoteUrl:(NSString *)url ;

+ (instancetype)fileWithLoacalUrl:(NSString *)url ;

/*!
 Creates a file with given data and name.
 @param name The name of the new AVFile.
 @param data The contents of the new AVFile.
 @return A AVFile.
 */
+ (instancetype)fileWithName:(NSString *)name
                        data:(NSData *)data ;


/*!
 Creates a file with the contents of another file.
 @param name The name of the new AVFile
 @param path The path to the file that will be uploaded to AVOS Cloud
 */
+ (instancetype)fileWithName:(NSString *)name
              contentsAtPath:(NSString *)path ;

#pragma mark - property

/*!
 The name of the file.
 */
@property (readonly) NSString *name ;

/*!
 The url of the file.
 */
@property (readonly) NSString *url ;

/*!
 Whether the file has been uploaded for the first time.
 */
@property (readonly) BOOL isDirty ;

/*!
 File metadata, caller is able to store additional values here.
 */
@property (readwrite, strong) NSMutableDictionary * metaData ;

/*!
 Whether the data is available in memory or needs to be downloaded.
 */
@property (readonly) BOOL isDataAvailable ;

/*!
 Gets the data from cache if available or fetches its contents from the AVOS Cloud
 servers.
 @return The data. Returns nil if there was an error in fetching.
 */
- (NSData *)getData ;

@end