//
//  WTHomeSelectItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WTHomeSelectItemView.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"

@interface WTHomeSelectItemView()

@property (nonatomic, strong) UIButton *showAllButton;
@property (nonatomic, strong) WTLikeButtonView *likeButtonView;

@end

@implementation WTHomeSelectItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didMoveToSuperview {    
    if([self isMemberOfClass:[WTHomeSelectStarView class]]) {
        [self addSubview:self.likeButtonView];
    } else { // WTHomeSelectNewsView, WTHomeSelectActivityView
        [self addSubview:self.showAllButton];
    }
}

#pragma mark - Actions

- (void)didClickShowAllButon:(UIButton *)sender {
    
}

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - Properties

- (UIButton *)showAllButton {
    if(_showAllButton == nil) {
        _showAllButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Show All", nil)];
        [_showAllButton resetOrigin:CGPointMake(self.frame.size.width - _showAllButton.frame.size.width - 8, -3)];
        [_showAllButton addTarget:self action:@selector(didClickShowAllButon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showAllButton;
}

- (WTLikeButtonView *)likeButtonView {
    if(_likeButtonView == nil) {
        _likeButtonView = [WTLikeButtonView createLikeButtonViewWithTarget:self action:@selector(didClickLikeButton:)];
        [_likeButtonView resetOrigin:CGPointMake(240, -2)];
    }
    return _likeButtonView;
}

@end

@implementation WTHomeSelectNewsView

+ (WTHomeSelectNewsView *)createHomeSelectNewsView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectNewsView *result = nil;
    for(UIView *view in viewArray) {
        if([view isKindOfClass:[WTHomeSelectNewsView class]])
            result = (WTHomeSelectNewsView *)view;
    }
    return result;
}

@end

@implementation WTHomeSelectStarView

+ (WTHomeSelectStarView *)createHomeSelectStarView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectStarView *result = nil;
    for(UIView *view in viewArray) {
        if([view isKindOfClass:[WTHomeSelectStarView class]])
            result = (WTHomeSelectStarView *)view;
    }
    [result configureAvatarImageView];
    return result;
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end

@implementation WTHomeSelectActivityView

+ (WTHomeSelectActivityView *)createHomeSelectActivityView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectActivityView *result = nil;
    for(UIView *view in viewArray) {
        if([view isKindOfClass:[WTHomeSelectActivityView class]])
            result = (WTHomeSelectActivityView *)view;
    }
    return result;
}

@end
