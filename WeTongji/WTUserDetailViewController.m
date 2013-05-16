//
//  WTUserDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserDetailViewController.h"
#import "User+Addition.h"
#import "WTUserProfileHeaderView.h"

@interface WTUserDetailViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) WTUserProfileHeaderView *profileHeaderView;

@end

@implementation WTUserDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTUserDetailViewController *)createDetailViewControllerWithUser:(User *)user
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTUserDetailViewController *result = [[WTUserDetailViewController alloc] init];

    result.user = user;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureProfileHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureProfileView {
//    [self.profileView removeFromSuperview];
//    WTCurrentUserProfileView *profileView = [WTCurrentUserProfileView createProfileViewWithUser:[WTCoreDataManager sharedManager].currentUser];
//    [profileView resetOriginY:self.profileHeaderView.frame.size.height];
//    [self.scrollView addSubview:profileView];
//    self.profileView = profileView;
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureProfileHeaderView {
    [self.profileHeaderView removeFromSuperview];
    WTUserProfileHeaderView *headerView = [WTUserProfileHeaderView createProfileHeaderViewWithUser:self.user];
    [self.scrollView addSubview:headerView];
    self.profileHeaderView = headerView;
    
    [headerView.functionButton addTarget:self action:@selector(didClickChangeAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
}

@end