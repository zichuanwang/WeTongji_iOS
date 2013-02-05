//
//  WTLikeButtonView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLikeButtonView : UIView

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *friendCountLabel;

+ (WTLikeButtonView *)createLikeButtonViewWithTarget:(id)target action:(SEL)action;

@end
