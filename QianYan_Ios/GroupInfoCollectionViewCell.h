//
//  GroupInfoCollectionViewCell.h
//  删除群组成员
//
//  Created by WardenAllen on 15/8/13.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellDelegate ;

@interface GroupInfoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *avatarImage;

@property (assign, nonatomic) BOOL canDelete;

@property (strong, nonatomic) NSString *name;

@property (nonatomic, assign) NSInteger cellTag;

@property (weak) id<cellDelegate> delegate;

- (void)setUp;

@end


@protocol cellDelegate <NSObject>

- (void)didCell:(GroupInfoCollectionViewCell *)cell CickedDeleteBtn:(UIButton *)sender ;

@end