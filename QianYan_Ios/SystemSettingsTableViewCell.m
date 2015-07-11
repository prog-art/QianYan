//
//  SystemSettingsTableViewCell.m
//  设置
//
//  Created by WardenAllen on 15/6/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SystemSettingsTableViewCell.h"

@interface SystemSettingsTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation SystemSettingsTableViewCell

- (void)setSettingsText:(NSString *)settingsText {
    _label.text = settingsText;
}

- (NSString *)settingsText {
    return _label.text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
