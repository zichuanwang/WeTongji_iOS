//
//  WTSearchHintCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHintCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+WTAddition.h"
#import "NSString+WTAddition.h"

@implementation WTSearchHintCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected)
        return;
    [super setSelected:selected animated:animated];
    
    [self setHighlighted:selected animated:animated];
}

- (void)configureCell:(BOOL)highlighted {
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithAttributedString:self.label.attributedText];
    
    [attributedString setTextColor:highlighted ? [UIColor whiteColor] : [UIColor colorWithRed:64.0f / 255 green:64.0f / 255 blue:64.0f / 255 alpha:1.0f]];
    
    self.label.attributedText = attributedString;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.label.shadowOffset = labelShadowOffset;
    
    self.highlightBgView.alpha = highlighted ? 1.0f : 0;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    NSMutableAttributedString *labelAttributedString = nil;
    
    if (indexPath.row == 0) {
        
        NSString *cellLabelString = NSLocalizedString(@"Search all", nil);
        labelAttributedString = [NSMutableAttributedString attributedStringWithString:cellLabelString];
        [labelAttributedString setAttributes:[self.label.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, labelAttributedString.length)];

    } else {
        NSString *categoryString = [NSString searchCategoryStringForCategory:indexPath.row];
        labelAttributedString = [NSMutableAttributedString attributedStringWithAttributedString:[NSAttributedString searchHintStringForKeyword:keyword category:categoryString attributes:[self.label.attributedText attributesAtIndex:0 effectiveRange:NULL]]];
    }
    
    self.label.attributedText = labelAttributedString;
}

@end
