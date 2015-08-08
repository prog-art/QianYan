//
//  AlertNotificationTableViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/25.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AlertNotificationTableViewController.h"
#import "AlertNotificationTableViewCell.h"
#include "avformat.h"
#include "avcodec.h"
#import "KxMovieViewController.h"

#import "QY_Common.h"
#import "QY_JPROHttpService.h"


@interface AlertNotificationTableViewController () {
    NSArray *_localMovies ;
    NSArray *_remoteMovies ;
    UIRefreshControl *_refreshControl ;
}

@property (strong, nonatomic) UITableView *tableView ;

@property (nonatomic) NSMutableArray *alertMessages ;

@property (nonatomic) NSMutableArray *dataSource ;

@property (nonatomic,strong) UIRefreshControl *refreshControl ;

@end

@implementation AlertNotificationTableViewController

#pragma mark - getter & setter 

- (NSMutableArray *)alertMessages {
    if ( !_alertMessages ) {
        _alertMessages = [NSMutableArray array] ;
    }
    return _alertMessages ;
}

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refreshMessage:) forControlEvents:UIControlEventValueChanged] ;
        [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]] ;
    }
    return _refreshControl ;
}

- (NSMutableArray *)dataSource {
    if ( !_dataSource ) {
        _dataSource = [NSMutableArray array] ;
    }
    return _dataSource ;
}

- (void)refreshMessage:(UIRefreshControl *)refreshControl {
    QYDebugLog(@"Refresh～") ;
    
    [[QYUser currentUser].coreUser fetchAlertMessagesComplection:^(NSArray *objects, NSError *error) {
        if ( [refreshControl isRefreshing] ) {
            [refreshControl endRefreshing] ;
        }
        
        if ( !error ) {
            QYDebugLog(@"获取报警信息列表成功 alertMsgs = %@",objects) ;
            [self beforeReloadData] ;
            
        } else {
            QYDebugLog(@"获取报警信息列表失败 error = %@",error) ;
            [QYUtils alertError:error] ;
        }
        
    }] ;
}

/**
 *  处理alertMessages。分组。
 */
- (void)beforeReloadData {
    self.dataSource = nil ;
    self.alertMessages = [[[QYUser currentUser].coreUser visualableAlertMessages] mutableCopy] ;
#warning 把alertMessages按日期分组后放到dataSource里。tableView的数据改为dataSource里的，现在为alertmessages的。

    [self.tableView reloadData] ;
}

#pragma mark - Life Cycle

- (void)refreshMessage {
    [self refreshMessage:nil] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addSubview:self.refreshControl] ;
    
    self.alertMessages = [[[QYUser currentUser].coreUser visualableAlertMessages] mutableCopy] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;    
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return @"2015-06-26";
//            break;
//            
//        case 1:
//            return @"2015-06-27";
//            break;
//            
//        default:
//            break;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2 ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1 ;
    return self.alertMessages.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlertNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"
                                                                           forIndexPath:indexPath];
    
    QY_alertMessage *msg = self.alertMessages[indexPath.row] ;
    
#warning 这个图片哪里来的？
    cell.image = [UIImage imageNamed:@"报警通知-视频截图1.png"] ;
    //都是两段视频，一段5秒
    cell.totalTime = @"0:10" ;
    
    NSDate *date = msg.pubDate ;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init] ;
    [formater setDateFormat:@"HH:mm"] ;
    
    cell.time = [formater stringFromDate:date] ;
    cell.location = @"" ;
    cell.eventType = @"移动侦测事件" ;
    cell.isRead = NO ;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AlertNotificationTableViewCell *cell = (AlertNotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
    cell.isRead = YES;
    
    QY_alertMessage *msg = self.alertMessages[indexPath.row] ;
    
    
#warning 路径怎么加
    NSString *path = msg.content;
//    path = @"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4";
//    path = @"http://jdas.qycam.com:50280/10000133/t00000000000193/motion/20150718/ 10 134234_20150718134229_2_5.avi" ;
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self.navigationController pushViewController:vc animated:NO];

    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
