//
//  WTTableView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-31.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTTableView.h"

@interface WTTableView ()

@property (nonatomic, strong) UIImageView *topPlaceholderImageView;

@end

@implementation WTTableView

- (void)didMoveToSuperview {
    if (!self.topPlaceholderImageView.superview) {
        [self addSubview:self.topPlaceholderImageView];
        [self sendSubviewToBack:self.topPlaceholderImageView];
    }
}

#pragma mark - Properties

- (UIImageView *)topPlaceholderImageView {
    if (!_topPlaceholderImageView) {
        UIImage *placeholderImage = [UIImage imageNamed:@"WTBluePlaceholderImage.jpg"];
        _topPlaceholderImageView = [[UIImageView alloc] initWithImage:placeholderImage];
        [_topPlaceholderImageView setAutoresizingMask:UIViewAutoresizingNone];
        [_topPlaceholderImageView resetOriginY:-_topPlaceholderImageView.frame.size.height];
        
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTScrollViewPlaceholderShadowUnit"]];
        [shadowImageView resetOriginY:_topPlaceholderImageView.frame.size.height - shadowImageView.frame.size.height];
        [shadowImageView resetWidth:320.0f];
        [_topPlaceholderImageView addSubview:shadowImageView];
    }
    return _topPlaceholderImageView;
}

@end
