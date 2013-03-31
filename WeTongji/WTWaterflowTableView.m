//
//  WTWaterflowTableView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-31.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTWaterflowTableView.h"

@implementation WTWaterflowTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview {
    NSLog(@"subview change:%d", self.subviews.count);
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            [self bringSubviewToFront:view];
        }
        NSLog(@"subview : %@", NSStringFromClass([view class]));
    }
}

@end
