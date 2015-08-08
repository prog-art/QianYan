//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "QYSocialViewController.h"
#import "QYSocialTableViewCell.h"
#import "ContantHead.h"
#import "QYShowImageView.h"
#import "QYSocialModel.h"
#import "YMReplyInputView.h"
#import "QYSocialActionSheet.h"
#import "QYSocialAlertView.h"

#import "QY_Common.h"

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
#define kAdmin [QYUser currentUser].coreUser.nickname

#define kSocial2WordSharingSegueId @"Social2WordSharingSegueId"

@interface QYSocialViewController ()<UITableViewDataSource,UITableViewDelegate,QYSocialCellDelegate,QY_commentDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
//    NSMutableArray *_imageDataSource;
    
//    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    UIButton *replyBtn;
    
    YMReplyInputView *replyView ;
    
}

@property (nonatomic, strong) UIRefreshControl *refreshControl ;

@property (nonatomic, strong) NSArray *feeds ;

@end

@implementation QYSocialViewController

#pragma mark - init 

 /**
 *  初始化右上角分享相关的控件
 */
- (void)setUpSocialSharingControl {
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
}

- (void)initTableview {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    mainTable.backgroundColor = [UIColor clearColor] ;
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self ;
    mainTable.dataSource = self ;
    [self.view addSubview:mainTable] ;
    
    [mainTable addSubview:self.refreshControl] ;
}

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    }
    return _refreshControl ;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [[QY_JPROHttpService shareInstance] getFeedListWithPage:0 NumPerPage:10 UserId:nil StartId:nil EndId:nil Check:nil Complection:^(NSArray *objects, NSError *error) {
        if ( refreshControl ) {
            [refreshControl endRefreshing] ;
        }
        
        if ( objects && !error ) {
            QYDebugLog(@"feeds = %@",objects) ;
            [QYUtils runInGlobalQueue:^{
                [self phraseFeedsData:objects] ;
            }] ;
        } else {
            [QYUtils alertError:error] ;
        }
    }] ;
}

#warning 重构到feed类里
- (void)phraseFeedsData:(NSArray *)feeds {
    
    NSMutableSet *set = [NSMutableSet setWithArray:self.feeds] ;

    [feeds enumerateObjectsUsingBlock:^(NSDictionary *feedDic, NSUInteger idx, BOOL *stop) {
        NSString *feedId = [feedDic[QY_key_id] stringValue] ;
        
        QY_feed *feed = [QY_feed feedWithId:feedId] ;
        
        [feed initWithFeedDic:feedDic] ;
        
        QYDebugLog(@"feed = %@",feed) ;
        
        [set addObject:feed] ;
    }] ;
    
    [QY_appDataCenter saveObject:nil error:NULL] ;
    
    self.feeds = [[set allObjects] mutableCopy] ;
    
    [self maunallyReloadData] ;
}

- (void)maunallyReloadData {
    
#warning 性能低！后来注意优化！
    NSMutableArray *statusArray = [NSMutableArray array] ;
    
    //排序
    self.feeds =
    [[self.feeds sortedArrayUsingComparator:^NSComparisonResult(id<AFeed>obj1, id<AFeed>obj2) {
        return [obj2.aPubDate compare:obj1.aPubDate] ;
        
    }] mutableCopy] ;
    
    [self.feeds enumerateObjectsUsingBlock:^(id<AFeed> feed , NSUInteger idx, BOOL *stop) {
        QYSocialModel *socialModel = [[QYSocialModel alloc] init] ;
        
        socialModel.aFeed = feed ;
        
        socialModel.isSelfTheOwner = [feed.aOwner.aUserId isEqualToString:[QYUser currentUser].coreUser.userId] ;

        socialModel.foldOrNot = YES ;//?
        
        
        NSMutableArray *comments = [NSMutableArray array] ;
        NSMutableArray *userDefineAttriArray = [NSMutableArray array] ;

        //排序
        NSMutableArray *QY_comments =
        [[feed.aComments sortedArrayUsingComparator:^NSComparisonResult(id<AComment> obj1,id<AComment> obj2) {
            return [obj1.aPubDate compare:obj2.aPubDate] ;
        }] mutableCopy] ;

        
        [QY_comments enumerateObjectsUsingBlock:^(id<AComment> comment, NSUInteger idx, BOOL *stop) {
            NSMutableArray *tempDefineArr = [NSMutableArray array] ;

            id<AUser> user = comment.aOwner ;
            NSString *range = NSStringFromRange(NSMakeRange(0, user.aName.length)) ;
            
            [tempDefineArr addObject:range] ;
            
            [userDefineAttriArray addObject:tempDefineArr] ;
            
            NSString *commentStr = [NSString stringWithFormat:@"%@:%@",user.aName,comment.aContent] ;
            
            [comments addObject:commentStr] ;
            [socialModel.aComments addObject:comment] ;
        }] ;
//        socialModel.comments = comments;//回复
        
        socialModel.defineAttrData = userDefineAttriArray ;

//        ymData.showImageArray = ;//
        
        [statusArray addObject:socialModel] ;
    }] ;

    [self calculateHeight:statusArray] ;
}

#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    
#warning 补丁
    _tableDataSource = [NSMutableArray array] ;
    
    for (QYSocialModel *ymData in dataArray) {
        ymData.foldedContentHeight = [ymData calculateContentHeightForContainerWidth:self.view.frame.size.width withUnFoldState:NO] ;//折叠
        
        ymData.unFoldedContentHeight = [ymData calculateContentHeightForContainerWidth:self.view.frame.size.width withUnFoldState:YES] ;//展开
        
        ymData.commentsHeight = [ymData calculateCommentsHeightWithWidth:self.view.frame.size.width] ;
        [_tableDataSource addObject:ymData] ;
    }
    
    [QYUtils runInMainQueue:^{
        [mainTable reloadData] ;
    }] ;
}

- (void)refreshNotify:(NSNotification *)notification {
    NSString *feedId = notification.object ;
    QYDebugLog(@"refersh locall feedId = %@",feedId) ;
    
    if ( feedId ) {
        #warning 这一步必须，因为很多属性是在服务器生成。。必须fetch。
        [QY_feed fetchFeedWithId:feedId complection:^(QY_feed *feed, NSError *error) {
            if ( feed && !error ) {
                [self refreshWithOutNetwork] ;
            } else {
                [QYUtils alert:@"获取最新朋友圈状态失败，请检查网络"] ;
            }
        }] ;
    }
}

/**
 *  本地刷新
 */
- (void)refreshWithOutNetwork {
    self.feeds = [[QYUser currentUser].coreUser visualableFeedItems] ;
    [self maunallyReloadData] ;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor] ;

    _tableDataSource = [NSMutableArray array] ;
    
    [[QY_Notify shareInstance] addFeedObserver:self selector:@selector(refreshNotify:)] ;
    
    [self initTableview] ;
    
    [self refreshWithOutNetwork] ;
//    self.feeds = [[QYUser currentUser].coreUser visualableFeedItems] ;
//    [self maunallyReloadData] ;
    
    [self setUpSocialSharingControl] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

#pragma mark - 分享

- (void)wordShareButtonClicked:(id)sender {
    [self performSegueWithIdentifier:kSocial2WordSharingSegueId sender:self] ;
    
    [_svm slideViewOut] ;
    _isShow = NO ;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"] ;
}

- (void)pictureShareButtonClicked:(id)sender {
    [QYUtils alert:@"图片分享～正在施工"] ;
    
    [_svm slideViewOut] ;
    _isShow = NO ;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"] ;
}

- (void)videoShareButtonClicked:(id)sender {
    [QYUtils alert:@"视频分享～正在施工"] ;
    
    [_svm slideViewOut];
    _isShow = NO;
    _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
}

- (IBAction)showSharingControlBtnClicked:(id)sender {
    if (_isShow) {
        [_svm slideViewOut];
        _addButtonItem.image = [UIImage imageNamed:@"社交-添加.png"];
        _isShow = NO;
    } else {
        [_svm slideViewIn];
        _addButtonItem.image = [UIImage imageNamed:@"社交-添加关闭.png"];
        _isShow = YES;
    }
}

- (void)backToPre {
    [self dismissViewControllerAnimated:YES completion:NULL] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _tableDataSource.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYSocialModel *ym = [_tableDataSource objectAtIndex:indexPath.row] ;
    BOOL unfold = ym.foldOrNot ;
    return TableHeader + kLocationToBottom + ym.commentsHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.foldedContentHeight:ym.unFoldedContentHeight) + kReplyBtnDistance - 25.0 + TimeHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"ILTableViewCell";
    
    QYSocialTableViewCell *cell = (QYSocialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[QYSocialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row ;
    cell.replyBtn.tag = indexPath.row ;
    cell.replyBtn.appendIndexPath = indexPath ;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside] ;
    cell.delegate = self ;

    id<AFeed> feed = self.feeds[indexPath.row] ;
    
    [feed.aOwner aDisplayUserAvatarAtImageView:cell.avatarImageView] ;
    
    [cell setUpWithModel:[_tableDataSource objectAtIndex:indexPath.row]] ;

    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 评论

- (void)replyAction:(QYButton *)sender{
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    float origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
  
    if (replyBtn) {
        [UIView animateWithDuration:0.25f animations:^{
            replyBtn.frame = CGRectMake(sender.frame.origin.x, origin_Y - 10 , 0, 38) ;
        } completion:^(BOOL finished) {
            [replyBtn removeFromSuperview] ;
            replyBtn = nil ;
        }] ;
       
    } else {
        replyBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        replyBtn.layer.cornerRadius = 5 ;
        replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:1.0] ;
        replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 5 , 0, 28) ;
        [replyBtn setTitleColor:[UIColor whiteColor] forState:0] ;
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0] ;
        replyBtn.tag = sender.tag ;
        [mainTable addSubview:replyBtn] ;
        [replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside] ;
        
        [UIView animateWithDuration:0.25f animations:^{
            replyBtn.frame = CGRectMake(sender.frame.origin.x - 60, origin_Y  - 5 , 60, 28) ;
        } completion:^(BOOL finished) {
            [replyBtn setTitle:@"评论" forState:0] ;
        }] ;
    }
}

- (void)replyMessage:(UIButton *)sender {
#warning 重构
    if (replyBtn){
        [replyBtn removeFromSuperview] ;
        replyBtn = nil ;
    }
    
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self ;
    replyView.replyTag = sender.tag ;
    [self.view addSubview:replyView] ;
}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (replyBtn) {
        [replyBtn removeFromSuperview] ;
        replyBtn = nil ;
    }
}


#pragma mark -cellDelegate
- (void)changeFoldState:(QYSocialModel *)ymD onCellRow:(NSInteger)cellStamp {
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD] ;
    [mainTable reloadData] ;

}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag {

    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    QYShowImageView *ymImageV = [[QYShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
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

- (void)cell:(QYSocialTableViewCell *)cell didClickDeleteBtn:(UIButton *)sender {
    QYSocialAlertView *alertView = [[QYSocialAlertView alloc] initWithTitle:nil message:@"是否删除这条状态？" delegate:self cancelButtonTitle:@"手滑了" otherButtonTitles:@"是的", nil] ;
    alertView.feedId = cell.feedId ;
    
    [alertView show] ;
    
}

- (void)cell:(QYSocialTableViewCell *)cell didClickCommentIdis:(NSString *)commentId {
    QYDebugLog(@"commentId = %@",commentId) ;
    QY_comment *comment = [QY_comment findCommentById:commentId] ;
    
    if ( [comment.userId isEqualToString:[QYUser currentUser].userId]) {
        QYSocialActionSheet *actionSheet = [[QYSocialActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil] ;
        actionSheet.commentId = commentId ;
        
        [actionSheet showInView:self.view] ;
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag {
    QY_feed *feed = self.feeds[inputTag] ;
    
    if ( feed ) {
        [feed addComment:replyText complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"发表评论成功") ;
                [QYUtils alert:@"发表评论成功"] ;
            } else {
                QYDebugLog(@"发表评论失败 error = %@",error) ;
                [QYUtils alertError:error] ;
            }
        }] ;
    }
}

- (void)destorySelf {
    [replyView removeFromSuperview] ;
    replyView = nil ;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(QYSocialAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        [self deleteFeedById:alertView.feedId] ;
    }
}

#pragma mark -  UIActionSheetDelegate

- (void)actionSheet:(QYSocialActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != actionSheet.cancelButtonIndex ) {
        [QYUtils alert:@"删除评论"] ;
        [self deleteCommentById:actionSheet.commentId] ;
    }
}

#pragma mark - 调用删除的代码

- (void)deleteFeedById:(NSString *)feedId {
    [SVProgressHUD show] ;
    [[QYUser currentUser].coreUser deleteFeedById:feedId Complection:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( success ) {
            QYDebugLog(@"删除说说成功") ;
            [self refreshWithOutNetwork] ;
        } else {
            QYDebugLog(@"")
        }
    }] ;
}

- (void)deleteCommentById:(NSString *)commentId {
    [SVProgressHUD show] ;
    [[QYUser currentUser].coreUser deleteCommentById:commentId complection:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( success ) {
            QYDebugLog(@"删除评论成功") ;
            [self refreshWithOutNetwork] ;            
        } else {
            QYDebugLog(@"删除评论失败 error = %@",error) ;
        }
    }] ;
}

@end