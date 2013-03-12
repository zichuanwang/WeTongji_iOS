//
//  WTPullTableHeaderView.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTPullTableHeaderView.h"
#define kPullOffsetToRefresh 80

@implementation WTPullTableHeaderView

@synthesize updatedTimeLabel = _updatedTimeLabel;
@synthesize informationLabel = _informationLabel;
@synthesize indicatorView = _indicatorView;

@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = WTPullTableHeaderViewStateNormal;
    }
    return self;
}

#pragma mark - Override Setter

- (void)setState:(WTPullTableHeaderViewState)state
{
    if (state == WTPullTableHeaderViewStatePull) {
        self.informationLabel.text = @"释放刷新，看看以前的日程";
    } else if (state == WTPullTableHeaderViewStateNormal) {
        self.informationLabel.text = @"下拉可以看到以前的日程哦";
        [self refreshUpdatedTime];
    } else {
        self.informationLabel.text = @"正在加载数据，请稍后";
    }
}

#pragma mark - Private Method

- (void)refreshUpdatedTime
{
    NSDateFormatter *formatter = nil;
    
    if ([self.delegate respondsToSelector:@selector(updateDateFormat)] ) {
       formatter = [self.delegate updateDateFormat];
    } else {
        formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
    }
    
    self.updatedTimeLabel.text = [formatter stringFromDate:[NSDate date]];
}

- (void)updateStateFrom:(WTPullTableHeaderViewState)oldState to:(WTPullTableHeaderViewState)newState
{
    if (oldState == WTPullTableHeaderViewStateNormal && newState == WTPullTableHeaderViewStatePull) {
        // Ziqi:Do Nothing
    } else if (oldState == WTPullTableHeaderViewStatePull && newState == WTPullTableHeaderViewStateLoad) {
        [self.indicatorView startAnimating];
    } else if (oldState == WTPullTableHeaderViewStateLoad && newState == WTPullTableHeaderViewStateNormal) {
        [self.indicatorView stopAnimating];
    } else if (oldState == WTPullTableHeaderViewStatePull && newState == WTPullTableHeaderViewStateNormal) {
        // Ziqi:Do nothing
    }
    
    self.state = newState;
}

#pragma mark - Public 

- (void)pullTableHeaderViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < - kPullOffsetToRefresh) {
        [UIView animateWithDuration:0.25f animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(kPullOffsetToRefresh, 0.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [self updateStateFrom:self.state to:WTPullTableHeaderViewStateLoad];
            [self.delegate pullToLoadData];
        }];
    } 
}

- (void)pullTableHeaderViewDidFinishingLoading:(UIScrollView *)scrollView
{
    NSLog(@"Did Finishing Loading");
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self updateStateFrom:self.state to:WTPullTableHeaderViewStateNormal];
    }];
}

@end
