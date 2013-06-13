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

#define DESCRIPTION_LABEL_MAX_HEIGHT 57.0f

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    Organization *org = self.org;
    [self.avatarImageView loadImageWithImageURLString:org.avatar success:^(UIImage *image) {
        self.avatarImageView.image = image;
        [self.avatarImageView fadeIn];
        [self configureAvatarBgImageViewWithAvatarImage:image completion:^(UIImage *bgImage) {
            self.avatarBgImageView.image = bgImage;
            [self.avatarBgImageView fadeIn];
        }];
    } failure:nil];
}

- (void)configureView {
    
    [self configureAvatarImageView];
    
    self.orgNameLabel.text = self.org.name;
    
    self.orgNameLabel.layer.masksToBounds = NO;
    self.orgNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.orgNameLabel.layer.shadowOpacity = 0.3f;
    self.orgNameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.orgNameLabel.layer.shadowRadius = 1.0f;
    [self.orgNameLabel sizeToFit];
    
    if (self.org.about) {
        self.descriptionLabel.text = [NSString stringWithFormat:@"“%@”", self.org.about];
        
        self.descriptionLabel.layer.masksToBounds = NO;
        self.descriptionLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.descriptionLabel.layer.shadowOpacity = 0.3f;
        self.descriptionLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.descriptionLabel.layer.shadowRadius = 1.0f;
    } else {
        self.descriptionLabel.text = nil;
    }
    
    [self.descriptionLabel sizeToFit];
    
    [self.descriptionLabel resetHeight:self.descriptionLabel.frame.size.height > DESCRIPTION_LABEL_MAX_HEIGHT ? DESCRIPTION_LABEL_MAX_HEIGHT : self.descriptionLabel.frame.size.height];
    [self.descriptionLabel resetOriginY:self.orgNameLabel.frame.size.height + self.orgNameLabel.frame.origin.y + (self.orgNameLabel.frame.size.height == 0 ? 0 : 12.0f)];
}

- (void)configureAvatarBgImageViewWithAvatarImage:(UIImage *)image
                                       completion:(void (^)(UIImage *bgImage))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *resultImage = [image stackBlur:4];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
    });
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
