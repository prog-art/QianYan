//
//  WFTextView.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/31.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//
/**
 *  CTLine 去画
 *
 */

#import <UIKit/UIKit.h>

@protocol WFCoretextDelegate ;

@interface QYSocialTextView : UIView

@property (weak) id<WFCoretextDelegate>delegate ;

@property (nonatomic,strong) NSAttributedString *attrEmotionString ;
@property (nonatomic,strong) NSArray *emotionNames ;
@property (nonatomic,assign) BOOL isDraw ;
@property (nonatomic,assign) BOOL isFold ;//是否折叠
@property (nonatomic,strong) NSMutableArray *attributedData ;
@property (nonatomic,assign) int textLine ;
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index


- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

- (int)getTextLines;

- (float)getTextHeight;

@property (nonatomic) NSString *commentId ;

@end

@protocol WFCoretextDelegate <NSObject>

- (void)textView:(QYSocialTextView *)view didClickWFCoretext:(NSString *)clickedString ;

- (void)textViewDidClickAllText:(QYSocialTextView *)view ;

@end