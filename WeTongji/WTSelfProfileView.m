//
//  WTSelfProfileView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSelfProfileView.h"
#import "User+Addition.h"

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

- (void)configureView {
    [self configureFirstSectionView];
    [self configureSecondSectionView];
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
}

@end
