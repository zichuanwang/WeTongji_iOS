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

@end

@implementation WTHomeNowContainerView

- (id)init {
    self = [super init];
    if (self) {
        self.itemViewArray = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

+ (WTHomeNowContainerView *)createHomeNowContainerView {
    WTHomeNowContainerView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTHomeNowView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTHomeNowContainerView class]]) {
            result = (WTHomeNowContainerView *)view;
            break;
        }
    }
    return result;
}

- (void)clearItemViews {
    for (UIView *view in self.itemViewArray) {
        [view removeFromSuperview];
    }
    [self.itemViewArray removeAllObjects];
}

- (void)configureNowContainerViewWithEvents:(NSArray *)events {
    [self clearItemViews];
    
    if (!events) {
        WTHomeNowEmptyItemView *emptyItemView = [WTHomeNowEmptyItemView createNowEmptyItemView];
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
        
        eventIndex++;
    }
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
