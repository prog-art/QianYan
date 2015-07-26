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

@interface AlertNotificationTableViewController ()
{
    NSArray *_localMovies;
    NSArray *_remoteMovies;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AlertNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:YES];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlertNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"
                                                                           forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.image = [UIImage imageNamed:@"报警通知-视频截图1.png"];
                    cell.totalTime = @"0:42";
                    cell.time = @"17:50";
                    cell.location = @"家里客居";
                    cell.eventType = @"移动侦测事件";
                    cell.isRead = NO;
                    break;
                    
                case 1:
                    cell.image = [UIImage imageNamed:@"报警通知-视频截图2.png"];
                    cell.totalTime = @"0:16";
                    cell.time = @"17:30";
                    cell.location = @"孩子房间";
                    cell.eventType = @"人体感应事件";
                    cell.isRead = NO;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.image = [UIImage imageNamed:@"报警通知-视频截图3.png"];
                    cell.totalTime = @"1:26";
                    cell.time = @"10:06";
                    cell.location = @"商店";
                    cell.eventType = @"声音感应事件";
                    cell.isRead = NO;
                    break;
                    
                case 1:
                    cell.image = [UIImage imageNamed:@"报警通知-视频截图4.png"];
                    cell.totalTime = @"0:10";
                    cell.time = @"10:19";
                    cell.location = @"商店2";
                    cell.eventType = @"遮挡感应事件";
                    cell.isRead = NO;
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AlertNotificationTableViewCell *cell = (AlertNotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isRead = YES;
    
    NSString *path ;
    
    if ( indexPath.row == 1 ) {
        path = @"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4";
    } else {
//        path = @"rtsp://admin:12345@10.10.1.5:554/h264/ch1/main/av_stream" ;
//        path = @"rtsp://jssid:jsspass@jssaddr:port/ipncid"
//            @"t00000000000112" ;
//            @"c00000000000247" ;
        path = [NSString stringWithFormat:@"rtsp://%@:%@@%@:%@/%@",@"jss000000000001",@"12345678",@"jdas.qycam.com",@"50310",@"c00000000000247"] ;
    }
    //rtsp://jss000000000001:12345678@jdas.qycam.com:50310/c00000000000247

    
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
