//
//  ManageGroupTableViewController.m
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ManageGroupTableViewController.h"
#import "ManageGroupTableViewCell.h"
#import "ManageGroupSearchTableViewCell.h"

@interface ManageGroupTableViewController ()

@property (nonatomic, strong) NSMutableArray *isChosenArray;

@end

@implementation ManageGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isChosenArray = [NSMutableArray array];
    
    for (int i=0; i<20; i++) {
        [self.isChosenArray addObject:[NSNumber numberWithInt:0]];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44.;
    } else {
        return 66.;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 21;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ManageGroupSearchTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        return searchCell;
    } else {
        ManageGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.name = @"Emma Watson";
        cell.avatarImage = [UIImage imageNamed:@"群组管理-选择成员头像.png"];
        if ([[self.isChosenArray objectAtIndex:indexPath.row-1] intValue] == 0) {
            cell.isChosen = NO;
        } else {
            cell.isChosen = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexpath.row:%ld", (long)indexPath.row);
    
    ManageGroupTableViewCell *cell = (ManageGroupTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row > 0) {
        if ([[self.isChosenArray objectAtIndex:indexPath.row-1] intValue] == 0) {
            
            cell.isChosen = YES;
            
            [self.isChosenArray replaceObjectAtIndex:indexPath.row-1 withObject:[NSNumber numberWithInt:1]];
            
        } else {
            cell.isChosen = NO;
            
            [self.isChosenArray replaceObjectAtIndex:indexPath.row-1 withObject:[NSNumber numberWithInt:0]];
            
        }
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
