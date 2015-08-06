//
//  YMTextData.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYSocialModel : NSObject

#pragma mark - Other

@property (nonatomic,strong) NSString *      name ;//名字

#pragma mark - 时间

@property (nonatomic,strong) NSDate *        pubDate ;//发布时间

#pragma mark - 内容

@property (nonatomic,strong) NSString       *content;//内容部分
@property (nonatomic,assign) float           foldedContentHeight;//折叠内容高度
@property (nonatomic,assign) float           unFoldedContentHeight;//展开内容高度
@property (nonatomic,assign) BOOL            foldOrNot;//是否折叠
@property (nonatomic,strong) NSString       *completionContent;//内容部分（处理后）
@property (nonatomic,assign) BOOL            islessLimit;//是否小于最低限制 宏定义最低限制是 limitline

/**
 *  计算折叠还是展开的说说的高度
 *
 *  @param sizeWidth 宽度
 *  @param isUnfold  展开与否
 *
 *  @return 高度
 */
- (float)calculateContentHeightForContainerWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold ;

#pragma mark - 回复

@property (nonatomic,strong) NSMutableArray *completionComments;//回复内容数据源（处理）
@property (nonatomic,strong) NSMutableArray *attributedData;//YMTextView附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataWF;//WFTextView附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *comments;//回复内容数据源（未处理）
@property (nonatomic,assign) float           commentsHeight;//回复高度
@property (nonatomic,strong) NSMutableArray *defineAttrData;//自行添加 元素为每条回复中的自行添加的range组成的数组 如：第一条回复有（0，2）和（5，2） 第二条为（0，2）。。。。

/**
 *  计算高度
 *
 *  @param sizeWidth view 宽度
 *
 *  @return 返回高度
 */
- (float)calculateCommentsHeightWithWidth:(float)sizeWidth ;

#pragma mark - 图片

@property (nonatomic,strong) NSMutableArray *showImageArray;//图片数组
@property (nonatomic,assign) float           showImageHeight;//展示图片的高度

#pragma mark - 删除按钮

@property (nonatomic,assign) BOOL            isSelfTheOwner ;//是否是自己的说说，决定是否能删除。

@end
