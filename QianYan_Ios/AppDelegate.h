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

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

@property (nonatomic, strong) UITableViewController *leftDrawerViewController;
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


- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

#pragma mark - public

+ (AppDelegate *)globalDelegate;


@end

