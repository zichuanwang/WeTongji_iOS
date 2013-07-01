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
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"
#import "WTScheduledActivityViewController.h"
#import "WTScheduledCourseViewController.h"

@interface WTUserDetailViewController () <UIAlertViewDelegate>

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
    if ([WTCoreDataManager sharedManager].currentUser == user)
        return nil;
    
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
    
    [profileView.scheduledActivityButton addTarget:self action:@selector(didClickScheduledActivityButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.scheduledCourseButton addTarget:self action:@selector(didClickScheduledCourseButton:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Logic methods

- (void)changeFriendRelationship:(BOOL)isFriend {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Add friend success:%@", responseObject);
        [[[UIAlertView alloc] initWithTitle:@"注意" message:isFriend ? @"已删除好友" : @"已发送好友添加请求。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        [[WTCoreDataManager sharedManager].currentUser removeFriendsObject:self.user];
        [self.profileHeaderView configureFunctionButton];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Add friend failure:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
        [self.profileHeaderView configureFunctionButton];
    }];
    if (isFriend)
        [request removeFriend:self.user.identifier];
    else
        [request inviteFriends:@[self.user.identifier]];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.profileHeaderView.functionButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - Actions

- (void)didClickChangeRelationshipButton:(UIButton *)sender {
    BOOL isFriend = [[WTCoreDataManager sharedManager].currentUser.friends containsObject:self.user];
    if (!isFriend)
        [self changeFriendRelationship:NO];
    else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:[NSString deleteFriendStringForFriendName:self.user.name] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] show];
    }
}

- (void)didClickScheduledActivityButton:(UIButton *)sender {
    WTScheduledActivityViewController *vc = [WTScheduledActivityViewController createViewControllerWithUser:self.user];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickScheduledCourseButton:(UIButton *)sender {
    WTScheduledCourseViewController *vc = [WTScheduledCourseViewController createViewControllerWithUser:self.user];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.user;
}

#pragma mark - UIActionSheetDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self changeFriendRelationship:YES];
    }
}

@end
