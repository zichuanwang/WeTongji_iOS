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
#import "WTMeProfileHeaderView.h"
#import "WTSelfProfileView.h"
#import "NSNotificationCenter+WTAddition.h"

@interface WTMeViewController ()

@property (nonatomic, weak) WTMeProfileHeaderView *profileHeaderView;
@property (nonatomic, weak) WTSelfProfileView *selfProfileView;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification handler

- (void)hanldeCurrentUserDidChangeNotification:(NSNotification *)notification {
    [self configureUI];
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureNavigationBar];
    [self configureProfileHeaderView];
    [self configureSelfProfileView];
    [self configureScrollView];
}

- (void)configureSelfProfileView {
    [self.selfProfileView removeFromSuperview];
    WTSelfProfileView *profileView = [WTSelfProfileView createSelfProfileViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [profileView resetOriginY:self.profileHeaderView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.selfProfileView = profileView;
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.selfProfileView.frame.origin.y + self.selfProfileView.frame.size.height);
}

- (void)configureProfileHeaderView {
    [self.profileHeaderView removeFromSuperview];
    WTMeProfileHeaderView *headerView = [WTMeProfileHeaderView createProfileHeaderViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [self.scrollView addSubview:headerView];
    self.profileHeaderView = headerView;
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[WTCoreDataManager sharedManager].currentUser.name];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createSettingBarButtonWithTarget:self action:@selector(didClickSettingButton:)];
}

#pragma mark - Actions

- (void)didClickSettingButton:(UIButton *)sender {
    [[WTClient sharedClient] logout];
    [WTCoreDataManager sharedManager].currentUser = nil;
}

@end
