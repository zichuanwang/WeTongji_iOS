//
//  WTHomeNowView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeNowView.h"
#import "OHAttributedLabel.h"
#import "Event.h"
#import "NSString+WTAddition.h"

@interface WTHomeNowContainerView ()

@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) NSMutableArray *eventArray;

@end

@implementation WTHomeNowContainerView

+ (WTHomeNowContainerView *)createHomeNowContainerViewWithDelegate:(id<WTHomeNowContainerViewDelegate>)delegate {
    WTHomeNowContainerView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowContainerView class]]) {
            result = (WTHomeNowContainerView *)view;
            result.itemViewArray = [NSMutableArray arrayWithCapacity:2];
            result.eventArray = [NSMutableArray arrayWithCapacity:2];
            result.scrollView.contentSize = CGSizeMake(640.0f, result.scrollView.frame.size.height);
            
            result.delegate = delegate;
            break;
        }
    }
    return result;
}

- (void)clearItemViewsAndEvents {
    for (UIView *view in self.itemViewArray) {
        [view removeFromSuperview];
    }
    [self.itemViewArray removeAllObjects];
    [self.eventArray removeAllObjects];
}

- (void)configureNowContainerViewWithEvents:(NSArray *)events {
    [self clearItemViewsAndEvents];
    
    if (!events) {
        WTHomeNowEmptyItemView *emptyItemView = [WTHomeNowEmptyItemView createNowEmptyItemView];
        [self.itemViewArray addObject:emptyItemView];
        [self.scrollView addSubview:emptyItemView];
        
        self.switchContainerView.hidden = YES;
        return;
    }
    self.switchContainerView.hidden = NO;
    
    NSUInteger eventIndex = 0;
    
    for (Event *event in events) {
        WTHomeNowItemView *itemView = [WTHomeNowItemView createNowItemViewWithEvent:event];
        [self.itemViewArray addObject:itemView];
        itemView.nowOrLaterLabel.text = (eventIndex == 0) ? NSLocalizedString(@"Now", nil) : NSLocalizedString(@"Later", nil);
        
        [itemView resetOriginX:320.0f * eventIndex];
        [self.scrollView insertSubview:itemView belowSubview:self.switchContainerView];
        
        itemView.bgButton.tag = eventIndex;
        [itemView.bgButton addTarget:self action:@selector(didClickItemView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.eventArray addObject:event];
        
        eventIndex++;
    }
}

#pragma mark - Animations

- (void)showSecondItemAnimation {
    [UIView animateWithDuration:0.5f animations:^{
        self.switchMoreIndicator.alpha = 0;
        self.switchMoreReverseIndicator.alpha = 1;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width - self.switchContainerView.frame.size
                                                    .width, 0);
    }];
}

- (void)showFirstItemAnimation {
    [UIView animateWithDuration:0.5f animations:^{
        self.switchMoreIndicator.alpha = 1;
        self.switchMoreReverseIndicator.alpha = 0;
        self.scrollView.contentOffset = CGPointZero;
    }];
}

#pragma mark - Actions

- (IBAction)didClickSwitchItemButton:(UIButton *)sender {
    if (self.scrollView.contentOffset.x == 0) {
        [self showSecondItemAnimation];
    } else {
        [self showFirstItemAnimation];
    }
}

- (void)didClickItemView:(UIButton *)sender {
    [self.delegate homeNowContainerViewDidSelectEvent:self.eventArray[sender.tag]];
}

@end

@implementation WTHomeNowItemView

+ (WTHomeNowItemView *)createNowItemViewWithEvent:(Event *)event {
    WTHomeNowItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowItemView class]]) {
            result = (WTHomeNowItemView *)view;
            break;
        }
    }
    [result configureNowItemViewWithEvent:event];
    return result;
}

- (void)configureNowItemViewWithEvent:(Event *)event {
    [self configureFriendCountLabel:@(23)];
    [self configureEventTitle:event.what place:event.where time:event.begin_time];
}

- (void)configureEventTitle:(NSString *)title
                      place:(NSString *)place
                       time:(NSDate *)time {
    self.titleLabel.text = title;
    self.placeLabel.text = place;
    self.timeLabel.text = [NSString timeConvertFromDate:time];
}

- (void)configureFriendCountLabel:(NSNumber *)count {
    NSString *frinedCountString = count.stringValue;
    NSString *friendString = count.integerValue > 1 ? @"friends" : @"friend";
    NSString *resultString = [NSString stringWithFormat:@"%@ %@", frinedCountString, NSLocalizedString(friendString, nil)];
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    
    // Retrieve the last character's attributes of friendCountLabel, set it as
    // resultAttributedString's attributes.
    [resultAttributedString setAttributes:[self.friendCountLabel.attributedText attributesAtIndex:self.friendCountLabel.attributedText.length - 1 effectiveRange:NULL] range:NSMakeRange(0, resultAttributedString.length)];
    // Make the friend count bold.
    [resultAttributedString setTextBold:YES range:NSMakeRange(0, frinedCountString.length)];
    self.friendCountLabel.attributedText = resultAttributedString;
}

@end

@implementation WTHomeNowEmptyItemView

+ (WTHomeNowEmptyItemView *)createNowEmptyItemView {
    WTHomeNowEmptyItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowEmptyItemView class]]) {
            result = (WTHomeNowEmptyItemView *)view;
            break;
        }
    }
    result.emptyLabel.text = NSLocalizedString(@"No Schedule today", nil);
    return result;
}

@end
