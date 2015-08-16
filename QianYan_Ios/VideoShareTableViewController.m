//
//  VideoShareTableViewController.m
//  VideoShare
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "VideoShareTableViewController.h"
#import "VideoShareTableViewCell.h"

@interface VideoShareTableViewController ()

@property (nonatomic, strong) NSMutableArray *chooseArray;

@property (nonatomic, assign) NSInteger lastRow;

@end

@implementation VideoShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastRow = -1;
    
    self.chooseArray = [NSMutableArray array];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
    [self.chooseArray addObject:[NSNumber numberWithBool:NO]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chooseArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.isChosen = NO;
    cell.image = [UIImage imageNamed:@"报警通知-视频截图1"];
    cell.time = @"08-16 18:00";
    cell.durationTime = @"00:14";
    cell.location = @"卧室";
    cell.eventType = @"移动侦测事件";
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoShareTableViewCell *cell = (VideoShareTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BOOL isChosen = [[self.chooseArray objectAtIndex:indexPath.row] boolValue];
    if (isChosen) {
        cell.isChosen = NO;
        [self.chooseArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    } else {
        if (self.lastRow != -1) {
            VideoShareTableViewCell *lastCell = (VideoShareTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastRow inSection:0]];
            lastCell.isChosen = NO;
            [self.chooseArray replaceObjectAtIndex:self.lastRow withObject:[NSNumber numberWithBool:NO]];
        }
        self.lastRow = indexPath.row;
        cell.isChosen = YES;
        [self.chooseArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (IBAction)doneBtnClicked:(id)sender {
}


@end
