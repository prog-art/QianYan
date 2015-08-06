//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "QYSocialTableViewCell.h"

#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"


#define QY_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define QY_RGB(r,g,b) QY_RGBA(r,g,b,1.0)

#define kImageTag 9999

@interface QYSocialTableViewCell () {
    QYSocialModel *tempData ;
    UIImageView *commentBackgroundImageView ;
    //    NSMutableArray *textFieldArray;
}

@property (strong,nonatomic) UIButton *foldBtn ;

@end

@implementation QYSocialTableViewCell

#pragma mark - getter && setter

- (UIImageView *)avatarImageView {
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 36, 36)] ;
        _avatarImageView.backgroundColor = [UIColor clearColor] ;
        _avatarImageView.image = [UIImage imageNamed:@"mao.jpg"] ;
        CALayer *layer = [_avatarImageView layer] ;
        [layer setMasksToBounds:YES] ;
        [layer setCornerRadius:18.0] ;
        [layer setBorderWidth:0.5] ;
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]] ;
    }
    return _avatarImageView ;
}

- (UILabel *)nameLabel {
    if ( !_nameLabel ) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, screenWidth - 120, TableHeader/2)] ;
        _nameLabel.textAlignment = NSTextAlignmentLeft ;
        _nameLabel.text = @"" ;
        _nameLabel.font = [UIFont systemFontOfSize:15.0] ;
        _nameLabel.textColor = QY_RGB(199, 101, 4) ;
    }
    return _nameLabel ;
}

- (UIButton *)foldBtn {
    if ( !_foldBtn ) {
        _foldBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_foldBtn setTitle:@"展开" forState:UIControlStateNormal] ;
        _foldBtn.backgroundColor = [UIColor clearColor] ;
        _foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0] ;
        [_foldBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
        [_foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _foldBtn ;
}

#pragma mark -

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.backgroundColor = [UIColor clearColor] ;
        
        //avatarImageView
        [self.contentView addSubview:self.avatarImageView] ;
        //nameLabel
        [self.contentView addSubview:self.nameLabel] ;
        
//        UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(48, 5 + TableHeader/2 , screenWidth - 120, TableHeader/2)] ;
//        introLbl.numberOfLines = 1 ;
//        introLbl.font = [UIFont systemFontOfSize:14.0] ;
//        introLbl.textColor = [UIColor grayColor] ;
//        introLbl.text = @"这个人很懒，什么都没有留下" ;
//        [self.contentView addSubview:introLbl] ;
        
        _imageViews = [NSMutableArray array] ;
        _ymTextArray = [NSMutableArray array] ;
        _ymShuoshuoArray = [NSMutableArray array] ;
        
        //折叠button
        [self.contentView addSubview:self.foldBtn] ;
        
        commentBackgroundImageView = [[UIImageView alloc] init] ;
        commentBackgroundImageView.backgroundColor = QY_RGB(242, 242, 242) ;
        [self.contentView addSubview:commentBackgroundImageView] ;
        
        _replyBtn = [QYButton buttonWithType:0] ;
        [_replyBtn setImage:[UIImage imageNamed:@"社交-评论按钮.png"] forState:0] ;
        [self.contentView addSubview:_replyBtn] ;
        
//        if (textFieldArray.count == 0) {
//            textFieldArray = [NSMutableArray array];
//        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated] ;
}


- (void)setUpWithModel:(QYSocialModel *)ymData {
    tempData = ymData ;
    
    [self.nameLabel setText:ymData.name] ;
    
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        QYSocialTextView * imageV = (QYSocialTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
    
    QYSocialTextView *textView = [[QYSocialTextView alloc] initWithFrame:CGRectMake(offSet_X, 15 + TableHeader, 260, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataWF;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.content andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot ? ymData.shuoshuoHeight : ymData.unFoldShuoHeight ;
    
    textView.frame = CGRectMake(offSet_X, 15 + TableHeader - 25, 260, hhhh);
    
    [_ymShuoshuoArray addObject:textView];
    
    //按钮
    self.foldBtn.frame = CGRectMake(offSet_X - 10 , 15 + TableHeader + hhhh + 10 - 25 , 50 , 20) ;
    //根据行数是否超了，决定是否显示
    if (ymData.islessLimit) {
        self.foldBtn.hidden = YES ;
    } else {
        self.foldBtn.hidden = NO ;
    }
    
    
    if (tempData.foldOrNot == YES) {
        [self.foldBtn setTitle:@"展开" forState:0] ;
    }else{
        [self.foldBtn setTitle:@"收起" forState:0] ;
    }
    
    //图片部分－先移除
    for (int i = 0; i < _imageViews.count ; i++ ) {
        
        UIImageView * imageV = (UIImageView *)_imageViews[i] ;
        
        if ( imageV.superview ) {
            [imageV removeFromSuperview] ;
        }
    }
    [_imageViews removeAllObjects] ;
    
    //再添加
    for (int  i = 0; i < ymData.showImageArray.count ; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(48 + (i % 3) * 90, TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30) - 25, 80, ShowImage_H)];
        image.userInteractionEnabled = YES ;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray ;
        image.backgroundColor = [UIColor clearColor] ;
        image.tag = kImageTag + i ;
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]] ;
        [self.contentView addSubview:image];
        [_imageViews addObject:image];
        
    }

    
    //最下方回复部分-先移除
    for (int i = 0; i < _ymTextArray.count ; i++) {
        
        QYSocialTextView * ymTextView = (QYSocialTextView *)_ymTextArray[i] ;
        if ( ymTextView.superview) {
            [ymTextView removeFromSuperview];
            
        }
    }
    [_ymTextArray removeAllObjects] ;
    
    float origin_Y = 10 ;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    
    float backView_Y = 0;
    float backView_H = 0;
    
    //评论
    for (int i = 0; i < ymData.replyDataSource.count ; i ++ ) {  //评论部分

        QYSocialTextView *commentTextView = [[QYSocialTextView alloc] initWithFrame:CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit ? 0 : 30 ) + balanceHeight + kReplyBtnDistance, 260, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit ? 0 : 30 ) ;
        }
        
        commentTextView.delegate = self ;
        commentTextView.attributedData = ymData.attributedData[i] ;
        
        
        [commentTextView setOldString:[ymData.replyDataSource objectAtIndex:i] andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        commentTextView.frame = CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 25, 260, [commentTextView getTextHeight]);
        commentTextView.tag = i ;
        [self.contentView addSubview:commentTextView] ;
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
        
        
        origin_Y += [commentTextView getTextHeight] + 5 ;
        
        backView_H += commentTextView.frame.size.height ;
        
        [_ymTextArray addObject:commentTextView];
    }
    
    
//
//    backView_H += 100;
    
    backView_H += (ymData.replyDataSource.count - 1) * 5 ;
    
//replyImageView -- 评论背景
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        
        commentBackgroundImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 25, 0, 0);
        
        self.replyBtn.frame = CGRectMake(271, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit ? 0 : 30 ) + balanceHeight + kReplyBtnDistance - 57 , 38, 18) ;
//        _replyBtn.frame = CGRectMake(271, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 57, 38, 18);
        
    }else{
        
        commentBackgroundImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance - 25, 260, backView_H + 20 - 12);//微调
        
        _replyBtn.frame = CGRectMake(271, commentBackgroundImageView.frame.origin.y - 26, 38, 18) ;
        
    }
}

#pragma mark - WFCoretextDelegate

- (void)textView:(QYSocialTextView *)view didClickWFCoretext:(NSString *)clickedString {
    NSInteger index = view.tag ;

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickedString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    });
    
}

- (void)textViewDidClickAllText:(QYSocialTextView *)view {
    NSInteger index = view.tag ;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UI正在施工中，删除等待UI接口设计完善～～" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    });
    
}

#pragma mark - 点击事件 && IBActions

- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag] ;
}

- (void)foldText {
    if (tempData.foldOrNot == YES) {
        tempData.foldOrNot = NO ;
        [self.foldBtn setTitle:@"收起" forState:UIControlStateNormal] ;
    }else{
        tempData.foldOrNot = YES;
        [self.foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempData onCellRow:self.stamp] ;
}

@end