//
//  QY_camera.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_camera.h"
#import "QY_cameraGroup.h"
#import "QY_cameraSetting.h"
#import "QY_user.h"

#import "QY_appDataCenter.h"
#import "QY_Common.h"
#import "QY_XMLService.h"
#import "QY_JMS.h"
#import <UIKit/UIKit.h>

@implementation QY_camera

@dynamic cameraId;
@dynamic cameraPassword;
@dynamic jpro;
@dynamic jssId;
@dynamic jssIp;
@dynamic jssPassword;
@dynamic jssPort;
@dynamic status;
@dynamic inGroups;
@dynamic owner;
@dynamic shareUser;
@dynamic inSettings;

+ (instancetype)camera {
    return (id)[QY_appDataCenter insertObjectForName:NSStringFromClass(self)] ;
}

+ (QY_camera *)findCameraById:(NSString *)cameraId {
    assert(cameraId) ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cameraId = %@",cameraId] ;
    QY_camera *camera = (QY_camera *)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    return camera ;
}

+ (QY_camera *)insertCameraById:(NSString *)cameraId {
    if ( !cameraId ) return nil ;
    
    QY_camera *camera = [self findCameraById:cameraId] ;
    
    if ( !camera ) {
        //没有就创建一个
        camera = [QY_camera camera] ;
        camera.cameraId = cameraId ;
    }
    return camera ;
}

- (void)initWithXmlStr:(NSString *)xmlStr {
    NSError *error ;
    [QY_XMLService initCamera:self withProfileXMLStr:xmlStr error:&error] ;
}

#pragma mark - 远端服务器

- (void)fetchCameraInfoComplection:(QYObjectBlock)complection {
    assert(complection) ;
    
    NSString *path = [QY_JPROUrlFactor pathForCameraProfile:self.cameraId] ;
    
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:path complection:^(NSString *xmlStr, NSError *error) {
        if ( xmlStr ) {
            [self initWithXmlStr:xmlStr] ;
            complection(self,nil) ;
        } else {
            complection(nil,error) ;
        }
    }] ;
}

- (void)displayCameraThumbnailAtImageView:(UIImageView *)imageView useCache:(BOOL)useCache {
    if ( !imageView ) return ;

    UIImage *cachedImage = [[QY_CacheService shareInstance] getImageByCameraId:self.cameraId] ;
    
    UIImage *placeHoderImage = cachedImage ? :[UIImage imageNamed:@"相机分组-子图片1.png"] ;
    [imageView setImage:placeHoderImage] ;
    if ( !useCache ) {
        //不用缓存
        QYDebugLog(@"不用缓存，去请求") ;
        [[QY_JMSService shareInstance] getCameraThumbnailById:self.cameraId complection:^(NSData *imageData , NSError *error) {
            if ( imageData ) {
                UIImage *image = [UIImage imageWithData:imageData] ;
                [[QY_CacheService shareInstance] cacheImage:image forCameraId:self.cameraId] ;
                [QYUtils runInMainQueue:^{
                    [imageView setImage:image] ;
                }] ;
            } else {
                QYDebugLog(@"无缩略图或获取缩略图失败 error = %@",error) ;
            }
        }] ;
        return ;
    }
}

@end
