//
//  WTCourseProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseProfileView.h"
#import "Course+Addition.h"

@interface WTCourseProfileView ()

@property (nonatomic, weak) Course *course;

@end

@implementation WTCourseProfileView

+ (WTCourseProfileView *)createProfileViewWithCourse:(Course *)course {
    WTCourseProfileView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCourseProfileView" owner:nil options:nil].lastObject;
    result.course = course;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureFirstSectionView];
    [self configureFirstSectionLabels];
}

- (void)configureFirstSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.firstSectionBgImageView.image = bgImage;
}

- (void)configureFirstSectionLabels {
    self.teacherDisplayLabel.text = NSLocalizedString(@"Teacher", nil);
    self.courseNumberDisplayLabel.text = NSLocalizedString(@"Course NO.", nil);
    self.creditDisplayLabel.text = NSLocalizedString(@"Credit", nil);
    self.hoursDisplayLabel.text = NSLocalizedString(@"Hours", nil);
    self.typeDisplayLabel.text = NSLocalizedString(@"Type", nil);
    
    self.teacherLabel.text = self.course.info.teacher;
    self.courseNumberLabel.text = self.course.info.courseNo;
    self.creditLabel.text = [NSString stringWithFormat:@"%.1f", self.course.info.credit.floatValue];
    self.hoursLabel.text = self.course.info.hours.stringValue;
    self.typeLabel.text = self.course.info.required;
}

@end
