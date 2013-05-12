//
//  WTMeProfileHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeProfileHeaderView.h"
#import "User+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "GPUImage.h"
#import "UIImage+ProportionalFill.h"

@implementation WTMeProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureAvatarImageView];
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

- (void)configureViewWithUser:(User *)user {

    [self.avatarImageView loadImageWithImageURLString:user.avatar success:^(UIImage *image) {
        self.avatarImageView.image = image;
        [self.avatarImageView fadeIn];
        
        BlockARCWeakSelf weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *resultImage = [image imageCroppedToFitSize:self.avatarBgImageView.frame.size];
            
            GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImageGaussianBlurFilter *stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];
            stillImageFilter.blurSize = 6.0f;
            
            [stillImageSource addTarget:stillImageFilter];
            [stillImageSource processImage];
            resultImage = [stillImageFilter imageFromCurrentlyProcessedOutput];
            
            stillImageSource = [[GPUImagePicture alloc] initWithImage:resultImage];
            stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];
            
            [stillImageSource addTarget:stillImageFilter];
            [stillImageSource processImage];
            resultImage = [stillImageFilter imageFromCurrentlyProcessedOutput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.avatarBgImageView.image = resultImage;
                [weakSelf.avatarBgImageView fadeIn];
            });
        });
        
    } failure:nil];
    
    if ([user.gender isEqualToString:@"男"]) {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderMaleIcon"];
    } else {
        self.genderIndicatorImageView.image = [UIImage imageNamed:@"WTGenderFemaleIcon"];
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

+ (WTMeProfileHeaderView *)createProfileHeaderViewWithUser:(User *)user {
    WTMeProfileHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTMeProfileHeaderView" owner:nil options:nil].lastObject;

    [result configureViewWithUser:user];
    return result;
}

@end
