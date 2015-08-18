//
//  VideoShareTableViewController.m
//  VideoShare
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "VideoShareTableViewController.h"
#import "VideoShareTableViewCell.h"

#import "QY_Common.h"

@interface VideoShareTableViewController ()<UIAlertViewDelegate> {
    NSIndexPath *choosedIndexPath ;
}

@property (nonatomic, assign) NSInteger lastRow ;

@property (nonatomic, strong) NSMutableArray *dataSource ;

@end

@implementation VideoShareTableViewController

#pragma mark - getter && setter 

- (NSMutableArray *)dataSource {
    return _dataSource ? : ( _dataSource = [NSMutableArray array]) ;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.lastRow = -1 ;
    
    choosedIndexPath = nil ;
    self.dataSource = [[[QYUser currentUser].coreUser visualableAlertMessages] mutableCopy] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100. ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath] ;

    BOOL isChosen = NO ;
    if (  [indexPath isEqual:choosedIndexPath] ) {
        isChosen = YES ;
    }
    
    QY_alertMessage *msg = self.dataSource[indexPath.row] ;
    
    cell.isChosen = isChosen ;
#warning 这个图片哪里来的？
    cell.image = [UIImage imageNamed:@"报警通知-视频截图1"] ;
    
    NSDate *date = msg.pubDate ;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init] ;
    [formater setDateFormat:@"HH:mm"] ;
    
    cell.time = [formater stringFromDate:date] ;
    
    cell.durationTime = @"00:10" ;
    cell.location = @"" ;
    cell.eventType = @"移动侦测事件" ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoShareTableViewCell *cell = (VideoShareTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] ;
    
    BOOL isChosen = cell.isChosen ;
    isChosen = isChosen ^ TRUE ;
    cell.isChosen = isChosen ;
    if ( isChosen ) {
        if ( choosedIndexPath ) {
            [(VideoShareTableViewCell *)[self.tableView cellForRowAtIndexPath:choosedIndexPath] setIsChosen:NO] ;
            choosedIndexPath = nil ;
        }
        choosedIndexPath = indexPath ;
    } else {
        choosedIndexPath = nil ;
    }

    self.navigationItem.rightBarButtonItem.enabled = ( nil == choosedIndexPath ) ? NO : YES ;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

#pragma mark - Actions

- (IBAction)doneBtnClicked:(id)sender {
    [self showInputAlertView] ;
}

#pragma mark - helper

- (void)showInputAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"顺便说两句吧～" message:nil delegate:self cancelButtonTitle:@"不说了" otherButtonTitles:@"确认发表", nil] ;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alertView show] ;
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( alertView.cancelButtonIndex != buttonIndex ) {
        NSString *content = [alertView textFieldAtIndex:0].text ;
#warning 这里上传，重构到User里去。
        QY_alertMessage *msg = self.dataSource[choosedIndexPath.row] ;
        
        NSSet *messages = [NSSet setWithArray:@[msg.messageId]] ;
        
        [QYUtils showNetworkIndicator] ;
        [SVProgressHUD show] ;
        [[QY_JPROHttpService shareInstance] createAttachFeedWithContent:content Attaches:nil Messages:messages Complection:^(NSString *feedId, NSError *error) {
            [QYUtils hideNetworkIndicator] ;
            [SVProgressHUD dismiss] ;
            if ( feedId && !error ) {
                QYDebugLog(@"发表成功") ;
                [[QY_Notify shareInstance] postFeedNotifyWithId:feedId] ;
                
                [self.navigationController popToRootViewControllerAnimated:YES] ;
            } else {
                QYDebugLog(@"发表失败 error = %@",error) ;
                [QYUtils alertError:error] ;
            }
        }] ;
    }
}

@end