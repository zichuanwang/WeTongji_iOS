//
//  WTUserProfileHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ProfileHeaderViewTypeSelf,
    ProfileHeaderViewTypeFriend,
} ProfileHeaderViewType;

@class User;

@interface WTUserProfileHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarPlaceholderImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarBgPlaceholderImageView;
@property (nonatomic, weak) IBOutlet UILabel *mottoLabel;
@property (nonatomic, weak) IBOutlet UIView *personalInfoContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *genderIndicatorImageView;
@property (nonatomic, weak) IBOutlet UILabel *schoolLabel;
@property (nonatomic, weak) IBOutlet UIButton *functionButton;

@property (nonatomic, assign) ProfileHeaderViewType type;

+ (WTUserProfileHeaderView *)createProfileHeaderViewWithUser:(User *)user;

- (void)updateAvatarImage:(UIImage *)image;

- (void)updateView;

@end
