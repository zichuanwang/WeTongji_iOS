//
//  WTSwitch.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSwitch.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTSwitch

+ (WTSwitch *)createSwitchWithDelegate:(id<WTSwitchDelegate>)delegate {
    WTSwitch *result = [[[NSBundle mainBundle] loadNibNamed:@"WTSwitch" owner:self options:nil] lastObject];
    result.delegate = delegate;
    return result;
}

- (void)awakeFromNib {
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.layer.cornerRadius = 14.0f;
    self.scrollView.contentSize = CGSizeMake(128, self.scrollView.frame.size.height);
    
    self.onLabel.text = NSLocalizedString(@"ON", nil);
    self.offLabel.text = NSLocalizedString(@"OFF", nil);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self addGestureRecognizer:tap];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self.handlerButton) {
        self.handlerButton.highlighted = YES;
        result = self.scrollView;
    }
    return result;
}

#pragma mark - Gesture handler

- (void)didTapView:(UITapGestureRecognizer *)gesture {
    self.handlerButton.highlighted = NO;
    
    CGPoint location = [gesture locationInView:self.scrollView];
    NSLog(@"%@", NSStringFromCGPoint(location));
    if (location.x < 50) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(64, 0);
        } completion:^(BOOL finished) {
            //_switchState = 1;
            NSLog(@"3 switch state :%d", _switchState);
        }];
    } else if (location.x > 78) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            //_switchState = 0;
            NSLog(@"2 switch state :%d", _switchState);
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = _switchState ? CGPointMake(0, 0) : CGPointMake(64, 0);
        } completion:^(BOOL finished) {
            //_switchState = !_switchState;
            NSLog(@"1 switch state :%d", _switchState);
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.handlerButton resetCenterX:64 - scrollView.contentOffset.x];
    
    _switchState = (scrollView.contentOffset.x >= 50);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.handlerButton.highlighted = NO;
    
    NSLog(@"contentOffset:%f, switch state :%d", scrollView.contentOffset.x, _switchState);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.handlerButton.highlighted = NO;
        
    NSLog(@"contentOffset:%f, switch state :%d", scrollView.contentOffset.x, _switchState);
}

@end
