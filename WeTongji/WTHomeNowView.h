//
//  WTHomeNowView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

@interface WTHomeNowContainerView : UIView

@property (nonatomic, weak) IBOutlet UIButton *switchItemButton;
@property (nonatomic, weak) IBOutlet UIView *switchContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *switchMoreIndicator;
@property (nonatomic, weak) IBOutlet UIImageView *switchMoreReverseIndicator;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTHomeNowContainerView *)createHomeNowContainerView;

- (void)configureNowContainerViewWithEvents:(NSArray *)events;

- (IBAction)didClickSwitchItemButton:(UIButton *)sender;

@end

@class Event;

@interface WTHomeNowItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UILabel *nowOrLaterLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *friendCountLabel;

+ (WTHomeNowItemView *)createNowItemViewWithEvent:(Event *)event;

@end

@interface WTHomeNowEmptyItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *emptyLabel;

+ (WTHomeNowEmptyItemView *)createNowEmptyItemView;

@end
