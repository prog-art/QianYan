//
//  AccountInfoTableViewCell.m
//  账号信息
//
//  Created by WardenAllen on 15/6/9.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "AccountInfoTableViewCell.h"

@interface AccountInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation AccountInfoTableViewCell

- (NSString *)leftLabelText {
    return _leftLabel.text;
}

- (void)setLeftLabelText:(NSString *)leftLabelText {
    _leftLabel.text = leftLabelText;
}

- (NSString *)rightLabelText {
    return _rightLabel.text;
}

- (void)setRightLabelText:(NSString *)rightLabelText {
    _rightLabel.text = rightLabelText;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
