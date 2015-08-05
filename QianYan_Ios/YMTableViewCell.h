//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"

@protocol QY_socialCellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;

@end

@interface YMTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (weak) id<QY_socialCellDelegate> delegate ;

@property (nonatomic,strong) NSMutableArray * imageArray ;
@property (nonatomic,strong) NSMutableArray * ymTextArray ;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray ;


@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) YMButton *replyBtn;

@property (nonatomic,strong) UILabel *nameLabel ;
@property (nonatomic,strong) UIImageView *avatarImageView ;


- (void)setYMViewWith:(YMTextData *)ymData;

@end