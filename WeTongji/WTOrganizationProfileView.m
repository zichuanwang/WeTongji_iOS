//
//  WTOrganizationProfileView.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationProfileView.h"
#define kOrganizationProfileViewNibName @"WTOrganizationProfileView"

@interface WTOrganizationProfileView()

@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org
{
    WTOrganizationProfileView *profile = [[NSBundle mainBundle]
                                          loadNibNamed:kOrganizationProfileViewNibName owner:nil options:nil].lastObject;
    profile.org = org;
    [profile configureProfileSectionView];
    
    return profile;
}

- (void)configureProfileSectionView
{
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.profileSectionBgView.image = bgImage;
    
    self.activityLabel.text = NSLocalizedString(@"Activity", nil);
    self.newsLabel.text = NSLocalizedString(@"News", nil);
    self.websiteLabel.text = NSLocalizedString(@"Official Website", nil);
}

@end
