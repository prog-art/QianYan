//
//  SwitchTableViewCell.m
//  TB
//
//  Created by WardenAllen on 15/5/23.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end

@implementation SwitchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = title;
    
}

@end
