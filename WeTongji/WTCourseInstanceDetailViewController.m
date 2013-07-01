//
//  WTCourseInstanceDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseInstanceDetailViewController.h"
#import "Course+Addition.h"
#import "WTCourseInstanceHeaderView.h"
#import "WTCourseProfileView.h"
#import "WTSelectFriendsViewController.h"
#import "WTResourceFactory.h"
#import "WTShareEventFriendsViewController.h"

@interface WTCourseInstanceDetailViewController () <WTSelectFriendsViewControllerDelegate>

@property (nonatomic, strong) CourseInstance *courseInstance;

@property (nonatomic, weak) WTCourseInstanceHeaderView *headerView;
@property (nonatomic, weak) WTCourseProfileView *profileView;

@end

@implementation WTCourseInstanceDetailViewController

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

+ (WTCourseInstanceDetailViewController *)createDetailViewControllerWithCourseInstance:(CourseInstance *)courseInstance
                                                                     backBarButtonText:(NSString *)backBarButtonText {
    WTCourseInstanceDetailViewController *result = [[WTCourseInstanceDetailViewController alloc] init];
    
    result.courseInstance = courseInstance;
    
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
    WTCourseProfileView *profileView = [WTCourseProfileView createProfileViewWithCourse:self.courseInstance.course];
    [profileView resetOriginY:self.headerView.frame.size.height];
    [self.scrollView insertSubview:profileView belowSubview:self.headerView];
    self.profileView = profileView;
}

- (void)configureInviteButton {
    [self.headerView configureInviteButton];
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureHeaderView {
    WTCourseInstanceHeaderView *headerView = [WTCourseInstanceHeaderView createHeaderViewWithCourseInstance:self.courseInstance];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.courseInstance.course.isAudit) {
        [self.headerView.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.size.height + self.profileView.frame.origin.y);
}

#pragma mark - Actions

- (void)didClickFriendCountButton:(UIButton *)sender {
    WTShareEventFriendsViewController *vc = [WTShareEventFriendsViewController createViewControllerWithEvent:self.courseInstance];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickParticipateButton:(UIButton *)sender {
    BOOL participated = sender.selected;
    [self.headerView configureParticipateButtonStatus:participated];
    
    if (participated) {
        [self.headerView.inviteButton fadeIn];
    }
    else {
        [self.headerView.inviteButton fadeOut];
    }
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set course scheduled:%d succeeded", participated);
        sender.userInteractionEnabled = YES;
        self.courseInstance.scheduled = !self.courseInstance.scheduled;
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set course scheduled:%d, reason:%@", participated, error.localizedDescription);
        sender.userInteractionEnabled = YES;
        [self.headerView configureParticipateButtonStatus:!participated];
        
        if (!participated) {
            [self.headerView.inviteButton fadeIn];
            [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:self.courseInstance];
        }
        else {
            [self.headerView.inviteButton fadeOut];
            [[WTCoreDataManager sharedManager].currentUser removeScheduledEventsObject:self.courseInstance];
        }
        
        [WTErrorHandler handleError:error];
    }];
    
    [request setCourseScheduled:participated courseID:self.courseInstance.course.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

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
        [self configureInviteButton];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self configureInviteButton];
    }];
    NSMutableArray *userIDArray = [NSMutableArray array];
    for (User *user in vc.selectedFriendsArray) {
        [userIDArray addObject:user.identifier];
    }
    [request courseInvite:self.courseInstance.course.identifier inviteUserIDArray:userIDArray];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.headerView.inviteButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

@end
