//
//  QY_SKSTableView.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SKSTableView.h"

@implementation QY_SKSTableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.;
    } else {
        if (indexPath.row >= 1) {
            return 100.;
        } else {
            return 44.;
        }
    }
}

@end
