//
//  YMTextData.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "QYSocialModel.h"
#import "ContantHead.h"
#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"

#import "QYSocialTextView.h"

@implementation QYSocialModel {
    BOOL isCommentView ;
    int tempI ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        self.completionComments = [NSMutableArray array] ;
        self.attributedData = [NSMutableArray array] ;
        self.attributedDataWF = [NSMutableArray array] ;
        self.showImageArray = [NSMutableArray array] ;
        self.foldOrNot = YES ;
        self.islessLimit = NO ;
        self.isSelfTheOwner = NO ;
        self.AComments = [NSMutableArray array] ;
    }
    return self ;
}

#pragma mark - getter 

- (NSString *)name {
    return self.aFeed.aOwner.aName ;
}

- (NSDate *)pubDate {
    return self.aFeed.aPubDate ;
}

- (NSString *)content {
    return self.aFeed.aContent ;
}

#pragma mark - public api

//说说高度
- (float)calculateContentHeightForContainerWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold {
    
    isCommentView = NO ;
    
    NSString *matchString = self.content ;
    
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString] ;
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder] ;
    //存新的
    self.completionContent = newString ;
    
    [self matchString:newString isForCommentView:isCommentView] ;
    
    QYSocialTextView *_wfcoreText = [[QYSocialTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)] ;
    
    _wfcoreText.isDraw = NO ;
    
    [_wfcoreText setOldString:self.content andNewString:newString] ;
    
    if ([_wfcoreText getTextLines] <= limitline) {
        self.islessLimit = YES ;
    }else{
        self.islessLimit = NO ;
    }
    
    if (!isUnfold) {
        _wfcoreText.isFold = YES ;
    }else{
        _wfcoreText.isFold = NO ;
    }
    return [_wfcoreText getTextHeight] ;
}

//计算评论高度
- (float)calculateCommentsHeightWithWidth:(float)sizeWidth {

    isCommentView = YES ;
    float height = 0.0f ;
    
    for (int i = 0; i < self.aComments.count ; i ++ ) {
        
        id<AComment> comment = self.aComments[i] ;

        tempI = i ;
        
        //查找emoji并替换成空格，不支持emoji
        
        NSString *matchString = [NSString stringWithFormat:@"%@:%@",comment.aOwner.aName,comment.aContent] ;
        
//        NSString *matchString = comment.aContent ;
        
        NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString] ;
        
        NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                           withString:PlaceHolder] ;
        
        //存新的
        [self.completionComments addObject:newString] ;
        
        
        [self matchString:newString isForCommentView:isCommentView] ;
        
        //仅用于计算高度
        QYSocialTextView *textView = [[QYSocialTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)] ;
        
        textView.isDraw = NO ;
        
        [textView setOldString:matchString andNewString:newString] ;
        
        height =  height + [textView getTextHeight] + 5;
        
    }
    
//    [self calculateAttachImagesHeight] ;
    
    return height;
    
}

//图片高度
- (float)calculateAttachImagesHeight {
    self.showImageHeight = self.showImageArray.count == 0 ? 0 : (ShowImage_H + 10) * ( (self.showImageArray.count - 1) / 3 + 1) ;
    return self.showImageHeight ;
}

- (void)matchString:(NSString *)originString isForCommentView:(BOOL)isCommentViewOrNot {
    
    if (isCommentViewOrNot == YES) {
        //是评论
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0] ;
        
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:originString];
        for (int i = 0; i < mobileLink.count; i ++) {
            [totalArr addObject:mobileLink[i]] ;
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:originString] ;
        for (int i = 0; i < webLink.count; i ++) {
            [totalArr addObject:[webLink objectAtIndex:i]] ;
        }
        
        //******自行添加**********
        
        if (_defineAttrData.count != 0) {
            NSArray *tArr = _defineAttrData[tempI] ;
            for (int i = 0; i < tArr.count ; i ++) {
                NSString *string = [originString substringWithRange:NSRangeFromString(tArr[i])] ;
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString(tArr[i]))]] ;
            }
            
        }
       
        
        //***********************
        [self.attributedData addObject:totalArr];
        
        
    }else{
        //不是评论
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:originString] ;
        for (int i = 0; i < mobileLink.count; i ++) {
            [self.attributedDataWF addObject:mobileLink[i]] ;
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:originString] ;
        for (int i = 0; i < webLink.count; i ++) {
            [self.attributedDataWF addObject:[webLink objectAtIndex:i]] ;
        }
        
        //******自行添加**********
        //        NSString *string = [dataSourceString substringWithRange:NSMakeRange(0, 3)];
        //        [self.attributedDataWF addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSMakeRange(0, 3))]];
        //**********************
    }
}

@end