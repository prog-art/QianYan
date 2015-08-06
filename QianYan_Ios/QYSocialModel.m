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

@implementation QYSocialModel{
    BOOL isReplyView ;
    int tempInt ;
}

- (id)init {
    if ( self = [super init] ) {
        self.completionReplySource = [NSMutableArray array] ;
        self.attributedData = [NSMutableArray array] ;
        self.attributedDataWF = [NSMutableArray array] ;
        self.showImageArray = [NSMutableArray array] ;
        _foldOrNot = YES ;
        _islessLimit = NO ;
    }
    return self;
}

//计算replyview高度
- (float)calculateReplyHeightWithWidth:(float)sizeWidth {

    isReplyView = YES ;
    float height = .0f ;
    
    for (int i = 0; i < self.replyDataSource.count ; i ++ ) {
        
        tempInt = i ;
        
        NSString *matchString = self.replyDataSource[i] ;
        
        NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString] ;
        
        NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                           withString:PlaceHolder] ;
        //存新的
        [self.completionReplySource addObject:newString] ;
        
        
        [self matchString:newString fromView:isReplyView] ;
        
        QYSocialTextView *_ilcoreText = [[QYSocialTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)] ;
        
        _ilcoreText.isDraw = NO ;
        
        [_ilcoreText setOldString:self.replyDataSource[i] andNewString:newString] ;
        
        height =  height + [_ilcoreText getTextHeight] + 5;
        
    }
    
    [self calculateShowImageHeight] ;
    
    return height;
    
}

//图片高度
- (void)calculateShowImageHeight {
    
    if (self.showImageArray.count == 0 ) {
        self.showImageHeight = 0 ;
    }else{
        self.showImageHeight = (ShowImage_H + 10) * ( (self.showImageArray.count - 1)/3 + 1) ;
    }
    
}

- (void)matchString:(NSString *)dataSourceString fromView:(BOOL)isYMOrNot {
    
    if (isYMOrNot == YES) {
        
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0] ;
        
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            [totalArr addObject:mobileLink[i]] ;
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [totalArr addObject:[webLink objectAtIndex:i]];
        }
        
        //******自行添加**********
        
        if (_defineAttrData.count != 0) {
            NSArray *tArr = _defineAttrData[tempInt] ;
            for (int i = 0; i < tArr.count ; i ++) {
                NSString *string = [dataSourceString substringWithRange:NSRangeFromString(tArr[i])] ;
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString(tArr[i]))]] ;
            }
            
        }
       
        
        //***********************
        [self.attributedData addObject:totalArr];
        
        
    }else{
        
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:dataSourceString] ;
        for (int i = 0; i < mobileLink.count; i ++) {
            [self.attributedDataWF addObject:mobileLink[i]] ;
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:dataSourceString] ;
        for (int i = 0; i < webLink.count; i ++) {
            [self.attributedDataWF addObject:[webLink objectAtIndex:i]] ;
        }
        
        //******自行添加**********
        //        NSString *string = [dataSourceString substringWithRange:NSMakeRange(0, 3)];
        //        [self.attributedDataWF addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSMakeRange(0, 3))]];
        //**********************
    }
}

//说说高度
- (float)calculateContentHeightForContainerWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold {
    
    isReplyView = NO ;
    
    NSString *matchString =  _content ;
    
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString] ;
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder] ;
    //存新的
    self.completionContent = newString ;
    
    [self matchString:newString fromView:isReplyView] ;
    
    QYSocialTextView *_wfcoreText = [[QYSocialTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)] ;
    
    _wfcoreText.isDraw = NO ;
    
    [_wfcoreText setOldString:_content andNewString:newString] ;
    
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

@end