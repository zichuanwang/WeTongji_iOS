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

#define DETAIL_VIEW_BOTTOM_INDENT   10.0f

- (void)configureView {
    [self configureContentLabelWithContent:self.org.about];
    [self configureContentViewBgImageView];
    
    [self resetHeight:self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + DETAIL_VIEW_BOTTOM_INDENT];
}

#define CONTENT_LABEL_LINE_SPACING 6.0f

- (void)configureContentLabelWithContent:(NSString *)content {
    self.aboutDisplayLabel.text = NSLocalizedString(@"About", nil);
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    [contentAttributedString setAttributes:[self.contentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
    
    [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    self.contentLabel.attributedText = contentAttributedString;
    
    CGFloat contentLabelHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 200000.0f)].height;
    
    [self.contentLabel resetHeight:contentLabelHeight];
    
    self.contentLabel.automaticallyAddLinksForType = 0;    
}

- (void)configureContentViewBgImageView {
    UIImage *roundCornerPanelImage = [[UIImage imageNamed:@"WTRoundCornerPanelBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f)];
    UIImageView *aboutImageContainer = [[UIImageView alloc] initWithImage:roundCornerPanelImage];
    [aboutImageContainer resetSize:CGSizeMake(self.contentContainerView.frame.size.width, 60.0 + self.contentLabel.frame.size.height)];
    [aboutImageContainer resetOrigin:CGPointZero];
    
    [self.contentContainerView insertSubview:aboutImageContainer atIndex:0];
    [self.contentContainerView resetHeight:aboutImageContainer.frame.size.height];
}

@end
