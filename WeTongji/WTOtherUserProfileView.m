//
//  WTOtherUserProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOtherUserProfileView.h"
#import "User+Addition.h"

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
    
}

- (void)configureFirstSectionLabels {
//    NSArray *countNumberArray = @[@(2), @(4), @(3), @(1), @(24), @(33), @(122), @(22)];
//    NSArray *descriptionArray = @[NSLocalizedString(@" Friends", nil),
//                                  NSLocalizedString(@" Billboard Posts", nil),
//                                  NSLocalizedString(@" Questions", nil),
//                                  NSLocalizedString(@" Activities", nil),
//                                  NSLocalizedString(@" News", nil),
//                                  NSLocalizedString(@" Billboard Posts", nil),
//                                  NSLocalizedString(@" Organizations", nil),
//                                  NSLocalizedString(@" Users", nil)];
//    NSArray *labels = @[self.myFriendLabel,
//                        self.myBillboardPostLabel,
//                        self.myQuestionsLabel,
//                        self.likedActivityLabel,
//                        self.likedNewsLabel,
//                        self.likedBillboardPostLabel,
//                        self.likedOrganizationLabel,
//                        self.likedPersonLabel];
//    
//    for (int i = 0; i < countNumberArray.count; i++) {
//        OHAttributedLabel *label = labels[i];
//        NSNumber *countNumber = countNumberArray[i];
//        NSString *description = descriptionArray[i];
//        NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%d%@", countNumber.integerValue, description]];
//        [attributedString setAttributes:[label.attributedText attributesAtIndex:label.attributedText.length - 1 effectiveRange:NULL] range:NSMakeRange(0, attributedString.length)];
//        [attributedString setTextBold:YES range:NSMakeRange(0, countNumber.stringValue.length)];
//        label.attributedText = attributedString;
//    }
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
