//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"

#define AntiARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing
#define AntiARCRelease(...) void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define AL_SINGLELINE_TEXT_HEIGHT(text, font) [text length] > 0 ? [text sizeWithAttributes:nil].height : 0.f;
#define AL_MULTILINE_TEXT_HEIGHT(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize \
options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) \
attributes:nil \
context:NULL].size.height : 0.f;
#else
#define AL_SINGLELINE_TEXT_HEIGHT(text, font) [text length] > 0 ? [text sizeWithFont:font].height : 0.f;
#define AL_MULTILINE_TEXT_HEIGHT(text, font, maxSize, mode) [text length] > 0 ? [text sizeWithFont:font \
constrainedToSize:maxSize \
lineBreakMode:mode].height : 0.f;
#endif

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"WD"


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate> {
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    UIButton *replyBtn;
    
    YMReplyInputView *replyView ;
    
}
@end

@implementation WXViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    _tableDataSource = [NSMutableArray array] ;
    
    _contentDataSource = [NSMutableArray array] ;//回复数据来源
    [_contentDataSource addObject:kContentText1];
    [_contentDataSource addObject:kContentText2];
    [_contentDataSource addObject:kContentText3];
    [_contentDataSource addObject:kContentText4];
    [_contentDataSource addObject:kContentText5];
    [_contentDataSource addObject:kContentText6];
    
    _shuoshuoDatasSource = [NSMutableArray array] ;//说说数据来源
    
    [_shuoshuoDatasSource addObject:kShuoshuoText1];
    [_shuoshuoDatasSource addObject:kShuoshuoText2];
    [_shuoshuoDatasSource addObject:kShuoshuoText3];
    [_shuoshuoDatasSource addObject:kShuoshuoText4];
    [_shuoshuoDatasSource addObject:kShuoshuoText5];
    [_shuoshuoDatasSource addObject:kShuoshuoText6];
    
    [self initTableview];
    [self configImageData];
    [self loadTextData];
    
    //添加动画
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 504)];
    _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25];
    
    _isShow = NO;
    
    _notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 112)];
    _notificationView.backgroundColor = [UIColor colorWithRed:250/255.0 green:247/255.0 blue:233/255.0 alpha:1];
    
    _svm = [[SlidingViewManager alloc] initWithInnerView:_notificationView containerView:self.view maskView:_maskView];
    
    _wordShareButton = [[UIButton alloc] init];
    [_wordShareButton addTarget:self action:@selector(wordShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_wordShareButton setImage:[UIImage imageNamed:@"社交-文字按钮.png"] forState:UIControlStateNormal];
    _wordShareButton.frame = CGRectMake(0, 0, 70, 70);
    _wordShareButton.center = CGPointMake(60, 45);
    [_notificationView addSubview:_wordShareButton];
    
    _wordShareLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 88, 36, 20)];
    [_wordShareLabel setText:@"文字"];
    [_notificationView addSubview:_wordShareLabel];
    
    _pictureShareButton = [[UIButton alloc] init];
    [_pictureShareButton addTarget:self action:@selector(pictureShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureShareButton setImage:[UIImage imageNamed:@"社交-相册按钮.png"] forState:UIControlStateNormal];
    _pictureShareButton.frame = CGRectMake(0, 0, 70, 70);
    _pictureShareButton.center = CGPointMake(160, 45);
    [_notificationView addSubview:_pictureShareButton];
    
    _pictureShareLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 88, 36, 20)];
    [_pictureShareLabel setText:@"相册"];
    [_notificationView addSubview:_pictureShareLabel];
    
    _videoShareButton = [[UIButton alloc] init];
    [_videoShareButton addTarget:self action:@selector(videoShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_videoShareButton setImage:[UIImage imageNamed:@"社交-录像按钮.png"] forState:UIControlStateNormal];
    _videoShareButton.frame = CGRectMake(0, 0, 70, 70);
    _videoShareButton.center = CGPointMake(260, 45);
    [_notificationView addSubview:_videoShareButton];
    
    _videoShareLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 88, 36, 20)];
    [_videoShareLabel setText:@"录像"];
    [_notificationView addSubview:_videoShareLabel];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_maskView addGestureRecognizer:_tapGestureRecognizer];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

#pragma mark -- 添加动画Actions 
- (void)tapped:(UITapGestureRecognizer *)recognizer { //手势
    [recognizer.view removeGestureRecognizer:recognizer];
    [_svm slideViewOut];
    _isShow = NO;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
}

- (void)wordShareButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Button clicked" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [_svm slideViewOut];
    _isShow = NO;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
}

- (void)pictureShareButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Button clicked" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [_svm slideViewOut];
    _isShow = NO;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
}

- (void)videoShareButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Button clicked" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [_svm slideViewOut];
    _isShow = NO;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
}

- (IBAction)demoButtonClicked:(id)sender {
    if (_isShow) {
        [_svm slideViewOut];
        
        _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
        
        _isShow = NO;
    } else {
        [_svm slideViewIn];
        
        [_maskView addGestureRecognizer:_tapGestureRecognizer];
        
        _addButtonItem.image = [UIImage imageNamed:@"社交-添加关闭.png"];
        
        _isShow = YES;
    }
}


#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray=[[NSMutableArray alloc]init];
       
      
         
         for (int i = 0 ; i < dataCount; i ++) {
             
         //模拟数据 随机3组回复 以及图片
             NSMutableArray * array = [[NSMutableArray alloc]init];
             NSMutableArray * userDefineAttriArray = [[NSMutableArray alloc]init];
             int randomReplyCount = arc4random() % 6 + 1;
             for (int k = 0; k < randomReplyCount; k ++) {
                 //[array addObject:[_contentDataSource objectAtIndex:arc4random() % 6]];
                 NSMutableArray *tempDefineArr = [[NSMutableArray alloc]init];
                 NSString *range = NSStringFromRange(NSMakeRange(0, 2));
                 
                 [tempDefineArr addObject:range];
                 [userDefineAttriArray addObject:tempDefineArr];
             }
             
             
             NSMutableArray * imageArray = [[NSMutableArray alloc] init];
             int randomImageCount = arc4random() % 9 + 1;
             
             for (int j = 0; j < randomImageCount; j ++) {
                 
                [imageArray addObject:[_imageDataSource objectAtIndex:arc4random() % 9]];
             }
            
        //图片上面说说部分
             NSString *aboveString = [_shuoshuoDatasSource objectAtIndex:arc4random() % 6];
             
             YMTextData *ymData = [[YMTextData alloc] init];
             ymData.showImageArray = imageArray;
             ymData.foldOrNot = YES;
             ymData.showShuoShuo = aboveString;
             ymData.defineAttrData = userDefineAttriArray;
             ymData.replyDataSource = array;
             [ymDataArray addObject:ymData];
             
         }
         [self calculateHeight:ymDataArray];
         
        
         
     });


}

#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{

    
   // NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource addObject:ymData];
        
    }
    
//    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
  //  NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
               [mainTable reloadData];
      
    });

   
}

#pragma mark - 图片数据源
- (void)configImageData{
   
    _imageDataSource = [NSMutableArray arrayWithCapacity:0];
    [_imageDataSource addObject:@"1.jpg"];
    [_imageDataSource addObject:@"2.jpg"];
    [_imageDataSource addObject:@"3.jpg"];
    [_imageDataSource addObject:@"1.jpg"];
    [_imageDataSource addObject:@"2.jpg"];
    [_imageDataSource addObject:@"3.jpg"];
    [_imageDataSource addObject:@"1.jpg"];
    [_imageDataSource addObject:@"2.jpg"];
    [_imageDataSource addObject:@"3.jpg"];
}


- (void)backToPre{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initTableview{

    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];

}

//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance - 25.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.tag = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    
    
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];

    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
     
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    float origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
  
    if (replyBtn) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            replyBtn.frame = CGRectMake(sender.frame.origin.x, origin_Y - 10 , 0, 38);
        } completion:^(BOOL finished) {
            NSLog(@"销毁");
            [replyBtn removeFromSuperview];
            replyBtn = nil;
            
        }];

        
       
    }else{
    
        replyBtn = [UIButton buttonWithType:0];
        replyBtn.layer.cornerRadius = 5;
        replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:1.0];
        replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 5 , 0, 28);
        [replyBtn setTitleColor:[UIColor whiteColor] forState:0];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        replyBtn.tag = sender.tag;
        [mainTable addSubview:replyBtn];
        [replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIView animateWithDuration:0.25f animations:^{
                replyBtn.frame = CGRectMake(sender.frame.origin.x - 60, origin_Y  - 5 , 60, 28);
        } completion:^(BOOL finished) {
            [replyBtn setTitle:@"评论" forState:0];
        }];
    
    }
    


}

#pragma mark - 真の评论
- (void)replyMessage:(UIButton *)sender{
    //NSLog(@"TAG === %d",sender.tag);
    
    if (replyBtn){
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }
   // NSLog(@"alloc reply");
        
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = sender.tag;
    [self.view addSubview:replyView];


}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (replyBtn) {
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }

}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];

}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
   
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
       
    }];

}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    NSString *newString = [NSString stringWithFormat:@"%@:%@",kAdmin,replyText];//此处可扩展。已写死，包括内部逻辑也写死 在YMTextData里 自行添加部分
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
    [ymData.replyDataSource addObject:newString];
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedData removeAllObjects];
    
    NSString *rangeStr = NSStringFromRange(NSMakeRange(0, kAdmin.length));
    NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
    [rangeArr addObject:rangeStr];
    [ymData.defineAttrData addObject:rangeArr];
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
    
}

- (void)destorySelf{
    
  //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;

}


- (void)dealloc{
    
 

}

@end
