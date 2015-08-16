//
//  GroupInfoCollectionViewCell.m
//  删除群组成员
//
//  Created by WardenAllen on 15/8/13.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "GroupInfoCollectionViewCell.h"

@interface GroupInfoCollectionViewCell ()

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation GroupInfoCollectionViewCell

- (void)setUp {
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 10, 62, 62)];
    
    CALayer *layer = [self.avatarImageView layer];
    
    [layer setMasksToBounds:YES];
    
    [layer setCornerRadius:31.0];
    
    [layer setBorderWidth:1.0];
    
    [layer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, 10, 20, 20)];
    
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 70, 62, 20)];
    
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [self.nameLabel setTintColor:[UIColor whiteColor]];
    
    [self addSubview:self.avatarImageView];
    
    [self addSubview:self.deleteBtn];
    
    [self addSubview:self.nameLabel];
}


#pragma setters and getters

- (void)setAvatarImage:(UIImage *)avatarImage {
    self.avatarImageView.image = avatarImage;
}

- (UIImage *)avatarImage {
    return self.avatarImageView.image;
}

- (void)setCanDelete:(BOOL)canDelete {
    if (canDelete) {
        [self.deleteBtn setImage:[UIImage imageNamed:@"群组信息-删除.png"] forState:UIControlStateNormal];
    } else {
        [self.deleteBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (BOOL)canDelete {
    return self.canDelete;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (NSString *)name {
    return self.nameLabel.text;
}

#pragma mark - Action

- (void)deleteBtnClicked:(id)sender {    
    if ( [self.delegate respondsToSelector:@selector(didCell:CickedDeleteBtn:)]) {
        [self.delegate didCell:self CickedDeleteBtn:sender] ;
    }
}

@end
