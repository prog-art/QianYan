//
//  QY_cameraSetting.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_cameraSetting.h"
#import "QY_camera.h"
#import "QY_user.h"

#import "QY_Common.h"
#import "QY_XMLService.h"

@implementation QY_cameraSetting

@dynamic nickName;
@dynamic owner;
@dynamic toCamera;

+ (QY_cameraSetting *)setting {
    return (id)[QY_appDataCenter insertObjectForName:NSStringFromClass(self)] ;
}

+ (QY_cameraSetting *)insertCameraSettingByOwnerId:(NSString *)ownerId cameraId:(NSString *)cameraId {
    if ( !ownerId || !cameraId ) return nil ;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner.userId = %@ AND toCamera.cameraId = %@",ownerId,cameraId] ;
    QY_cameraSetting *setting = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    
    if ( !setting ) {
        setting = [QY_cameraSetting setting] ;
        setting.owner = [QY_user insertUserById:ownerId] ;
        setting.toCamera = [QY_camera insertCameraById:cameraId] ;
    }

    return setting ;
}

- (void)initWithXmlStr:(NSString *)xmlStr {
    NSError *error ;
    [QY_XMLService initCameraSetting:self withCameraIdXMLStr:xmlStr error:&error] ;
}

#pragma mark - 远端服务器

- (void)fetchCameraSettingComplection:(QYObjectBlock)complection {
    assert(complection) ;
    
    NSString *path = [QY_JPROUrlFactor pathForUserCameraList:self.owner.userId CameraId:self.toCamera.cameraId] ;
    
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
