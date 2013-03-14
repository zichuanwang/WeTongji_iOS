//
//  WTDragToLoadDecorator.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDragToLoadDecorator.h"

typedef enum {
    DragToLoadStateNormal = 0,
	DragToLoadStateReady,
	DragToLoadStateLoading,
} DragToLoadState;

@interface WTDragToLoadDecorator ()

@property (nonatomic, strong) WTDragToLoadDecoratorTopView *topView;
@property (nonatomic, strong) WTDragToLoadDecoratorBottomView *bottomView;

@property (nonatomic, assign) DragToLoadState currentState;

@end

@implementation WTDragToLoadDecorator

#pragma mark - Public methods

+ (WTDragToLoadDecorator *)createDecoratorWithDataSource:(id<WTDragToLoadDecoratorDataSource>)dataSource
                                               delegate:(id<WTDragToLoadDecoratorDelegate>)delegate {
    WTDragToLoadDecorator *result = [[WTDragToLoadDecorator alloc] init];
    result.dataSource = dataSource;
    result.delegate = delegate;
    
    UIScrollView *scrollView = [dataSource dragToLoadScrollView];
    [scrollView addSubview:result.topView];
    [scrollView addSubview:result.bottomView];
    
    return result;
}

- (void)hideTopView:(BOOL)loadSucceeded {
    if (self.currentState == DragToLoadStateLoading) {
        [UIView animateWithDuration:0.25f animations:^{
            self.currentState = DragToLoadStateNormal;
        }];
        
        [self.topView.activityIndicator stopAnimating];
    }
}

- (void)hideBottomView:(BOOL)loadSucceeded {
    
}

- (void)scrollViewDidScroll {
    [self updateCurrentState];
}

#pragma mark - Properties

- (WTDragToLoadDecoratorTopView *)topView {
    if (!_topView) {
        _topView = [WTDragToLoadDecoratorTopView createTopView];
        [_topView resetOriginY:-_topView.frame.size.height];
    }
    return _topView;
}

- (WTDragToLoadDecoratorBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [WTDragToLoadDecoratorBottomView createBottomView];
        UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
        [_bottomView resetOriginY:scrollView.contentSize.height];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (void)setCurrentState:(DragToLoadState)currentState {
    _currentState = currentState;
    
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    
	switch (currentState) {
		case DragToLoadStateReady:
        {
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Release to refresh", nil);
            inset.top = 0.0;
            scrollView.contentInset = inset;
        }
			break;
            
		case DragToLoadStateNormal:
        {
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Pull to refresh", nil);
            inset.top = 0.0;
            scrollView.contentInset = inset;
        }
			break;
            
		case DragToLoadStateLoading:
        {
            self.topView.dragStatusLabel.text = NSLocalizedString(@"Loading", nil);
            
            inset.top = 60.0;
            [UIView animateWithDuration:0.25f animations:^{
                scrollView.contentInset = inset;
            }];
            
            [self.topView.activityIndicator startAnimating];
        }
			break;
            
		default:
			break;
	}
}

#pragma mark - Logic methods

- (void)updateCurrentState {
    UIScrollView *scrollView = [self.dataSource dragToLoadScrollView];
    DragToLoadState state = self.currentState;
    if (scrollView.isDragging) {
        if (state == DragToLoadStateReady) {
            if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f)
                self.currentState = DragToLoadStateNormal;
        } else if (state == DragToLoadStateNormal) {
            if (scrollView.contentOffset.y < -65.0f)
                self.currentState = DragToLoadStateReady;
        } else if (state == DragToLoadStateLoading) {
            if (scrollView.contentOffset.y >= 0)
                scrollView.contentInset = UIEdgeInsetsZero;
            else
                scrollView.contentInset = UIEdgeInsetsMake(MIN(-scrollView.contentOffset.y, 60.0f), 0, 0, 0);
        }
    } else {
        if (state == DragToLoadStateReady) {
            self.currentState = DragToLoadStateLoading;
            [self.delegate dragToLoadDecoratorDidDragDown];
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
