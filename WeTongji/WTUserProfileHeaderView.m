//
//  WTUserProfileHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserProfileHeaderView.h"
#import "User+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "UIImage+StackBlur.h"
#import "UIImage+ProportionalFill.h"

@interface WTUserProfileHeaderView ()

@property (nonatomic, weak) User *user;

@end

@implementation WTUserProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    
    User *user = self.user;
    [self.avatarImageView loadImageWithImageURLString:user.avatar success:^(UIImage *image) {
        self.avatarImageView.image = image;
        [self.avatarImageView fadeIn];
        [self configureAvatarBgImageViewWithAvatarImage:image completion:^(UIImage *bgImage) {
            self.avatarBgImageView.image = bgImage;
            [self.avatarBgImageView fadeIn];
        }];
    } failure:nil];
}

- (void)configureViewWithUser:(User *)user {
    
    self.user = user;

    [self configureAvatarImageView];
    
    if ([user.gender isEqualToString:@"男"]) {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderWhiteMaleIcon"];
    } else {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderWhiteFemaleIcon"];
    }
    
    self.schoolLabel.text = user.department;
    
    self.schoolLabel.layer.masksToBounds = NO;
    self.schoolLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.schoolLabel.layer.shadowOpacity = 0.3f;
    self.schoolLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.schoolLabel.layer.shadowRadius = 1.0f;
    
    self.mottoLabel.text = user.name;
    
    self.mottoLabel.layer.masksToBounds = NO;
    self.mottoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mottoLabel.layer.shadowOpacity = 0.3f;
    self.mottoLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.mottoLabel.layer.shadowRadius = 1.0f;
    
    [self.mottoLabel sizeToFit];
    [self.personalInfoContainerView resetOriginY:self.mottoLabel.frame.size.height + self.mottoLabel.frame.origin.y + 12.0f];
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

+ (WTUserProfileHeaderView *)createProfileHeaderViewWithUser:(User *)user {
    WTUserProfileHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTUserProfileHeaderView" owner:nil options:nil].lastObject;

    [result configureViewWithUser:user];
    return result;
}

- (void)updateAvatarImage:(UIImage *)image {
    
    [self configureAvatarBgImageViewWithAvatarImage:image completion:^(UIImage *bgImage) {
        if (self.avatarBgImageView.image) {
            self.avatarBgPlaceholderImageView.image = self.avatarBgImageView.image;
        }
        self.avatarBgImageView.image = bgImage;
        [self.avatarBgImageView fadeIn];
    }];
    
    self.avatarPlaceholderImageView.image = self.avatarImageView.image;
    self.avatarImageView.image = image;
    [self.avatarImageView fadeIn];
}

- (void)updateView {
    if (!self.avatarImageView.image) {
        [self configureAvatarImageView];
    }
}

@end
