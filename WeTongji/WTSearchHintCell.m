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
