//
//  AccountInfoViewController.m
//  账号信息
//
//  Created by WardenAllen on 15/6/9.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AccountInfoTableViewCell.h"

#import "QY_Common.h"
#import "QY_FileService.h"
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"

@interface AccountInfoViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView ;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView ;

@property (weak) QY_user *currentUser ;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
    self.currentUser = [QYUser currentUser].coreUser ;
    
    //add action
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAvatarBtnClicked)] ;
    [self.avatarImageView addGestureRecognizer:singleTap] ;
    self.avatarImageView.userInteractionEnabled = YES ;
    
    [self.currentUser displayAvatarAtImageView:self.avatarImageView] ;
    
    [[QY_Notify shareInstance] addAvatarObserver:self selector:@selector(reloadAvatar)] ;
    [[QY_Notify shareInstance] addUserInfoObserver:self selector:@selector(reloadUserInfo)] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
    [self.tableView reloadData] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)reloadAvatar {
    [self.currentUser displayAvatarAtImageView:self.avatarImageView] ;
}

- (void)reloadUserInfo {
    [self.tableView reloadData] ;
}

- (void)dealloc {
    [[QY_Notify shareInstance] removeAvatarObserver:self] ;
    [[QY_Notify shareInstance] removeUserInfoObserver:self] ;
}

#pragma mark -- Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0 ;
    } else {
        return 18.0 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2 ;
    } else {
        return 4 ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    
    AccountInfoTableViewCell *accountCell = [[AccountInfoTableViewCell alloc] init];
    
    NSArray *account_nib = [[NSBundle mainBundle]loadNibNamed:@"AccountInfoTableViewCell" owner:self options:nil];

    NSInteger section = indexPath.section ;
    NSInteger row = indexPath.row ;
    
    switch ( section ) {
        case 0 : {
            //0
            switch ( row ) {
                case 0 : {
                    
                    for(id oneObject in account_nib){
                        if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                            accountCell = (AccountInfoTableViewCell *)oneObject;
                            accountCell.leftLabelText = @"昵称";
                            accountCell.rightLabelText = self.currentUser.nickname ;
                            return accountCell;
                        }
                    }
                    
                    break ;
                }
                    
                default:
                    return cell ;
                    break;
            }
            
            
            break ;
        }
            
        case 1 : {
            //1
            switch ( row ) {
                case 0 : {
                    
                    for(id oneObject in account_nib){
                        if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                            accountCell = (AccountInfoTableViewCell *)oneObject;
                            accountCell.leftLabelText = @"手机号认证";
                            accountCell.rightLabelText = self.currentUser.phone ;
                        }
                    }
                    
                    break ;
                }
                    
                case 1:
                    for(id oneObject in account_nib){
                        if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                            accountCell = (AccountInfoTableViewCell *)oneObject;
                            accountCell.leftLabelText = @"邮箱认证";
                            accountCell.rightLabelText = self.currentUser.email ;
                        }
                    }
                    return accountCell;
                    break;
                    
                case 2:
                    for(id oneObject in account_nib){
                        if([oneObject isKindOfClass:[AccountInfoTableViewCell class]]) {
                            accountCell = (AccountInfoTableViewCell *)oneObject;
                            accountCell.leftLabelText = @"个性签名";
                            accountCell.rightLabelText = self.currentUser.signature ;
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
                    return accountCell ;
                    break;
            }
        }
            
        default:
            
            return accountCell ;
            
            break;
    }
    return accountCell ;
}

#pragma mark -- Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] ManageNicknameViewController] animated:YES];
                    break;
                    
                case 1:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] QRCodeCardViewController] animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] PhoneNumberIdentifyViewController] animated:YES];
                    break;
                    
                case 1:
                    
                    break;
                    
                case 2:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] ManageSignatureViewController] animated:YES];
                    break;
                    
                case 3:
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 

- (UIActionSheet *)getAImagePickerActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil] ;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
    return actionSheet ;
}

- (void)editAvatarBtnClicked {
    UIActionSheet *actionSheet = [self getAImagePickerActionSheet] ;
    
    [actionSheet showInView:self.view] ;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
        case 0 : {
            //拍照
            QYDebugLog(@"拍照") ;
            [QYUtils pickImageFromCameraAtController:self] ;
            break ;
        }
            
        case 1 : {
            QYDebugLog(@"从相册选择") ;
            [QYUtils pickImageFromPhotoLibraryAtController:self] ;
            break ;
        }
            
        case 2 : {
            
            break ;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *imageToSave = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        imageToSave = [UIImage QY_scaleFromImage:imageToSave toSize:CGSizeMake(100, 100)] ;
        
        [self.currentUser saveAvatar:imageToSave complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"上传头像成功") ;
            } else {
                QYDebugLog(@"上传头像失败") ;
            }
        }] ;
    });

    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    QYDebugLog(@"取消") ;
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

@end
