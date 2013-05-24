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

@interface WTCourseDetialViewController ()

@property (nonatomic, strong) Course *course;

@end

@implementation WTCourseDetialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureHeaderView];
    [self configureScrollView];
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

- (void)configureHeaderView {
    WTCourseHeaderView *headerView = [WTCourseHeaderView createHeaderViewWithCourse:self.course];
    [self.scrollView addSubview:headerView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
}

@end
