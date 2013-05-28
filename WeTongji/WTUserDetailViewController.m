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
#import "WTOtherUserProfileView.h"
#import "WTCoreDataManager.h"

@interface WTUserDetailViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) WTUserProfileHeaderView *profileHeaderView;
@property (nonatomic, weak) WTOtherUserProfileView *profileView;

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
    WTOtherUserProfileView *profileView = [WTOtherUserProfileView createProfileViewWithUser:self.user];
    [profileView resetOriginY:self.profileHeaderView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.profileView = profileView;
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureProfileHeaderView {
    [self.profileHeaderView removeFromSuperview];
    WTUserProfileHeaderView *headerView = [WTUserProfileHeaderView createProfileHeaderViewWithUser:self.user];
    [self.scrollView addSubview:headerView];
    self.profileHeaderView = headerView;
    
    [headerView.functionButton addTarget:self action:@selector(didClickChangeRelationshipButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)didClickChangeRelationshipButton:(UIButton *)sender {
    BOOL isFriend = [[WTCoreDataManager sharedManager].currentUser.friends containsObject:self.user];
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Add friend success:%@", responseObject);
        [[[UIAlertView alloc] initWithTitle:@"注意" message:isFriend ? @"已删除好友" : @"已发送好友添加请求。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Add friend failure:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    if (isFriend)
        [request removeFriend:self.user.identifier];
    else
        [request inviteFriend:self.user.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
