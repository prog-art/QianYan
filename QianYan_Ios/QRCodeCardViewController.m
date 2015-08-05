//
//  QRCodeCardViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QRCodeCardViewController.h"
#import "QRCodeCardTableViewCell.h"
#import "AppDelegate.h"

#import "QY_Common.h"

@interface QRCodeCardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *potraitImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIButton *VIPButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property (nonatomic, weak) QYUser *user ;

@end

@implementation QRCodeCardViewController

- (QYUser *)user {
    if ( !_user ) {
        _user = [QYUser currentUser] ;
    }
    return _user ;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    
    UIImage *image = [QY_QRCodeUtils QY_generateQRImageOfPersonalCardWithUserId:[QYUser currentUser].userId] ;
    self.QRCodeImageView.image = image ;
    
    self.usernameLabel.text = self.user.coreUser.nickname ;
    self.genderLabel.text = self.user.coreUser.gender ;
    
    NSInteger age = [QYUtils ageWithDateOfBirth:self.user.coreUser.birthday?:[NSDate date]] ;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",(long)age] ;
    
    self.locationLabel.text = self.user.coreUser.location ;
    
    [[QYUser currentUser].coreUser displayCycleAvatarAtImageView:self.potraitImageView] ;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:YES animated:YES] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:YES] ;
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48. ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRCodeCardTableViewCell *cell = [[QRCodeCardTableViewCell alloc] init];
    NSArray *cell_nib = [[NSBundle mainBundle] loadNibNamed:@"QRCodeCardTableViewCell" owner:self options:nil] ;
    for(id oneObject in cell_nib ){
        if([oneObject isKindOfClass:[QRCodeCardTableViewCell class]]) {
            cell = (QRCodeCardTableViewCell *)oneObject;
            cell.accountID = self.user.userId ;
        }
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYDebugLog(@"selected") ;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - back

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end
