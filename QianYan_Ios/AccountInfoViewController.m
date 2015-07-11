//
//  AccountInfoViewController.m
//  账号信息
//
//  Created by WardenAllen on 15/6/9.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AccountInfoTableViewCell.h"

@interface AccountInfoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark -- Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    } else {
        return 18.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    
    AccountInfoTableViewCell *accountCell = [[AccountInfoTableViewCell alloc] init];
    
    NSArray *account_nib = [[NSBundle mainBundle]loadNibNamed:@"AccountInfoTableViewCell" owner:self options:nil];

    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            for(id oneObject in account_nib){
                if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                    accountCell = (AccountInfoTableViewCell *)oneObject;
                    accountCell.leftLabelText = @"昵称";
                    accountCell.rightLabelText = @"大静静";
                    return accountCell;
                }
            }
        } else {
            return cell;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                for(id oneObject in account_nib){
                    if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                        accountCell = (AccountInfoTableViewCell *)oneObject;
                        accountCell.leftLabelText = @"手机号认证";
                        accountCell.rightLabelText = @"13550621456";
                    }
                }
                return accountCell;
                break;
                
            case 1:
                for(id oneObject in account_nib){
                    if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                        accountCell = (AccountInfoTableViewCell *)oneObject;
                        accountCell.leftLabelText = @"邮箱认证";
                        accountCell.rightLabelText = @"stephy@sohu.com";
                    }
                }
                return accountCell;
                break;
                
            case 2:
                for(id oneObject in account_nib){
                    if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                        accountCell = (AccountInfoTableViewCell *)oneObject;
                        accountCell.leftLabelText = @"个性签名";
                        accountCell.rightLabelText = @"80后的奋斗!";
                    }
                }
                return accountCell;
                break;
                
            case 3:
                for(id oneObject in account_nib){
                    if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                        accountCell = (AccountInfoTableViewCell *)oneObject;
                        accountCell.leftLabelText = @"地区";
                        accountCell.rightLabelText = @"北京 丰台区";
                    }
                }
                return accountCell;
                break;
                
            default:
                break;
        }
    }
    return accountCell;
}

#pragma mark -- Table View Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
