//
//  OnlyButtonTableViewCell.m
//  TableViewTest
//
//  Created by WardenAllen on 15/5/24.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "OnlyButtonTableViewCell.h"

@implementation OnlyButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
