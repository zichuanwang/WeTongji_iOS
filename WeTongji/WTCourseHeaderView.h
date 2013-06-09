//
//  WTCourseHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface WTCourseHeaderView : UIView

@property (nonatomic, strong) UIButton *friendCountButton;
@property (nonatomic, strong) UIButton *participateButton;
@property (nonatomic, strong) UIButton *inviteButton;

+ (WTCourseHeaderView *)createHeaderViewWithCourse:(Course *)course;

- (void)configureInviteButton;

@end
