//
//  AppDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - 跳转

- (void)toRegiste ;
- (void)toLogin ;
- (void)toMain ;

#pragma mark - 左右侧栏

/**
 *  整体的ViewController
 */
@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

/**
 *  左侧栏
 */
@property (nonatomic, strong) UITableViewController *leftDrawerViewController;
/**
 *  右侧栏
 */
@property (nonatomic, strong) UITableViewController *rightDrawerViewController;
@property (nonatomic, strong) UIViewController *githubViewController;
@property (nonatomic, strong) UIViewController *drawerSettingsViewController;
@property (nonatomic, strong) UITableViewController *systemSettingsTableViewController;
@property (nonatomic, strong) UIViewController * settingsViewController;
@property (nonatomic, strong) UICollectionViewController *myPhotoGraphCollectionViewController;
@property (nonatomic, strong) UIViewController *QRCodeCardViewController;
@property (nonatomic, strong) UITableViewController *ContactTableViewController;
@property (nonatomic, strong) UIViewController *WifiSettingViewController;
@property (nonatomic, strong) UIViewController *AccountInfoViewController;
@property (nonatomic, strong) UICollectionViewController *CameraSettingCollectionViewController;
@property (nonatomic, strong) UITableViewController *RacentTableViewController;
@property (nonatomic, strong) UIViewController *PasswordManageViewController;
@property (nonatomic, strong) UIViewController *ManageNicknameViewController;
@property (nonatomic, strong) UIViewController *PhoneNumberIdentifyViewController;
@property (nonatomic, strong) UIViewController *ManageSignatureViewController;
@property (nonatomic, strong) UIViewController *FeedbackViewController;
@property (nonatomic, strong) UIViewController *TextShareViewController;
@property (nonatomic, strong) UITableViewController *WifiListViewController;
@property (nonatomic, strong) UITableViewController *SearchFriendTableViewController;
@property (nonatomic, strong) UIViewController *QRCodeDetailViewController;
@property (nonatomic, strong) UIViewController *SetRemarkNameViewController;
@property (nonatomic, strong) UITableViewController *CameraAllocationTableViewController;
@property (nonatomic, strong) UIViewController *InfoSettingViewController;
@property (nonatomic, strong) UICollectionViewController *ImageSelectCollectionViewController;
@property (nonatomic, strong) UIViewController *GroupInfoViewController;
@property (nonatomic, strong) UITableViewController *SettingsChooseCameraTableViewController;


- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

#pragma mark - public

- (UIViewController *)controllerWithId:(NSString *)VCSBID ;

+ (AppDelegate *)globalDelegate;


@end

