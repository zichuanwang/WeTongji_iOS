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
    likeButton.adjustsImageWhenHighlighted = NO;
    
    self.likeButton = likeButton;
    self.frame = likeButton.frame;
    
    UIImageView *likeFlagBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTLikeButtonFlagBg"]];
    
    UILabel *friendCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, likeButton.frame.size.width, 20)];
    friendCountLabel.textAlignment = UITextAlignmentCenter;
    friendCountLabel.font = [UIFont boldSystemFontOfSize:12];
    friendCountLabel.backgroundColor = [UIColor clearColor];
    friendCountLabel.textColor = [UIColor colorWithRed:150 / 255.0f green:150 / 255.0f blue:150 / 255.0f alpha:1];
    friendCountLabel.shadowColor = [UIColor whiteColor];
    friendCountLabel.shadowOffset = CGSizeMake(0, 1);
    friendCountLabel.text = @"53";
    
    self.friendCountLabel = friendCountLabel;

    [likeButton resetOriginY:0];
    [likeFlagBg resetOriginY:0];
    [likeFlagBg resetCenterX:likeButton.frame.size.width / 2];
    [friendCountLabel resetOriginY:likeFlagBg.frame.size.height - 38];
    [self addSubview:likeFlagBg];
    [self addSubview:likeButton];
    [self addSubview:friendCountLabel];
}

@end
