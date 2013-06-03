//
//  WTStarDetailDescriptionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarDetailDescriptionView.h"
#import "OHAttributedLabel.h"
#import "Star+Addition.h"

@implementation WTStarDetailDescriptionView

+ (WTStarDetailDescriptionView *)createDetailDescriptionViewWithStar:(Star *)star {
    WTStarDetailDescriptionView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTStarDetailDescriptionView" owner:self options:nil] lastObject];
     
    [result configureViewWithStar:star];
    
    return result;
}

#pragma mark - UI methods

#define DETAIL_VIEW_BOTTOM_INDENT   10.0f

- (void)configureViewWithStar:(Star *)star {
    [self configureContentLabel:star.content];
    [self configureContentViewBgImageView];
    
    [self resetHeight:self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + DETAIL_VIEW_BOTTOM_INDENT];
}

#define CONTENT_LABEL_LINE_SPACING 6.0f


- (void)configureContentLabel:(NSString *)content {
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
