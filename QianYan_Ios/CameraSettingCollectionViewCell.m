//
//  CameraSettingsCollectionViewCell.m
//  摄像机权限管理
//
//  Created by WardenAllen on 15/6/27.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "CameraSettingCollectionViewCell.h"

@interface CameraSettingCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation CameraSettingCollectionViewCell

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setLocation:(NSString *)location {
    _locationLabel.text = location;
}

- (NSString *)location {
    return _locationLabel.text;
}

- (void) setType:(NSString *)type {
    if ([type isEqualToString:@"公开"]) {
        _typeImageView.image = [UIImage imageNamed:@"权限管理-公开.png"];
        _typeLabel.text = @"公开";
    } else if ([type isEqualToString:@"秘密"]) {
        _typeImageView.image = [UIImage imageNamed:@"权限管理-秘密.png"];
        _typeLabel.text = @"秘密";
    } else {
        _typeImageView.image = [UIImage imageNamed:@"权限管理-shared.png"];
        _typeLabel.text = @"";
    }
}

- (NSString *)type {
    if (_typeLabel.text) {
        return _typeLabel.text;
    } else {
        return @"分享";
    }
}



@end
