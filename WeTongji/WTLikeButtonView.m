//
//  WTLikeButtonView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLikeButtonView.h"

@implementation WTLikeButtonView

+ (WTLikeButtonView *)createLikeButtonViewWithTarget:(id)target action:(SEL)action {
    WTLikeButtonView *result = [[WTLikeButtonView alloc] init];
    [result configureLikeButton];
    [result.likeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return result;
}

- (void)configureLikeButton {
    UIButton *likeButton = [[UIButton alloc] init];
    UIImage *likeNormalImage = [UIImage imageNamed:@"WTLikeNormalButton"];
    UIImage *likeSelectImage = [UIImage imageNamed:@"WTLikeSelectButton"];
    [likeButton setBackgroundImage:likeNormalImage forState:UIControlStateNormal];
    [likeButton setBackgroundImage:likeSelectImage forState:UIControlStateSelected];
    [likeButton resetSize:likeNormalImage.size];
    
    self.likeButton = likeButton;
    self.frame = likeButton.frame;
    
    UIImageView *likeFlagBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTLikeButtonFlagBg"]];

    [likeButton resetOriginY:2];
    [likeFlagBg resetOriginY:0];
    [likeFlagBg resetCenterX:likeButton.frame.size.width / 2];
    [self addSubview:likeFlagBg];
    [self addSubview:likeButton];
}

@end
