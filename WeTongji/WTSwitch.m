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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.handlerButton.highlighted = NO;
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Gesture handler

- (void)didTapView:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.scrollView];
    NSLog(@"%@", NSStringFromCGPoint(location));
    if (location.x < 50) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(64, 0);
        } completion:^(BOOL finished) {
            if (finished)
                _switchState = 1;
            NSLog(@"switch state :%d", _switchState);
        }];
    } else if (location.x > 78) {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            if (finished)
                _switchState = 0;
            NSLog(@"switch state :%d", _switchState);
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.handlerButton resetCenterX:64 - scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.handlerButton.highlighted = NO;
    
    if (decelerate == false) {
        _switchState = (scrollView.contentOffset.x != 0);
    }
    
    NSLog(@"switch state :%d", _switchState);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _switchState = (scrollView.contentOffset.x != 0);
    
    NSLog(@"switch state :%d", _switchState);
}

@end
