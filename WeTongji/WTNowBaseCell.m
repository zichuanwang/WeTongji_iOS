//
//  WTNowBaseCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowBaseCell.h"
#define kNowTimeLabelX 10
#define kNowTimeLabelY 19

@implementation WTNowBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.nowLabel.text = NSLocalizedString(@"Now", nil);
    CGFloat nowLabelHeight = self.nowLabel.frame.size.height;
    [self.nowLabel sizeToFit];
    [self.nowLabel resetHeight:nowLabelHeight];
}

#pragma mark - UI methods

- (void)showNowView {
    self.nowView.hidden = NO;
    CGPoint nowLabelOrigin = [self.nowLabel convertPoint:self.nowLabel.frame.origin toView:self.nowView];
    [self.whenLabel resetOriginX:nowLabelOrigin.x + self.nowLabel.frame.size.width + 20];
}

- (void)hideNowView {
    self.nowView.hidden = YES;
    [self.whenLabel resetOriginX:self.nowView.frame.origin.x + 2];
}

- (void)updateCellStatus:(WTNowBaseCellType)type {
    if(type == WTNowBaseCellTypePast) {
        self.containerView.alpha = 0.5f;
    } else {
        self.containerView.alpha = 1.0f;
    }
        
    if(type == WTNowBaseCellTypeNow){
        [self showNowView];
        self.ringImageView.hidden = NO;
    } else {
        [self hideNowView];
        self.ringImageView.hidden = YES;
    }
}

@end
