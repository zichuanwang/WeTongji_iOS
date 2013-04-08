//
//  WTNewsCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsCell.h"
#import "WTCommonConstant.h"

@implementation WTNewsCell

#define NEWS_TITLE_SUMMARY_LABEL_MARGIN 4.0f

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          category:(NSString *)category
                             title:(NSString *)title
                           summary:(NSString *)summary {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
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
