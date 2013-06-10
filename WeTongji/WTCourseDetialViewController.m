//
//  WTCourseDetialViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseDetialViewController.h"
#import "Course+Addition.h"
#import "WTCourseHeaderView.h"
#import "WTCourseProfileView.h"
#import "WTSelectFriendsViewController.h"
#import "WTResourceFactory.h"

@interface WTCourseDetialViewController () <WTSelectFriendsViewControllerDelegate>

@property (nonatomic, strong) Course *course;

@property (nonatomic, weak) WTCourseHeaderView *headerView;
@property (nonatomic, weak) WTCourseProfileView *profileView;

@end

@implementation WTCourseDetialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTCourseDetialViewController *)createCourseDetailViewControllerWithCourse:(Course *)course
                                                           backBarButtonText:(NSString *)backBarButtonText {
    WTCourseDetialViewController *result = [[WTCourseDetialViewController alloc] init];
    result.course = course;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureProfileView {
    WTCourseProfileView *profileView = [WTCourseProfileView createProfileViewWithCourse:self.course];
    [profileView resetOriginY:self.headerView.frame.size.height];
    [self.scrollView insertSubview:profileView belowSubview:self.headerView];
    self.profileView = profileView;
}

- (void)configureHeaderView {
    WTCourseHeaderView *headerView = [WTCourseHeaderView createHeaderViewWithCourse:self.course];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
    
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.size.height + self.profileView.frame.origin.y);
}

#pragma mark - Actions

- (void)didClickInviteButton:(UIButton *)sender {
    [WTSelectFriendsViewController showWithDelegate:self];
}

#pragma mark - WTSelectFriendsViewControllerDelegate

- (void)selectFriendViewControllerDidDismiss:(WTSelectFriendsViewController *)vc {
    if (vc.selectedFriendsArray.count == 0) {
        return;
    }
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Course invite success:%@", responseObject);
        [[[UIAlertView alloc] initWithTitle:@"注意" message:@"邀请好友成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        [self.headerView configureInviteButton];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self.headerView configureInviteButton];
    }];
    NSMutableArray *userIDArray = [NSMutableArray array];
    for (User *user in vc.selectedFriendsArray) {
        [userIDArray addObject:user.identifier];
    }
    [request courseInvite:self.course.identifier inviteUserIDArray:userIDArray];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.headerView.inviteButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

@end
