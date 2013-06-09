//
//  WTCourseHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseHeaderView.h"
#import "Course+Addition.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"

@interface WTCourseHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIImageView *locationDisclosureImageView;

@property (nonatomic, weak) Course *course;

@end

@implementation WTCourseHeaderView

+ (WTCourseHeaderView *)createHeaderViewWithCourse:(Course *)course {
    WTCourseHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCourseHeaderView" owner:nil options:nil].lastObject;
    
    result.course = course;
    
    [result configureView];
    
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureBackgroundColor];
    [self configureLocationButton];
    [self configureBottomButtons];
    [self configureTimeLabel];
    [self configureTitleLabelAndCalculateHeight];
}

- (void)configureLocationButton {
    [self.locationButton setTitle:self.course.where forState:UIControlStateNormal];
    CGFloat locationButtonHeight = self.locationButton.frame.size.height;
    CGFloat locationButtonCenterY = self.locationButton.center.y;
    CGFloat locationButtonRightBoundX = self.locationButton.frame.origin.x + self.locationButton.frame.size
    .width;
    [self.locationButton sizeToFit];
    
    CGFloat maxLocationButtonWidth = 282.0f;
    if (self.locationButton.frame.size.width > maxLocationButtonWidth) {
        [self.locationButton resetWidth:maxLocationButtonWidth];
    }
    
    [self.locationButton resetHeight:locationButtonHeight];
    [self.locationButton resetCenterY:locationButtonCenterY];
    [self.locationButton resetOriginX:locationButtonRightBoundX - self.locationButton.frame.size.width];
}

#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH    85.0f
#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y 83.0f

- (void)configureParticipateButton {
    self.participateButton = [WTResourceFactory createDisableButtonWithText:NSLocalizedString(@"Participated", nil)];
    
    if (self.participateButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.participateButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.participateButton resetOrigin:CGPointMake(311.0f - self.participateButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.participateButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.participateButton];
}

- (void)configureInviteButton {
    [self.inviteButton removeFromSuperview];
    self.inviteButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Invite", nil)];
    
    if (self.inviteButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.inviteButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.inviteButton resetOrigin:CGPointMake(9.0, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.inviteButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.inviteButton];
}

- (void)configureFriendCountButton {
    NSString *friendCountString = [NSString friendCountStringConvertFromCountNumber:@(3)];
    self.friendCountButton = [WTResourceFactory createNormalButtonWithText:friendCountString];
    if (self.friendCountButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.friendCountButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.friendCountButton resetOrigin:CGPointMake(self.participateButton.frame.origin.x - 8 - self.friendCountButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.friendCountButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.friendCountButton];
}

- (void)configureTimeLabel {
    self.timeLabel.text = self.course.yearMonthDayBeginToEndTimeString;
}

#define BRIEF_DESCRIPTION_VIEW_BOTTOM_BUTTONS_HEIGHT    40.0f

- (void)configureTitleLabelAndCalculateHeight {
    self.titleLabel.text = self.course.what;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

- (void)configureBackgroundColor {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configureBottomButtons {
    [self configureParticipateButton];
    [self configureFriendCountButton];
    [self configureInviteButton];
}

@end
