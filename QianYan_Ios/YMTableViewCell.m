//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"

#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"

#define kImageTag 9999

@interface YMTableViewCell () {
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
    //    NSMutableArray *textFieldArray;
}

@end

@implementation YMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.backgroundColor = [UIColor clearColor] ;
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 36, 36)] ;
        headerImage.backgroundColor = [UIColor clearColor] ;
        headerImage.image = [UIImage imageNamed:@"mao.jpg"] ;
        CALayer *layer = [headerImage layer] ;
        [layer setMasksToBounds:YES] ;
        [layer setCornerRadius:18.0] ;
        [layer setBorderWidth:0.5] ;
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]] ;
        [self.contentView addSubview:headerImage] ;
        
        //nameLabel
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, screenWidth - 120, TableHeader/2)] ;
        self.nameLabel.textAlignment = NSTextAlignmentLeft ;
        self.nameLabel.text = @"" ;
        self.nameLabel.font = [UIFont systemFontOfSize:15.0] ;
        self.nameLabel.textColor = [UIColor colorWithRed:199/255.0 green:101/255.0 blue:4/255.0 alpha:1.0] ;
        [self.contentView addSubview:self.nameLabel] ;
        
//        UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(48, 5 + TableHeader/2 , screenWidth - 120, TableHeader/2)] ;
//        introLbl.numberOfLines = 1 ;
//        introLbl.font = [UIFont systemFontOfSize:14.0] ;
//        introLbl.textColor = [UIColor grayColor] ;
//        introLbl.text = @"这个人很懒，什么都没有留下" ;
//        [self.contentView addSubview:introLbl] ;
        
        _imageArray = [NSMutableArray array] ;
        _ymTextArray = [NSMutableArray array] ;
        _ymShuoshuoArray = [NSMutableArray array] ;
        
        foldBtn = [UIButton buttonWithType:0] ;
        [foldBtn setTitle:@"展开" forState:0] ;
        foldBtn.backgroundColor = [UIColor clearColor] ;
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0] ;
        [foldBtn setTitleColor:[UIColor grayColor] forState:0] ;
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside] ;
        [self.contentView addSubview:foldBtn] ;
        
        replyImageView = [[UIImageView alloc] init] ;
        
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0] ;
        [self.contentView addSubview:replyImageView] ;
        
        _replyBtn = [YMButton buttonWithType:0] ;
        [_replyBtn setImage:[UIImage imageNamed:@"社交-评论按钮.png"] forState:0] ;
        [self.contentView addSubview:_replyBtn] ;
        
//        if (textFieldArray.count == 0) {
//            textFieldArray = [NSMutableArray array];
//        }
    }
    return self;
}

- (void)foldText {
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated] ;
}


- (void)setYMViewWith:(YMTextData *)ymData {
    tempDate = ymData;
    
    [self.nameLabel setText:ymData.name] ;
    
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
    
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X, 15 + TableHeader, 260, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataWF;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, 15 + TableHeader - 25, 260, hhhh);
    
    [_ymShuoshuoArray addObject:textView];
    
    //按钮
    foldBtn.frame = CGRectMake(offSet_X - 10, 15 + TableHeader + hhhh + 10 - 25, 50, 20 );
    
    if (ymData.islessLimit) {
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [foldBtn setTitle:@"收起" forState:0];
    }
    
    //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
    
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(48 + (i % 3) * 90, TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30) - 25, 80, ShowImage_H)];
        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag + i;
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
        
    }
    
    //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
            
        }        
        
    }
    
    [_ymTextArray removeAllObjects];
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    
    float backView_Y = 0;
    float backView_H = 0;
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {  //评论部分
        
//        if (index != oldIndex) {
//            
//        }
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, 260, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30);
        }
        
        _ilcoreText.delegate = self;
        
        _ilcoreText.attributedData = [ymData.attributedData objectAtIndex:i];
        
        
        [_ilcoreText setOldString:[ymData.replyDataSource objectAtIndex:i] andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 25, 260, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        
        
        
//        UITextField *commentTextField = [[UITextField alloc] init];
//        commentTextField.backgroundColor = [UIColor greenColor];
//        
//        commentTextField.frame = CGRectMake(offSet_X, backView_H-100, screenWidth - offSet_X * 2, 24);
//        [self.contentView addSubview:commentTextField];
//        
//        if (textFieldArray.count < index+1) {
//            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(offSet_X, backView_H-100, screenWidth - offSet_X * 2, 24)];
//            textField.backgroundColor = [UIColor greenColor];
//            textField.placeholder = [NSString stringWithFormat:@"%d", index];
//            [textFieldArray addObject:textField];
//
//            [self.contentView addSubview:textField];
//            
//        } else {
//            [textFieldArray[index] setFrame:CGRectMake(offSet_X, backView_H-100, screenWidth - offSet_X * 2, 24)];
//            oldIndex = index;
//        }
//
//        if (textField.frame.size.width == 0) {
//            [textField setFrame:CGRectMake(offSet_X, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X * 2, 24)];
//            [self.contentView addSubview:textField];
//        } else {
//            [textField removeFromSuperview];
//            [textField setFrame:CGRectMake(offSet_X, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X * 2, 24)];
//            [self.contentView addSubview:textField];
//        }
        
        
        origin_Y += [_ilcoreText getTextHeight] + 5 ;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    
//
//    backView_H += 100;
    
    backView_H += (ymData.replyDataSource.count - 1)*5;
    
//replyImageView -- 评论背景
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        
        replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 25, 0, 0);
        _replyBtn.frame = CGRectMake(271, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 57, 38, 18);
        
    }else{
        
        replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 25, 260, backView_H + 20 - 12);//微调
        
        _replyBtn.frame = CGRectMake(271, replyImageView.frame.origin.y - 26, 38, 18);
        
    }
//    NSLog(@"%f", _replyBtn.frame.origin.y);
}

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
    
}

- (void)clickWFCoretext:(NSString *)clickString{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
}

#pragma mark - 点击事件
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
    
    
}

@end