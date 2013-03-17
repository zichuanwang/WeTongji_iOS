//
//  WTDragToLoadDecorator.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDragToLoadDecorator.h"
#import "NSString+WTAddition.h"

typedef enum {
    TopViewStateNormal = 0,
	TopViewStateReady,
	TopViewStateLoading,
    TopViewStateDisabled,
} TopViewState;

typedef enum {
    BottomViewStateNormal = 0,
	BottomViewStateLoading,
    BottomViewStateDisabled,
} BottomViewState;

@interface WTDragToLoadDecorator ()

@property (nonatomic, strong) WTDragToLoadDecoratorTopView *topView;
@property (nonatomic, strong) WTDragToLoadDecoratorBottomView *bottomView;

@property (nonatomic, assign) TopViewState topViewState;
@property (nonatomic, assign) BottomViewState bottomViewState;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalContentInset;

@property (nonatomic, assign) BOOL alreadyObservingDragToLoadScrollView;

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
    self.topView.updateTimeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last update", nil), updateTimeString];
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
            [self updateTopViewUpdateTimeLabel:NO];
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            self.topViewState = TopViewStateNormal;
        }];
        
        [self.topView.activityIndicator stopAnimating];
    }
}

- (void)bottomViewLoadFinished:(BOOL)loadSucceeded {
    if (self.bottomViewState == BottomViewStateLoading) {
        if (!loadSucceeded) {
            UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
            if (!scrollView.dragging && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + self.scrollViewOriginalContentInset.bottom) {
                
                [UIView animateWithDuration:0.25f animations:^{
                    self.bottomViewState = BottomViewStateDisabled;
                } completion:^(BOOL finished) {
                    self.bottomViewState = BottomViewStateNormal;
                }];
                
            } else {
                self.bottomViewState = BottomViewStateNormal;
            }
        } else {
            // Trick, add the temp contentSize.height to make smooth animation
            UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
            CGSize contentSize = scrollView.contentSize;
            contentSize.height += self.bottomView.frame.size.height;
            scrollView.contentSize = contentSize;
            
            self.bottomViewState = BottomViewStateNormal;
        }
        
        [self.bottomView.activityIndicator stopAnimating];
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
        self.bottomViewState = BottomViewStateDisabled;
    } else {
        self.bottomViewState = BottomViewStateNormal;
    }
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
    _topViewState = topViewState;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    
	switch (topViewState) {
		case TopViewStateReady: {
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Release to refresh", nil);
            inset.top = self.scrollViewOriginalContentInset.top;
            scrollView.contentInset = inset;
        }
			break;
            
		case TopViewStateNormal: {
            self.topView.hidden = NO;
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Pull to refresh", nil);
            inset.top = self.scrollViewOriginalContentInset.top;
            scrollView.contentInset = inset;
        }
			break;
            
		case TopViewStateLoading: {
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Loading", nil);
            
            inset.top = 60.0f + self.scrollViewOriginalContentInset.top;
            [UIView animateWithDuration:0.25f animations:^{
                scrollView.contentInset = inset;
            }];
            
            [self.topView.activityIndicator startAnimating];
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
            scrollView.contentInset = inset;
            self.bottomView.hidden = YES;
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
        [self setBottomViewDisabled:YES];
    } else if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.bottomViewState = BottomViewStateLoading;
    } else {
        [self resetBottomViewOriginY];
    }
}

- (void)scrollViewContentOffsetDidChange {
    [self updateTopViewState];
    [self updateBottomViewState];
}

- (void)updateTopViewState {
    TopViewState state = self.topViewState;
    if (state == TopViewStateDisabled)
        return;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    CGFloat topViewHeight = self.topView.frame.size.height;
    CGFloat topViewThresholdOffset = topViewHeight + 5.0f;
    
    CGFloat scrollViewRealContentOffsetY = scrollView.contentOffset.y + self.scrollViewOriginalContentInset.top;
    if (scrollView.isDragging) {
        if (state == TopViewStateReady) {
            if (scrollViewRealContentOffsetY > -topViewThresholdOffset && scrollViewRealContentOffsetY < 0.0f)
                self.topViewState = TopViewStateNormal;
        } else if (state == TopViewStateNormal) {
            if (scrollViewRealContentOffsetY < -topViewThresholdOffset)
                self.topViewState = TopViewStateReady;
        } else if (state == TopViewStateLoading) {
            if (scrollViewRealContentOffsetY >= 0)
                scrollView.contentInset = self.scrollViewOriginalContentInset;
            else
                scrollView.contentInset = UIEdgeInsetsMake(MIN(-scrollViewRealContentOffsetY, topViewHeight) + self.scrollViewOriginalContentInset.top, 0, 0, self.scrollViewOriginalContentInset.bottom);
        }
    } else {
        if (state == TopViewStateReady) {
            self.topViewState = TopViewStateLoading;
            [self.delegate dragToLoadDecoratorDidDragDown];
        }
    }
}

- (void)updateBottomViewState {
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    BottomViewState state = self.bottomViewState;
    
    if (state == BottomViewStateDisabled)
        return;
    
    if (scrollView.isDragging) {
        BOOL isBottomViewShown = scrollView.contentOffset.y > scrollView.contentSize.height + self.scrollViewOriginalContentInset.bottom - scrollView.frame.size.height;
        if (state == BottomViewStateNormal) {
            if (isBottomViewShown) {
                self.bottomViewState = BottomViewStateLoading;
            }
        }
    }
}

@end

@implementation WTDragToLoadDecoratorTopView

+ (WTDragToLoadDecoratorTopView *)createTopView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTDragToLoadDecorator" owner:self options:nil];
    WTDragToLoadDecoratorTopView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTDragToLoadDecoratorTopView class]])
            result = (WTDragToLoadDecoratorTopView *)view;
    }
        
    return result;
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
