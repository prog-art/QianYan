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


@interface AlertNotificationTableViewController ()
{
    NSArray *_localMovies ;
    NSArray *_remoteMovies ;
    UIRefreshControl *_refreshControl ;
}

@property (strong, nonatomic) UITableView *tableView ;

@property (nonatomic) NSMutableArray *alertMessages ;

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

- (void)refreshMessage:(UIRefreshControl *)refreshControl {
    QYDebugLog(@"Refresh～") ;
    [[QY_JPROHttpService shareInstance] getAlertMessageListPage:1 NumPerPage:10 Type:140 UserId:nil cameraId:nil StartId:nil EndId:nil Check:nil Complection:^(NSArray *objects, NSError *error) {
        if ( refreshControl ) {
            [refreshControl endRefreshing] ;
        }
        
        if ( objects ) {
            QYDebugLog(@"%@",objects) ;
        } else {
            QYDebugLog(@"error = %@",error) ;
        }
    }] ;
}

#pragma mark - Life Cycle

- (void)refreshMessage {
    [self refreshMessage:nil] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addSubview:self.refreshControl] ;    
    
    self.alertMessages = [[QY_appDataCenter findObjectWithClassName:NSStringFromClass([QY_alertMessage class]) predicate:nil] mutableCopy] ;
    
    [self refreshMessage] ;
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
    switch (section) {
        case 0:
            return @"2015-06-26";
            break;
            
        case 1:
            return @"2015-06-27";
            break;
            
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
//    return self.alertMessages.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 2;
    return 1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlertNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"
                                                                           forIndexPath:indexPath];
    
//    QY_alertMessage *msg = self.alertMessages[indexPath.row] ;
    
#warning 这个图片哪里来的？
    cell.image = [UIImage imageNamed:@"报警通知-视频截图1.png"] ;
    //都是两段视频，一段5秒
    cell.totalTime = @"0:10" ;
    
    NSDate *date ;//= msg.pubDate ;
    
    date = [NSDate date] ;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init] ;
    [formater setDateFormat:@"HH:mm"] ;
    
    cell.time = [formater stringFromDate:date] ;
    cell.location = @"" ;
    cell.eventType = @"移动侦测事件" ;
    cell.isRead = NO ;
    
//    switch (indexPath.section) {
//        case 0:
//            switch (indexPath.row) {
//                case 0:
//                    cell.image = [UIImage imageNamed:@"报警通知-视频截图1.png"];
//                    cell.totalTime = @"0:42";
//                    cell.time = @"17:50";
//                    cell.location = @"家里客居";
//                    cell.eventType = @"移动侦测事件";
//                    cell.isRead = NO;
//                    break;
//                    
//                case 1:
//                    cell.image = [UIImage imageNamed:@"报警通知-视频截图2.png"];
//                    cell.totalTime = @"0:16";
//                    cell.time = @"17:30";
//                    cell.location = @"孩子房间";
//                    cell.eventType = @"人体感应事件";
//                    cell.isRead = NO;
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        case 1:
//            switch (indexPath.row) {
//                case 0:
//                    cell.image = [UIImage imageNamed:@"报警通知-视频截图3.png"];
//                    cell.totalTime = @"1:26";
//                    cell.time = @"10:06";
//                    cell.location = @"商店";
//                    cell.eventType = @"声音感应事件";
//                    cell.isRead = NO;
//                    break;
//                    
//                case 1:
//                    cell.image = [UIImage imageNamed:@"报警通知-视频截图4.png"];
//                    cell.totalTime = @"0:10";
//                    cell.time = @"10:19";
//                    cell.location = @"商店2";
//                    cell.eventType = @"遮挡感应事件";
//                    cell.isRead = NO;
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AlertNotificationTableViewCell *cell = (AlertNotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isRead = YES;
    
    NSString *path ;
    
    path = @"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4";
    
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
