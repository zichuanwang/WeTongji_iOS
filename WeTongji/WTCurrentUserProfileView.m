//
//  WTCurrentUserProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCurrentUserProfileView.h"
#import "User+Addition.h"
#import "WTResourceFactory.h"
#import "OHAttributedLabel.h"

@interface WTCurrentUserProfileView ()

@property (nonatomic, weak) User *user;

@end

@implementation WTCurrentUserProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTCurrentUserProfileView *)createProfileViewWithUser:(User *)user {
    WTCurrentUserProfileView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCurrentUserProfileView" owner:nil options:nil].lastObject;
    result.user = user;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureFirstSectionView];
    [self configureSecondSectionView];
    [self configureLabels];
}

- (void)configureLabels {
    NSArray *countNumberArray = @[@(2), @(4), @(3), @(1), @(24), @(33), @(122), @(22)];
    NSArray *descriptionArray = @[NSLocalizedString(@" Friends", nil),
                                  NSLocalizedString(@" Billboard Posts", nil),
                                  NSLocalizedString(@" Questions", nil),
                                  NSLocalizedString(@" Activities", nil),
                                  NSLocalizedString(@" News", nil),
                                  NSLocalizedString(@" Billboard Posts", nil),
                                  NSLocalizedString(@" Organizations", nil),
                                  NSLocalizedString(@" Users", nil)];
    NSArray *labels = @[self.myFriendLabel,
                        self.myBillboardPostLabel,
                        self.myQuestionsLabel,
                        self.likedActivityLabel,
                        self.likedNewsLabel,
                        self.likedBillboardPostLabel,
                        self.likedOrganizationLabel,
                        self.likedPersonLabel];
    
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
    
    UIButton *addFriendButton = [WTResourceFactory createAddFriendButtonWithTarget:self action:@selector(didClickAddFriendButton:)];
    [addFriendButton resetOriginX:218.0f];
    [addFriendButton resetCenterY:23.0f];
    [self.firstSectionContianerView addSubview:addFriendButton];
}

- (void)configureSecondSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.secondSectionBgImageView.image = bgImage;
    
    self.myFavoriteDisplayLabel.text = NSLocalizedString(@"My Favorite", nil);
}

#pragma mark - Actions

- (void)didClickAddFriendButton:(UIButton *)sender {
    
}

@end
