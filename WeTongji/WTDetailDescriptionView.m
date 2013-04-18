//
//  WTDetailDescriptionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailDescriptionView.h"
#import "Activity.h"
#import "OHAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

@implementation WTDetailDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureViewWithManagedObject:(id)object {
    if ([object isKindOfClass:[Activity class]]) {
        Activity *activity = (Activity *)object;
        [self configureOrganizerDisplayLabelAndButton:activity.organizer];
        [self configureContentView:activity.content];
        [self configureOrganizerAvatar:activity.organizerAvatar];
        
        [self resetHeight:self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height];
    }
}

+ (WTDetailDescriptionView *)createDetailDescriptionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WTDetailDescriptionView" owner:self options:nil] lastObject];
}

#pragma mark Configure detail description view

#define CONTENT_LABEL_LINE_SPACING 6.0f

- (void)configureOrganizerDisplayLabelAndButton:(NSString *)organizerName {
    self.organizerDisplayLabel.text = NSLocalizedString(@"Organizer", nil);
    [self.organizerButton setTitle:organizerName forState:UIControlStateNormal];
}

- (void)configureContentView:(NSString *)content {
    [self configureContentLabel:content];
    [self configureContentViewBgImageView];
}

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
    UIImage *roundCornerPanel = [UIImage imageNamed:@"WTRoundCornerPanelBg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0);
    UIImage *resizableRoundCornerPanel = [roundCornerPanel resizableImageWithCapInsets:insets];
    UIImageView *aboutImageContainer = [[UIImageView alloc] initWithImage:resizableRoundCornerPanel];
    [aboutImageContainer resetSize:CGSizeMake(292.0, 60.0 + self.contentLabel.frame.size.height)];
    [aboutImageContainer resetOrigin:CGPointZero];
    
    [self.contentContainerView insertSubview:aboutImageContainer atIndex:0];
    [self.contentContainerView resetHeight:aboutImageContainer.frame.size.height];
}

- (void)configureOrganizerAvatar:(NSString *)avatarURL {
    self.organizerAvatarContainerView.layer.masksToBounds = YES;
    self.organizerAvatarContainerView.layer.cornerRadius = 3.0f;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:avatarURL]];
    [self.organizerAvatarImageView setImageWithURLRequest:request
                                         placeholderImage:nil
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                      self.organizerAvatarImageView.image = image;
                                                      [self.organizerAvatarImageView fadeIn];
                                                  }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                      
                                                  }];
}

@end
