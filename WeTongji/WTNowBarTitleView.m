//
//  WTNowBarTitleView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowBarTitleView.h"

@implementation WTNowBarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureWeekContainerView];
}

+ (WTNowBarTitleView *)createBarTitleViewWithDelegate:(id<WTNowBarTitleViewDelegate>)delegate {
    WTNowBarTitleView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTNowBarTitleView" owner:nil options:nil] lastObject];
    result.delegate = delegate;
    return result;
}

#pragma mark - UI methods

- (void)configureWeekContainerView {
    UIImage *weekBgImage = self.weekBgImageView.image;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 4.0f, 0, 4.0f);
    self.weekBgImageView.image = [weekBgImage resizableImageWithCapInsets:insets];
    
    self.weekDisplayLabel.text = NSLocalizedString(@"week", nil);
}

#pragma mark - Properties

#define WEEK_LABEL_ADD_WIDTH            9.0f
#define WEEK_DISPLAY_LABEL_PADDING_X    1.0f

- (void)setWeekNumber:(NSUInteger)weekNumber {
    _weekNumber = weekNumber;
    
    self.weekLabel.text = [NSString stringWithFormat:@"%d", weekNumber];
    [self.weekLabel sizeToFit];
    
    CGFloat weekLabelWidth = self.weekLabel.frame.size.width + WEEK_LABEL_ADD_WIDTH;
    NSLog(@"!!!!%f", weekLabelWidth);
    [self.weekLabel resetWidth:weekLabelWidth];
    [self.weekLabel resetHeight:self.weekContainerView.frame.size.height];
    
    [self.weekContainerView resetWidth:weekLabelWidth - 1.0f];
    [self.weekLabel resetCenterX:self.weekContainerView.frame.size.width / 2];
    
    [self.weekDisplayLabel resetOriginX:self.weekContainerView.frame.origin.x + self.weekContainerView.frame.size.width + WEEK_DISPLAY_LABEL_PADDING_X];
}

#pragma mark - Actions

- (IBAction)didClickPrevButton:(UIButton *)sender {
    self.weekNumber--;
    [self.delegate nowBarTitleViewDidClickPrevButton];
}

- (IBAction)didClickNextButton:(UIButton *)sender {
    self.weekNumber++;
    [self.delegate nowBarTitleViewDidClickNextButton];
}

@end
