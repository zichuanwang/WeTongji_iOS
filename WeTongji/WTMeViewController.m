//
//  WTMeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeViewController.h"
#import "WTFriendListViewController.h"
#import "WTCoreDataManager.h"
#import "WTResourceFactory.h"
#import "WTUserProfileHeaderView.h"
#import "WTCurrentUserProfileView.h"
#import "NSNotificationCenter+WTAddition.h"
#import "UIApplication+WTAddition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "UIImage+ProportionalFill.h"
#import "User+Addition.h"
#import "WTMeSettingViewController.h"
#import "WTFriendListViewController.h"

@interface WTMeViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WTInnerSettingViewControllerDelegate, WTRootNavigationControllerDelegate>

@property (nonatomic, weak) WTUserProfileHeaderView *profileHeaderView;
@property (nonatomic, weak) WTCurrentUserProfileView *profileView;
@property (nonatomic, readonly) UIButton *settingButton;

@end

@implementation WTMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(hanldeCurrentUserDidChangeNotification:) target:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.profileHeaderView updateView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView resetHeight:self.view.frame.size.height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification handler

- (void)hanldeCurrentUserDidChangeNotification:(NSNotification *)notification {
    if ([WTCoreDataManager sharedManager].currentUser) {
        [self configureUI];
    }
}

#pragma mark - Properties

- (UIButton *)settingButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureNavigationBar];
    [self configureProfileHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureProfileView {
    [self.profileView removeFromSuperview];
    WTCurrentUserProfileView *profileView = [WTCurrentUserProfileView createProfileViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [profileView resetOriginY:self.profileHeaderView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.profileView = profileView;
    
    [profileView.friendButton addTarget:self action:@selector(didClickFriendButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureProfileHeaderView {
    [self.profileHeaderView removeFromSuperview];
    WTUserProfileHeaderView *headerView = [WTUserProfileHeaderView createProfileHeaderViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [self.scrollView addSubview:headerView];
    self.profileHeaderView = headerView;
    
    [headerView.functionButton addTarget:self action:@selector(didClickChangeAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[WTCoreDataManager sharedManager].currentUser.name];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createSettingBarButtonWithTarget:self action:@selector(didClickSettingButton:)];
}

#pragma mark - Actions

- (void)didClickFriendButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTFriendListViewController *vc = [WTFriendListViewController createViewControllerWithUser:currentUser backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickSettingButton:(UIButton *)sender {
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (sender.selected) {
        sender.selected = NO;
        
        WTMeSettingViewController *vc = [[WTMeSettingViewController alloc] init];
        vc.delegate = self;
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

- (void)didClickChangeAvatarButton:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Photo Album", nil), nil];
    [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    if(buttonIndex == 1) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    edittedImage = [edittedImage imageScaledToFitSize:CROP_AVATAR_SIZE];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Upload avatar success:%@", responseObject);
        NSDictionary *responseDict = responseObject;
        User *currentUser = [User insertUser:responseDict[@"User"]];
        [WTCoreDataManager sharedManager].currentUser = currentUser;
        
        [self.profileHeaderView updateAvatarImage:edittedImage];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Upload avatar failure:%@", error.description);
        [WTErrorHandler handleError:error];
    }];
    [request updateUserAvatar:edittedImage];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - WTInnerSettingViewControllerDelegate

- (void)innerSettingViewController:(WTInnerSettingViewController *)controller didFinishSetting:(BOOL)modified {
    if (modified) {
        [WTClient refreshSharedClient];
    }
    
    if (![WTCoreDataManager sharedManager].currentUser) {
        [[UIApplication sharedApplication].rootTabBarController clickTabWithName:WTRootTabBarViewControllerHome];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    if (self.settingButton.selected == NO) {
        self.settingButton.selected = YES;
    } else if (self.notificationButton.selected == YES) {
        self.notificationButton.selected = NO;
    }
}

@end
