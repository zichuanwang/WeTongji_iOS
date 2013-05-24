//
//  WTOtherUserProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOtherUserProfileView.h"
#import "User+Addition.h"
#import "OHAttributedLabel.h"
#import "NSString+WTAddition.h"

@interface WTOtherUserProfileView ()

@property (nonatomic, strong) User *user;

@end

@implementation WTOtherUserProfileView

+ (WTOtherUserProfileView *)createProfileViewWithUser:(User *)user {
    WTOtherUserProfileView *result = [[NSBundle mainBundle] loadNibNamed:@"WTOtherUserProfileView" owner:nil options:nil].lastObject;
    result.user = user;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureFirstSectionView];
    [self configureSecondSectionView];
    [self configureFirstSectionLabels];
    [self configureSecondSectionLabels];
}

- (void)configureSecondSectionLabels {
    self.birthdayDisplayLabel.text = NSLocalizedString(@"Birthday", nil);
    self.studentNumberDisplayLabel.text = NSLocalizedString(@"Student NO.", nil);
    self.majorDisplayLabel.text = NSLocalizedString(@"Major", nil);
    self.phoneDisplayLabel.text = NSLocalizedString(@"Phone", nil);
    self.emailDisplayLabel.text = NSLocalizedString(@"Email", nil);
    self.weiboDisplayLabel.text = NSLocalizedString(@"Sina Weibo", nil);
    self.qqDisplayLabel.text = NSLocalizedString(@"QQ", nil);
    self.dormDisplayLabel.text = NSLocalizedString(@"Dorm", nil);
    
    self.birthdayLabel.text = [NSString yearMonthDayConvertFromDate:self.user.birthday];
    self.studentNumberLabel.text = self.user.studentNumber;
    self.majorLabel.text = self.user.major;
    self.phoneLabel.text = self.user.phoneNumber;
    self.emailLabel.text = self.user.emailAddress;
    NSString *sinaWeiboName = self.user.sinaWeiboName;
    if ([sinaWeiboName characterAtIndex:0] != '@') {
        sinaWeiboName = [NSString stringWithFormat:@"@%@", sinaWeiboName];
    }
    self.weiboLabel.text = sinaWeiboName;
    self.qqLabel.text = self.user.qqAccount;
    // TODO:
    self.dormLabel.text = self.user.department;
}

- (void)configureFirstSectionLabels {
    NSArray *countNumberArray = @[@(2), @(4)];
    NSArray *descriptionArray = @[NSLocalizedString(@" Friends", nil),
                                  NSLocalizedString(@" Activities", nil)];
    NSArray *labels = @[self.friendLabel,
                        self.activityLabel];
    
    for (int i = 0; i < countNumberArray.count; i++) {
        OHAttributedLabel *label = labels[i];
        NSNumber *countNumber = countNumberArray[i];
        NSString *description = descriptionArray[i];
        NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%d%@", countNumber.integerValue, description]];
        [attributedString setAttributes:[label.attributedText attributesAtIndex:label.attributedText.length - 1 effectiveRange:NULL] range:NSMakeRange(0, attributedString.length)];
        [attributedString setTextBold:YES range:NSMakeRange(0, countNumber.stringValue.length)];
        label.attributedText = attributedString;
    }
}

- (void)configureFirstSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.firstSectionBgImageView.image = bgImage;
}

- (void)configureSecondSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.secondSectionBgImageView.image = bgImage;
    
    self.detailInformationDisplayLabel.text = NSLocalizedString(@"Detail Information", nil);
}

@end