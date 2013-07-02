//
//  WTCourseBaseHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface WTCourseBaseHeaderView : UIView

@property (nonatomic, strong) UIButton *friendCountButton;
@property (nonatomic, strong) UIButton *participateButton;
@property (nonatomic, strong) UIButton *inviteButton;


#pragma mark - Methods to overwrite

- (void)configureView;

- (Course *)targetCourse;

#pragma mark - Methods called by view controllers

- (void)configureInviteButton;

- (void)configureParticipateButtonStatus:(BOOL)participated;

@end
