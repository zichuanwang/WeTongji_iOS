//
//  WTOrganizationHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationHeaderView.h"
#import "Organization+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "UIImage+StackBlur.h"
#import "WTDetailImageViewController.h"

@interface WTOrganizationHeaderView ()

@property (nonatomic, weak) Organization *org;

@end

@implementation WTOrganizationHeaderView

#pragma mark - Factory methods

+ (WTOrganizationHeaderView *)createHeaderViewWithOrganization:(Organization *)org; {
    WTOrganizationHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTOrganizationHeaderView" owner:nil options:nil].lastObject;
    result.org = org;
    [result configureView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:result action:@selector(didTagAvatarImageView:)];
    [result.avatarContainerView addGestureRecognizer:tapGestureRecognizer];
    
    return result;
}

#pragma mark - UI methods 

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    [self.avatarImageView loadImageWithImageURLString:self.org.avatar];
}

- (void)configureBottomButtons {
    [self configureActivityButton];
    [self configureNewsButton];
}

- (void)configureActivityButton {
    NSString *activityCountString = [NSString stringWithFormat:@"%d%@", self.org.activityCount.integerValue,
                                     self.org.activityCount.integerValue > 1 ? NSLocalizedString(@" Activities", nil) : NSLocalizedString(@" Activity", nil)];
    [self.activityButton setTitle:activityCountString forState:UIControlStateNormal];
}

- (void)configureNewsButton {
    NSString *activityCountString = [NSString stringWithFormat:@"%d%@", self.org.newsCount.integerValue, NSLocalizedString(@" News", nil)];
    [self.newsButton setTitle:activityCountString forState:UIControlStateNormal];
}

- (void)configureEmailLabel {
    self.emailLabel.text = self.org.email;
    self.emailLabel.layer.masksToBounds = NO;
    self.emailLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.emailLabel.layer.shadowOpacity = 0.3f;
    self.emailLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.emailLabel.layer.shadowRadius = 1.0f;
    [self.emailLabel sizeToFit];
    [self.emailLabel resetOriginY:self.orgNameLabel.frame.origin.y + self.orgNameLabel.frame.size.height + 4.0f];
}

- (void)configureAdministratorLabel {
    self.adminLabel.text = [NSString stringWithFormat:@"%@ %@", self.org.adminTitle, self.org.administrator];
    self.adminLabel.layer.masksToBounds = NO;
    self.adminLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.adminLabel.layer.shadowOpacity = 0.3f;
    self.adminLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.adminLabel.layer.shadowRadius = 1.0f;
    [self.adminLabel sizeToFit];
    [self.adminLabel resetOriginY:self.emailLabel.frame.origin.y + self.emailLabel.frame.size.height + 4.0f];
}

#define MAX_ORG_NAME_LABEL_HEIGHT   48.0f

- (void)configureOrganizationNameLabel {
    self.orgNameLabel.text = self.org.name;
    self.orgNameLabel.layer.masksToBounds = NO;
    self.orgNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.orgNameLabel.layer.shadowOpacity = 0.3f;
    self.orgNameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.orgNameLabel.layer.shadowRadius = 1.0f;
    [self.orgNameLabel sizeToFit];
    if (self.orgNameLabel.frame.size.height > MAX_ORG_NAME_LABEL_HEIGHT) {
        [self.orgNameLabel resetHeight:MAX_ORG_NAME_LABEL_HEIGHT];
    }
}

- (void)configureLabels {
    [self configureOrganizationNameLabel];
    [self configureEmailLabel];
    [self configureAdministratorLabel];
}

- (void)configureView {
    [self configureAvatarImageView];
    [self configureOrganizerBgImageView];
    [self configureLabels];
    [self configureBottomButtons];
}

- (void)configureOrganizerBgImageView {
    [self.avatarBgImageView loadImageWithImageURLString:self.org.bgImage];
}

#pragma mark - Gesture recognizer handler

- (void)didTagAvatarImageView:(UIGestureRecognizer *)gesture {
    UIImageView *currentImageView = self.avatarImageView;
    CGRect imageViewFrame = [self.superview.superview convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.org.avatar
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:nil];
}

@end
