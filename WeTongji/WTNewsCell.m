//
//  WTNewsCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsCell.h"

@implementation WTNewsCell

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

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          category:(NSString *)category
                           summary:(NSString *)summary {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = [UIColor colorWithRed:221.0f / 255 green:221.0f / 255 blue:221.0f / 255 alpha:1.0f];
    } else {
        self.containerView.backgroundColor = [UIColor colorWithRed:232.0f / 255 green:232.0f / 255 blue:232.0f / 255 alpha:1.0f];
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
