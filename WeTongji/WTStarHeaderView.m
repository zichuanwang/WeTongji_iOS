//
//  WTStarHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarHeaderView.h"
#import "Star+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "UIImage+StackBlur.h"
#import "WTDetailImageViewController.h"

@interface WTStarHeaderView ()

@property (nonatomic, weak) Star *star;

@end

@implementation WTStarHeaderView

#pragma mark - Factory methods

+ (WTStarHeaderView *)createHeaderViewWithStar:(Star *)star {
    WTStarHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTStarHeaderView" owner:nil options:nil].lastObject;
    result.star = star;
    [result configureView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:result action:@selector(didTagAvatarImageView:)];
    [result.avatarContainerView addGestureRecognizer:tapGestureRecognizer];
    
    return result;
}

#pragma mark - UI methods 

#define MOTTO_LABEL_MAX_HEIGHT 57.0f

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    Star *star = self.star;
    [self.avatarImageView loadImageWithImageURLString:star.avatar success:^(UIImage *image) {
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
    
    self.starNameLabel.text = self.star.name;
    
    self.starNameLabel.layer.masksToBounds = NO;
    self.starNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.starNameLabel.layer.shadowOpacity = 0.3f;
    self.starNameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.starNameLabel.layer.shadowRadius = 1.0f;
    [self.starNameLabel sizeToFit];
    
    if (self.star.motto) {
        self.mottoLabel.text = [NSString stringWithFormat:@"“%@”", self.star.motto];
        
        self.mottoLabel.layer.masksToBounds = NO;
        self.mottoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mottoLabel.layer.shadowOpacity = 0.3f;
        self.mottoLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
        self.mottoLabel.layer.shadowRadius = 1.0f;
    } else {
        self.mottoLabel.text = nil;
    }
    
    [self.mottoLabel sizeToFit];
    
    [self.mottoLabel resetHeight:self.mottoLabel.frame.size.height > MOTTO_LABEL_MAX_HEIGHT ? MOTTO_LABEL_MAX_HEIGHT : self.mottoLabel.frame.size.height];
    [self.mottoLabel resetOriginY:self.starNameLabel.frame.size.height + self.starNameLabel.frame.origin.y + (self.starNameLabel.frame.size.height == 0 ? 0 : 12.0f)];
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
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.star.avatar
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:nil];
}

@end
