//
//  JVRightDrawerTableViewCell.m
//  JVFloatingDrawer
//
//  Created by WardenAllen on 15/5/18.
//  Copyright (c) 2015年 JVillella. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (nonatomic, strong) UIImage *buttonImage;

@end

@implementation ContactTableViewCell

- (void)awakeFromNib {
    self.userId = @"0";
    
    [self.addButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setImage:[UIImage imageNamed:@"添加按钮.png"] forState:UIControlStateSelected];
    [self.addButton setImage:[UIImage imageNamed:@"添加按钮（选中）.png"] forState:UIControlStateHighlighted];
}

-(void)addBtnClicked:(UIButton *)sender{
    if ( [self.delegate respondsToSelector:@selector(didClickedAddBtn:atIndex:)]) {
        [self.delegate didClickedAddBtn:self atIndex:self.tag] ;
    }
}

-(void)inviteBtnClicked:(UIButton *)sender{
    if ( [self.delegate respondsToSelector:@selector(didClickedInviteBtn:atIndex:)]) {
        [self.delegate didClickedInviteBtn:self atIndex:self.tag] ;
    }
}


#pragma mark - nameText

- (NSString *)name {
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

#pragma mark - phoneNumberText

- (NSString *)tel {
    return self.telLabel.text;
}

- (void)setTel:(NSString *)tel {
    self.telLabel.text = tel;
}

#pragma mark - buttonImage

- (UIImage *)buttonImage {
    return self.addButton.imageView.image;
}

- (void)setButtonImage:(UIImage *)buttonImage {
    [self.addButton setImage:buttonImage forState:UIControlStateNormal];
}

#pragma mark - isAddStatus

- (NSString *)userId {
    return self.userId;
}

- (void)setUserId:(NSString *)userId {
    if (userId) {
        [self.addButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton setImage:[UIImage imageNamed:@"添加按钮.png"] forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"添加按钮（选中）.png"] forState:UIControlStateHighlighted];
    } else {
        [self.addButton addTarget:self action:@selector(inviteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton setImage:[UIImage imageNamed:@"邀请按钮.png"] forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"邀请按钮（选中）.png"] forState:UIControlStateHighlighted];
    }
}

@end
