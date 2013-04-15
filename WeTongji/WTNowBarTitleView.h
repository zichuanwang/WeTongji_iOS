//
//  WTNowBarTitleView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTNowBarTitleViewDelegate;

@interface WTNowBarTitleView : UIView

@property (nonatomic, weak) IBOutlet UILabel *weekDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *weekLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *weekContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *weekBgImageView;
@property (nonatomic, weak) IBOutlet UIButton *prevButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, assign) NSUInteger weekNumber;

@property (nonatomic, weak) id<WTNowBarTitleViewDelegate> delegate;

- (IBAction)didClickPrevButton:(UIButton *)sender;
- (IBAction)didClickNextButton:(UIButton *)sender;

+ (WTNowBarTitleView *)createBarTitleViewWithDelegate:(id<WTNowBarTitleViewDelegate>)delegate;

@end

@protocol WTNowBarTitleViewDelegate <NSObject>

- (void)nowBarTitleViewDidClickPrevButton;
- (void)nowBarTitleViewDidClickNextButton;

@end