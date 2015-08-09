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

@end
