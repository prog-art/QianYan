//
//  CameraSettingCollectionReusableView.m
//  摄像机权限管理
//
//  Created by WardenAllen on 15/6/27.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "CameraSettingCollectionReusableView.h"

@interface CameraSettingCollectionReusableView ()

@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation CameraSettingCollectionReusableView

- (void)setTitle:(NSString *)title {
    _headerTitleLabel.text = title;
}

- (NSString *)title {
    return _headerTitleLabel.text;
}

@end
