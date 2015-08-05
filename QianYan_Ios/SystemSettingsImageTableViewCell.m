//
//  SystemSettingsImageTableViewCell.m
//  设置
//
//  Created by WardenAllen on 15/7/11.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SystemSettingsImageTableViewCell.h"

@interface SystemSettingsImageTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation SystemSettingsImageTableViewCell

@synthesize imageView;

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
