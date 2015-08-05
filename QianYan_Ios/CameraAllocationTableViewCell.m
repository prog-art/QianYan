//
//  CameraAllocationTableViewCell.m
//  相机分配
//
//  Created by WardenAllen on 15/8/4.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "CameraAllocationTableViewCell.h"

@interface CameraAllocationTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UISwitch *cellSwitch;

@end

@implementation CameraAllocationTableViewCell

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)setIsAllowed:(BOOL)isAllowed {
    _cellSwitch.on = isAllowed;
}

- (BOOL)isAllowed {
    return _cellSwitch.on;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
