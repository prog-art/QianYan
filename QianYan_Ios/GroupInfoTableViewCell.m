//
//  GroupInfoTableViewCell.m
//  删除群组成员
//
//  Created by WardenAllen on 15/8/14.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "GroupInfoTableViewCell.h"

@interface GroupInfoTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation GroupInfoTableViewCell

- (void)setUp {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 20)];
    [self.titleLabel setTextColor:[UIColor lightGrayColor]];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 12, 200, 20)];
    [self.contentLabel setTextColor:[UIColor darkGrayColor]];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setContent:(NSString *)content {
    self.contentLabel.text = content;
}

- (NSString *)content {
    return self.contentLabel.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
