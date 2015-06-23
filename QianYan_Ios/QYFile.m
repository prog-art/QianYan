//
//  QYFile.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/17.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QYFile.h"

@interface QYFile ()

/*!
 The name of the file.
 */
@property (readwrite) NSString *name ;

/*!
 The url of the file.
 */
@property (readwrite) NSString *url ;

/*!
 Whether the file has been uploaded for the first time.
 */
@property (readwrite) BOOL isDirty ;


/*!
 Whether the data is available in memory or needs to be downloaded.
 */
@property (readwrite) BOOL isDataAvailable ;

@end


@implementation QYFile

+ (instancetype)fileWithRemoteUrl:(NSString *)url {
    return nil ;
}

+ (instancetype)fileWithLoacalUrl:(NSString *)url {
    return nil ;
}

/*!
 Creates a file with given data and name.
 @param name The name of the new AVFile.
 @param data The contents of the new AVFile.
 @return A AVFile.
 */
+ (instancetype)fileWithName:(NSString *)name
                        data:(NSData *)data {
    return nil ;
}

/*!
 Creates a file with the contents of another file.
 @param name The name of the new AVFile
 @param path The path to the file that will be uploaded to AVOS Cloud
 */
+ (instancetype)fileWithName:(NSString *)name
              contentsAtPath:(NSString *)path {
    
    return nil ;
}

#pragma mark -

- (NSData *)getData {
    return nil ;
}

@end