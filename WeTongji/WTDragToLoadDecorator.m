//
//  WTDragToLoadDecorator.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDragToLoadDecorator.h"
#import "NSString+WTAddition.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    TopViewStateNormal = 1,
	TopViewStateReady,
	TopViewStateLoading,
    TopViewStateDisabled,
} TopViewState;

typedef enum {
    BottomViewStateNormal = 1,
	BottomViewStateLoading,
    BottomViewStateDisabled,
} BottomViewState;

#define SET_BOTTOM_VIEW_STATE_DISABLED_DELAY_SEC 1

@interface WTDragToLoadDecorator ()

@property (nonatomic, strong) WTDragToLoadDecoratorTopView *topView;
@property (nonatomic, strong) WTDragToLoadDecoratorBottomView *bottomView;

@property (nonatomic, assign) TopViewState topViewState;
@property (nonatomic, assign) BottomViewState bottomViewState;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalContentInset;

@property (nonatomic, assign) BOOL alreadyObservingDragToLoadScrollView;

@property (nonatomic, assign) BOOL delayBottomViewDisable;

@end

@implementation WTDragToLoadDecorator

#pragma mark - UI methods

- (void)resetBottomViewOriginY {
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    CGFloat bottomViewOriginY = scrollView.contentSize.height + self.scrollViewOriginalContentInset.bottom;
    [self.bottomView resetOriginY:bottomViewOriginY];
}

- (void)updateTopViewUpdateTimeLabel:(BOOL)useStoredValue {
    if (![self.dataSource respondsToSelector:@selector(userDefaultKey)])
        return;
    
    NSString *customUserDefaultKey = [self.dataSource userDefaultKey];
    if (!customUserDefaultKey)
        return;
    
    NSString *storedValueKey = [NSString stringWithFormat:@"%@%@", customUserDefaultKey, @"TopViewUpdateTime"];
    NSString *updateTimeString = nil;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (useStoredValue) {
        NSString *storedValue = [standardUserDefaults stringForKey:storedValueKey];
        if (storedValue) {
            updateTimeString = storedValue;
        } else {
            updateTimeString = NSLocalizedString(@"Unknown", nil);
        }
    } else {
        updateTimeString = [NSString yearMonthDayTimeConvertFromDate:[NSDate date]];
        [standardUserDefaults setObject:updateTimeString forKey:storedValueKey];
        [standardUserDefaults synchronize];
    }
    // self.topView.updateTimeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last update", nil), updateTimeString];
}

#pragma mark - Public methods

static int kDragToLoadDecoratorObservingContext;

- (void)startObservingChangesInDragToLoadScrollView {
    if (self.alreadyObservingDragToLoadScrollView)
        return;
    self.alreadyObservingDragToLoadScrollView = YES;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:&kDragToLoadDecoratorObservingContext];
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:&kDragToLoadDecoratorObservingContext];
}

- (void)stopObservingChangesInDragToLoadScrollView {
    if (!self.alreadyObservingDragToLoadScrollView)
        return;
    self.alreadyObservingDragToLoadScrollView = NO;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    [scrollView removeObserver:self forKeyPath:@"contentSize" context:&kDragToLoadDecoratorObservingContext];
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:&kDragToLoadDecoratorObservingContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kDragToLoadDecoratorObservingContext) {
        
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self scrollViewContentSizeDidChange];
        } else if ([keyPath isEqualToString:@"contentOffset"]) {
            [self scrollViewContentOffsetDidChange];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (WTDragToLoadDecorator *)createDecoratorWithDataSource:(id<WTDragToLoadDecoratorDataSource>)dataSource
                                               delegate:(id<WTDragToLoadDecoratorDelegate>)delegate {
    WTDragToLoadDecorator *result = [[WTDragToLoadDecorator alloc] init];
    result.dataSource = dataSource;
    result.delegate = delegate;
    
    UIScrollView *scrollView = [dataSource dragToLoadScrollView];
    result.scrollViewOriginalContentInset = scrollView.contentInset;
    
    // Configure top view
    [result.topView resetOriginY:0.0f - result.topView.frame.size.height - result.scrollViewOriginalContentInset.top];
    [scrollView addSubview:result.topView];
    [result updateTopViewUpdateTimeLabel:YES];
    
    // Configure bottom view
    [result.bottomView resetOriginY:scrollView.frame.size.height];
    [scrollView addSubview:result.bottomView];
    
    result.topViewState = TopViewStateNormal;
    result.bottomViewState = BottomViewStateNormal;
    
    return result;
}

- (void)topViewLoadFinished:(BOOL)loadSucceeded {
    if (self.topViewState == TopViewStateLoading) {
        if (loadSucceeded) {
            //[self updateTopViewUpdateTimeLabel:NO];
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            self.topViewState = TopViewStateNormal;
        }];
        
        [self.topView stopLoadingAnimation];
    }
}

- (void)bottomViewLoadFinished:(BOOL)loadSucceeded {
    if (self.bottomViewState == BottomViewStateLoading) {
        if (!loadSucceeded) {
            UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
            if (!scrollView.dragging && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + self.scrollViewOriginalContentInset.bottom) {
                
                [UIView animateWithDuration:0.25f animations:^{
                    UIEdgeInsets inset = scrollView.contentInset;
                    inset.bottom = self.scrollViewOriginalContentInset.bottom;
                    scrollView.contentInset = inset;
                } completion:^(BOOL finished) {
                    self.bottomViewState = BottomViewStateNormal;
                }];
                
            } else {
                self.bottomViewState = BottomViewStateNormal;
            }
            [self.bottomView.activityIndicator stopAnimating];
            
        } else {
            if (!self.delayBottomViewDisable) {
                self.bottomViewState = BottomViewStateNormal;
                [self.bottomView.activityIndicator stopAnimating];
            }
        }
    }
}

- (void)setTopViewDisabled:(BOOL)disabled {
    if (disabled) {
        self.topViewState = TopViewStateDisabled;
    } else {
        self.topViewState = TopViewStateNormal;
    }
}

- (void)setBottomViewDisabled:(BOOL)disabled {
    if (disabled) {
        self.delayBottomViewDisable = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, SET_BOTTOM_VIEW_STATE_DISABLED_DELAY_SEC * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            if (self.delayBottomViewDisable) {
                self.bottomViewState = BottomViewStateDisabled;
                self.delayBottomViewDisable = NO;
            }
        });

    } else {
        self.bottomViewState = BottomViewStateNormal;
    }
}

- (void)setTopViewLoading:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.topViewState = TopViewStateLoading;
        }];
    } else {
        self.topViewState = TopViewStateLoading;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        [self.delegate dragToLoadDecoratorDidDragDown];
    });
}

- (void)scrollViewDidLoadNewCell {
    [self.bottomView resetOriginYByOffset:self.bottomView.frame.size.height];
}

#pragma mark - Properties

- (WTDragToLoadDecoratorTopView *)topView {
    if (!_topView) {
        _topView = [WTDragToLoadDecoratorTopView createTopView];
    }
    return _topView;
}

- (WTDragToLoadDecoratorBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [WTDragToLoadDecoratorBottomView createBottomView];
    }
    return _bottomView;
}

- (void)setTopViewState:(TopViewState)topViewState {
    if (_topViewState == topViewState)
        return;
    
    _topViewState = topViewState;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    
	switch (topViewState) {
		case TopViewStateReady: {
            // self.topView.dragStatusLabel.text = NSLocalizedString(@"Release to refresh", nil);
            inset.top = self.scrollViewOriginalContentInset.top;
            scrollView.contentInset = inset;
        }
			break;
            
		case TopViewStateNormal: {
            self.topView.hidden = NO;
            // self.topView.dragStatusLabel.text = NSLocalizedString(@"Pull to refresh", nil);
            inset.top = self.scrollViewOriginalContentInset.top;
            scrollView.contentInset = inset;
        }
			break;
            
		case TopViewStateLoading: {
            // self.topView.dragStatusLabel.text = NSLocalizedString(@"Loading", nil);
            
            inset.top = self.topView.frame.size.height + self.scrollViewOriginalContentInset.top;
            scrollView.contentInset = inset;
            [self.topView configureCloudAndDropletHeightWithRatio:1.0f];
            
            [self.topView startLoadingAnimation];
        }
			break;
            
        case TopViewStateDisabled: {
            self.topView.hidden = YES;
        }
            break;
		default:
			break;
	}
}

- (void)setBottomViewState:(BottomViewState)bottomViewState {
    if (_bottomViewState == bottomViewState)
        return;
    
    _bottomViewState = bottomViewState;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    
	switch (bottomViewState) {
            
		case BottomViewStateNormal: {
            self.bottomView.hidden = NO;
            inset.bottom = self.scrollViewOriginalContentInset.bottom + self.bottomView.frame.size.height;
            scrollView.contentInset = inset;
        }
			break;
            
		case BottomViewStateLoading: {            
            inset.bottom = self.scrollViewOriginalContentInset.bottom + self.bottomView.frame.size.height;
            scrollView.contentInset = inset;
            
            [self.bottomView.activityIndicator startAnimating];
            [self.delegate dragToLoadDecoratorDidDragUp];
        }
			break;
            
        case BottomViewStateDisabled: {
            inset.bottom = self.scrollViewOriginalContentInset.bottom;
            [UIView animateWithDuration:0.25f animations:^{
                scrollView.contentInset = inset;
            } completion:^(BOOL finished) {
                self.bottomView.hidden = YES;
            }];
        }
            break;
		default:
			break;
	}
}

#pragma mark - Logic methods

- (void)scrollViewContentSizeDidChange {
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    if (scrollView.contentSize.height == 0) {
        self.bottomViewState = BottomViewStateDisabled;
    } else if (scrollView.contentSize.height < scrollView.frame.size.height) {
        if (self.bottomViewState != BottomViewStateDisabled)
            self.bottomViewState = BottomViewStateLoading;
    } else {
        [self resetBottomViewOriginY];
    }
}

- (void)scrollViewContentOffsetDidChange {
    [self updateTopViewState];
    [self updateBottomViewState];
}

#define WTTopViewThresholdOffsetY   (-self.topView.frame.size.height - 5.0f)

- (void)updateTopViewState {
    TopViewState state = self.topViewState;
    if (state == TopViewStateDisabled)
        return;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    CGFloat topViewHeight = self.topView.frame.size.height;
    
    CGFloat scrollViewRealContentOffsetY = scrollView.contentOffset.y + self.scrollViewOriginalContentInset.top;
    if (scrollView.isDragging) {
        if (state == TopViewStateReady) {
            if (scrollViewRealContentOffsetY > WTTopViewThresholdOffsetY && scrollViewRealContentOffsetY < 0.0f) {
                self.topViewState = TopViewStateNormal;
            }
            [self.topView configureCloudAndDropletHeightWithRatio:scrollView.contentOffset.y / WTTopViewThresholdOffsetY];
        } else if (state == TopViewStateNormal) {
            if (scrollViewRealContentOffsetY < WTTopViewThresholdOffsetY) {
                self.topViewState = TopViewStateReady;
            }
            [self.topView configureCloudAndDropletHeightWithRatio:scrollView.contentOffset.y / WTTopViewThresholdOffsetY];
        } else if (state == TopViewStateLoading) {
            if (scrollViewRealContentOffsetY >= 0) {
                scrollView.contentInset = self.scrollViewOriginalContentInset;
            } else {
                scrollView.contentInset = UIEdgeInsetsMake(MIN(-scrollViewRealContentOffsetY, topViewHeight) + self.scrollViewOriginalContentInset.top, 0, 0, self.scrollViewOriginalContentInset.bottom);
            }
        }
    } else {
        if (state == TopViewStateReady) {
            [self setTopViewLoading:YES];
        }
    }
}

- (void)updateBottomViewState {
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    BottomViewState state = self.bottomViewState;
    
    if (state == BottomViewStateDisabled)
        return;
    
    BOOL isBottomViewShown = scrollView.contentOffset.y > scrollView.contentSize.height + self.scrollViewOriginalContentInset.bottom - scrollView.frame.size.height;
    if (state == BottomViewStateNormal) {
        if (isBottomViewShown) {
            self.bottomViewState = BottomViewStateLoading;
        }
    }
}

@end

@interface WTDragToLoadDecoratorTopView ()

@property (nonatomic, assign) BOOL showingAnimation;

@end

@implementation WTDragToLoadDecoratorTopView

#define WTDragToLoadCloudStartOriginY   27.0f
#define WTDragToLoadCloudEndOriginY     21.0f
#define WTDragToLoadCloudDistanceY      (WTDragToLoadCloudEndOriginY - WTDragToLoadCloudStartOriginY)

#define WTDragToLoadCloudStartScale     1.0f
#define WTDragToLoadCloudEndScale       0.5f
#define WTDragToLoadCloudScaleChange    (WTDragToLoadCloudEndScale - WTDragToLoadCloudStartScale)

#define WTDragToLoadDropletAnimationStartOriginY    18.0f
#define WTDragToLoadDropletAnimationEndOriginY      self.frame.size.height

+ (WTDragToLoadDecoratorTopView *)createTopView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTDragToLoadDecorator" owner:self options:nil];
    WTDragToLoadDecoratorTopView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTDragToLoadDecoratorTopView class]])
            result = (WTDragToLoadDecoratorTopView *)view;
    }
        
    return result;
}

- (void)startLoadingAnimation {
    if (self.showingAnimation)
        return;
    
    self.showingAnimation = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 150 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        [self dropletLoopAnimation];
    });
    
    [UIView animateWithDuration:0.1f animations:^{
        self.cloudImageView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.cloudImageView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05f animations:^{
                self.cloudImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 600 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
                    [self cloudLoopAnimation];
                });
            }];
        }];
    }];
}

- (void)dropletLoopAnimation {
    [self.dropletImageView resetOriginY:WTDragToLoadDropletAnimationStartOriginY];
    self.dropletImageView.hidden = NO;
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.dropletImageView resetOriginY:WTDragToLoadDropletAnimationEndOriginY];
                     } completion:^(BOOL finished) {
                         if (self.showingAnimation) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
                                 [self dropletLoopAnimation];
                             });

                         } else {
                             self.dropletImageView.hidden = YES;
                         }
                     }];
}

- (void)cloudLoopAnimation {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (self.showingAnimation) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
                [self cloudLoopAnimation];
            });
        }
    }];
    
    [CATransaction setValue:@(0.5f) forKey:kCATransactionAnimationDuration];
    [self.cloudImageView.layer addAnimation:[WTDragToLoadDecoratorTopView heartBeatAnimation] forKey:nil];
    [CATransaction commit];
}

+ (CAKeyframeAnimation*)heartBeatAnimation {
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.5f;
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
	
	animation.values = values;
	return animation;
}

- (void)stopLoadingAnimation {
    self.showingAnimation = NO;
}

- (void)configureCloudAndDropletHeightWithRatio:(float)ratio {
    ratio = ratio < 0 ? 0 : ratio;
    
    float scaleRatio = ratio;
    scaleRatio = scaleRatio > 3 ? 3 : scaleRatio;
    if (scaleRatio > 3) {
        scaleRatio = 0.95 + (ratio - 3) / 20; // 0.95 - 1.0
    } else if (ratio > 2) {
        scaleRatio = 0.75 + (ratio - 2) / 5; // 0.75 - 0.95
    } else if (ratio > 1) {
        scaleRatio = 0.5 + (ratio - 1) / 4; // 0.5 - 0.75
    } else {
        scaleRatio = ratio / 2; // 0 - 0.5
    }
    
    CGFloat cloudScale = WTDragToLoadCloudStartScale + WTDragToLoadCloudScaleChange * scaleRatio;
    self.cloudImageView.transform = CGAffineTransformMakeScale(cloudScale, cloudScale);
    
    float offsetRatio = ratio;
    offsetRatio = offsetRatio > 1 ? 1 : offsetRatio;
    
    [self.cloudImageView resetOriginY:WTDragToLoadCloudStartOriginY + WTDragToLoadCloudDistanceY * offsetRatio];
}

@end

@implementation WTDragToLoadDecoratorBottomView

+ (WTDragToLoadDecoratorBottomView *)createBottomView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTDragToLoadDecorator" owner:self options:nil];
    WTDragToLoadDecoratorBottomView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTDragToLoadDecoratorBottomView class]])
            result = (WTDragToLoadDecoratorBottomView *)view;
    }
    return result;
}

@end
