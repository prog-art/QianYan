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

@interface AccountInfoViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
    
    //disdlay cycle ;
    
//    UIImage *image = [UIImage imageNamed:@"头像"] ;
    
    BOOL isDir = NO ;
    
    NSString *path = [[QY_FileService getDocPath] stringByAppendingString:[QY_JPROUrlFactor pathForUserAvatar:[QYUser currentUser].userId]] ;
    BOOL exist = [[QY_FileService fileManager] fileExistsAtPath:path isDirectory:&isDir] ;
    
#warning 有问题。注意头像过期。
    UIImage *avatarImage ;
    if ( exist ) {
        avatarImage = [QY_FileService getImageDataAtPath:path] ;
        [self.avatarBtn setImage:avatarImage forState:UIControlStateNormal] ;
    } else {
        avatarImage = [UIImage imageNamed:@"头像"] ;
        
        NSString *urlStr = [QY_JPROUrlFactor uploadURLWithHost:@"qycam.com" Port:@"50300" Path:path] ;
        
        [self.avatarBtn.imageView setImageWithURL:[NSURL URLWithString:urlStr]
                                 placeholderImage:avatarImage] ;
    }
    
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

#pragma mark - 

- (UIActionSheet *)getAImagePickerActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil] ;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
    return actionSheet ;
}

- (IBAction)editAvatarBtnClicked:(UIButton *)sender {
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
        
        imageToSave = [UIImage QY_scaleFromImage:imageToSave toSize:CGSizeMake(50, 50)] ;
        
    
        NSData *pngData = UIImageJPEGRepresentation(imageToSave, 1.0);

        __block NSString *path = [QY_JPROUrlFactor pathForUserAvatar:[QYUser currentUser].userId] ;
        
        [[QY_JPROHttpService shareInstance] uploadFileToPath:path FileData:pngData fileName:@"headpicture.jpg" mimeType:MIMETYPE Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"上传头像成功") ;
                //保存头像到本地。
                NSString *path2 ;
                path2 = [[QY_FileService getDocPath] stringByAppendingString:path] ;
                [QY_FileService saveFileAtPath:path2 Data:pngData] ;
                
                [QYUtils runInMainQueue:^{
                    [self.avatarBtn setImage:imageToSave forState:UIControlStateNormal] ;
                }] ;
                
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
