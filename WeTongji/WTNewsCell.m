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

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          category:(NSString *)category
                           summary:(NSString *)summary {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    self.categoryLabel.text = category;
    self.summaryLabel.text = summary;
    
    [self.summaryLabel resetFrameWithOrigin:CGPointMake(14, 34) size:CGSizeMake(270, 30)];
    
    CGFloat summaryLabelOriginalWidth = self.summaryLabel.frame.size.width;
    CGFloat summaryLabelRealWidth = [self.summaryLabel.text sizeWithFont:self.summaryLabel.font].width;
    CGFloat singleLineSummaryLabelHeight = [@"Test" sizeWithFont:self.summaryLabel.font].height;
    
    if(summaryLabelRealWidth > summaryLabelOriginalWidth) {
        NSUInteger maxLineNumber = 2;
        [self.summaryLabel resetSize:CGSizeMake(summaryLabelOriginalWidth, singleLineSummaryLabelHeight * maxLineNumber)];
        [self.summaryLabel resetCenterY:(self.categoryLabel.frame.size.height + self.categoryLabel.frame.origin.y + self.frame.size.height) / 2 - 2];
    }
}

@end
