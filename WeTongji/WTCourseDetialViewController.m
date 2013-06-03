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

@interface WTCourseDetialViewController ()

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
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.size.height + self.profileView.frame.origin.y);
}

@end
