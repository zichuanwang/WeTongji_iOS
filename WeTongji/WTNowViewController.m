//
//  WTNowViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowViewController.h"
#import "WTResourceFactory.h"
#import "WTNowBaseCell.h"
#import "WTNowTableViewController.h"
#import "WTCoreDataManager.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTLoginViewController.h"
#import "WTNowBarTitleView.h"

@interface WTNowViewController () <WTNowBarTitleViewDelegate>

@property (nonatomic, strong) WTNowTableViewController *nowTableViewController;
@property (nonatomic, strong) NSIndexPath *nowIndexPath;
@property (nonatomic, strong) WTNowBarTitleView *barTitleView;

@end

@implementation WTNowViewController
@synthesize nowTableViewController = _nowTableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureTableViewController];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(handleCurrentUserDidChangeNotification:)
                                                                        target:self];
    
    if (![WTCoreDataManager sharedManager].currentUser) {
        [WTLoginViewController show:NO];
    }
    
    self.barTitleView.weekNumber = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.nowTableViewController viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (WTNowBarTitleView *)barTitleView {
    if (!_barTitleView) {
        _barTitleView = [WTNowBarTitleView createBarTitleViewWithDelegate:self];
    }
    return _barTitleView;
}

#pragma mark - Notification handler

- (void)handleCurrentUserDidChangeNotification:(NSNotification *)notification {    
    if ([WTCoreDataManager sharedManager].currentUser) {
        if (self.nowTableViewController) {
            [self.nowTableViewController changeCurrentUser];
        } else {
            [self configureTableViewController];
        }
    } else {
        [self.nowTableViewController.view removeFromSuperview];
        self.nowTableViewController = nil;
    }
}

#pragma mark - UI methods

- (void)configureTableViewController {
    if ([WTCoreDataManager sharedManager].currentUser) {
        self.nowTableViewController = [[WTNowTableViewController alloc] init];
        [self.nowTableViewController.view resetHeight:self.view.frame.size.height];
        [self.view addSubview:self.nowTableViewController.view];
    }
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = self.barTitleView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Now", nil)
                                                                                       target:self
                                                                                       action:@selector(didClickNowButton:)];
}

#pragma mark - Actions

- (void)didClickNowButton:(UIButton *)sender {
    if ([WTCoreDataManager sharedManager].currentUser)
        [self.nowTableViewController scrollToNow];
    else
        [WTLoginViewController show:NO];
}

#pragma mark - WTNowBarTitleViewDelegate

- (void)nowBarTitleViewDidClickNextButton {
    
}

- (void)nowBarTitleViewDidClickPrevButton {
    
}

@end
