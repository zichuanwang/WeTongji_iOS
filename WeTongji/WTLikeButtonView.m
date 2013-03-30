//
//  WTLikeButtonView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLikeButtonView.h"

@interface WTLikeButtonView ()

@property (nonatomic, strong) UILabel *likeCountLabel;

@end

@implementation WTLikeButtonView

+ (WTLikeButtonView *)createLikeButtonViewWithTarget:(id)target action:(SEL)action {
    WTLikeButtonView *result = [[WTLikeButtonView alloc] init];
    [result configureLikeButton];
    [result.likeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return result;
}

- (void)setLikeCount:(NSUInteger)likeCount {
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCount];
}

- (NSUInteger)getLikeCount {
    return self.likeCountLabel.text.integerValue;
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
    
    UILabel *likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, likeButton.frame.size.width, 20)];
    likeCountLabel.textAlignment = NSTextAlignmentCenter;
    likeCountLabel.font = [UIFont boldSystemFontOfSize:10];
    likeCountLabel.backgroundColor = [UIColor clearColor];
    likeCountLabel.textColor = [UIColor colorWithRed:150 / 255.0f green:150 / 255.0f blue:150 / 255.0f alpha:1];
    likeCountLabel.shadowColor = [UIColor whiteColor];
    likeCountLabel.shadowOffset = CGSizeMake(0, 1);
    likeCountLabel.text = @"53";
    
    self.likeCountLabel = likeCountLabel;

    [likeButton resetOriginY:1];
    [likeFlagBg resetOriginY:0];
    [likeFlagBg resetCenterX:likeButton.frame.size.width / 2];
    [likeCountLabel resetOriginY:likeFlagBg.frame.size.height - 38];
    [self addSubview:likeFlagBg];
    [self addSubview:likeButton];
    [self addSubview:likeCountLabel];
}

@end
