//
//  WTNewsCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsCell.h"

@implementation WTNewsCell

#define NEWS_TITLE_SUMMARY_LABEL_MARGIN 4.0f

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.highlighted == highlighted)
        return;
    [super setHighlighted:highlighted animated:animated];
    
    if (!highlighted && animated) {
        [UIView animateWithDuration:0.5f animations:^{
            [self configureCell:highlighted];
        }];
    } else {
        [self configureCell:highlighted];
    }
}

- (void)configureCell:(BOOL)highlighted {
    self.titleLabel.highlighted = highlighted;
    self.categoryLabel.highlighted = highlighted;
    self.summaryLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.titleLabel.shadowOffset = labelShadowOffset;
    self.categoryLabel.shadowOffset = labelShadowOffset;
    self.summaryLabel.shadowOffset = labelShadowOffset;
    
    self.highlightBgView.alpha = highlighted ? 1.0f : 0;
    self.disclosureImageView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected)
        return;
    [super setSelected:selected animated:animated];
    
    [self setHighlighted:selected animated:animated];
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          category:(NSString *)category
                             title:(NSString *)title
                           summary:(NSString *)summary {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    if (indexPath.row == 0) {
        self.topSeperatorImageView.hidden = YES;
    } else {
        self.topSeperatorImageView.hidden = NO;
    }
    
    self.categoryLabel.text = category;
    self.titleLabel.text = title;
    self.summaryLabel.text = summary;
        
    CGFloat titleLabelOriginalWidth = self.titleLabel.frame.size.width;
    CGFloat titleLabelRealWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat singleLineTitleLabelHeight = [@"Test" sizeWithFont:self.titleLabel.font].height;
    CGFloat singleLineSummaryLabelHeight = [@"Test" sizeWithFont:self.summaryLabel.font].height;
    
    if(titleLabelRealWidth > titleLabelOriginalWidth) {
        // 显示两行新闻标题
        [self.titleLabel resetHeight:singleLineTitleLabelHeight * 2];
        
        // 显示一行简介
        [self.summaryLabel resetHeight:singleLineSummaryLabelHeight];
    } else {
        // 显示一行新闻标题
        [self.titleLabel resetHeight:singleLineTitleLabelHeight];
        
        // 显示两行简介
        [self.summaryLabel resetHeight:singleLineSummaryLabelHeight * 2];
    }
    
    [self.summaryLabel resetOriginY:self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + NEWS_TITLE_SUMMARY_LABEL_MARGIN];
}

@end
