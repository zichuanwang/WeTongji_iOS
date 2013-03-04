//
//  UIView+Animation.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)fadeIn {
    self.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)fadeOut {
    self.alpha = 1;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:nil];
}

@end
