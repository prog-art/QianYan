//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYSocialModel.h"
#import "QYSocialTextView.h"
#import "QYButton.h"

@protocol QYSocialCellDelegate ;

@interface QYSocialTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (weak) id<QYSocialCellDelegate> delegate ;

#pragma mark - UI

@property (nonatomic,strong) QYButton *replyBtn;
@property (nonatomic,strong) UILabel *nameLabel ;
@property (nonatomic,strong) UIImageView *avatarImageView ;
@property (nonatomic,strong) NSMutableArray * imageViews ;//显示带图片的说说

#pragma mark - Data


@property (nonatomic,strong) NSMutableArray * ymTextArray ;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray ;
@property (nonatomic,assign) NSInteger stamp;

#pragma mark - Init API

- (void)setUpWithModel:(QYSocialModel *)ymData ;

@end



@protocol QYSocialCellDelegate <NSObject>

- (void)changeFoldState:(QYSocialModel *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;

@end