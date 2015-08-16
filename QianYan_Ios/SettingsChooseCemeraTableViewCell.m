//
//  SettingsChooseCemeraTableViewCell.m
//  选择相机
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SettingsChooseCemeraTableViewCell.h"

@interface SettingsChooseCemeraTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *cameraImageView;

@property (strong, nonatomic) IBOutlet UILabel *cameraNameLabel;

@end

@implementation SettingsChooseCemeraTableViewCell

- (void) setCameraImage:(UIImage *)cameraImage {
    self.cameraImageView.image = cameraImage;
}

- (UIImage *)cameraImage {
    return self.cameraImageView.image;
}

- (void)setCameraName:(NSString *)cameraName {
    self.cameraNameLabel.text = cameraName;
}

- (NSString *)cameraName {
    return self.cameraNameLabel.text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
