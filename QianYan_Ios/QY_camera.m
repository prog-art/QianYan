//
//  QY_camera.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_camera.h"
#import "QY_cameraGroup.h"
#import "QY_user.h"
#import "QY_appDataCenter.h"

@implementation QY_camera

@dynamic cameraId;
@dynamic cameraPassword;
@dynamic jpro;
@dynamic jssId;
@dynamic jssIp;
@dynamic jssPassword;
@dynamic jssPort;
@dynamic status;
@dynamic owner;
@dynamic shareUser;
@dynamic inGroups;

+ (instancetype)camera {
    QY_camera *camera = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    return camera ;
}

+ (QY_camera *)findCameraById:(NSString *)cameraId {
    assert(cameraId) ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cameraId = %@",cameraId] ;
    QY_camera *camera = (QY_camera *)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;    
    return camera ;
}

@end
