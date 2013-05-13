//
//  WTSelfProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSelfProfileView.h"
#import "User+Addition.h"
#import "WTResourceFactory.h"

@interface WTSelfProfileView ()

@property (nonatomic, weak) User *user;

@end

@implementation WTSelfProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTSelfProfileView *)createSelfProfileViewWithUser:(User *)user {
    WTSelfProfileView *result = [[NSBundle mainBundle] loadNibNamed:@"WTSelfProfileView" owner:nil options:nil].lastObject;
    result.user = user;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureFirstSectionView];
    [self configureSecondSectionView];
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
}

#pragma mark - Actions

- (void)didClickAddFriendButton:(UIButton *)sender {
    
}

@end
