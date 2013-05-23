//
//  WTOrganizationProfileView.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationProfileView.h"

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

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org {
    WTOrganizationProfileView *profile = [[NSBundle mainBundle]
                                          loadNibNamed:@"WTOrganizationProfileView" owner:nil options:nil].lastObject;
    profile.org = org;
    
    [profile configureView];
    
    return profile;
}

- (void)configureView
{
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.profileSectionBgImageView.image = bgImage;
    
    
    NSArray *countNumberArray = @[@(2), @(4)];
    NSArray *descriptionArray = @[NSLocalizedString(@" Activities", nil),
                                  NSLocalizedString(@" Club News", nil)];
    NSArray *labels = @[self.activityLabel,
                        self.newsLabel];
    
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

@end
