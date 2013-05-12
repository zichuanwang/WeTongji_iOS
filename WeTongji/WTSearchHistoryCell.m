//
//  WTSearchHistoryCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHistoryCell.h"
#import "NSString+WTAddition.h"

@implementation WTSearchHistoryCell

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
    self.searchKeywordLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.searchKeywordLabel.shadowOffset = labelShadowOffset;
    
    self.highlightBgView.alpha = highlighted ? 1.0f : 0;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    if (keyword) {
        self.searchCategoryTagContainerView.hidden = NO;
        
        self.searchCategoryTagImageView.image = [[UIImage imageNamed:@"WTSearchTagBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.0f, 0, 4.0f)];
        
        NSString *categoryString = [NSString searchCategoryStringForCategory:category];
        self.searchCategoryLabel.text = categoryString;
        [self.searchCategoryLabel sizeToFit];
        [self.searchCategoryLabel resetHeight:self.searchCategoryTagContainerView.frame.size.height];
        [self.searchCategoryLabel resetWidth:self.searchCategoryLabel.frame.size.width + 12.0f];
        [self.searchCategoryTagContainerView resetWidth:self.searchCategoryLabel.frame.size.width];
        
        self.searchKeywordLabel.text = keyword;
        [self.searchKeywordLabel resetOriginX:self.searchCategoryTagContainerView.frame.origin.x + self.searchCategoryTagContainerView.frame.size.width + 12.0f];
    } else {
        self.searchCategoryTagContainerView.hidden = YES;
        self.searchKeywordLabel.text = NSLocalizedString(@"Clear search history", nil);
        [self.searchKeywordLabel resetOriginX:self.searchCategoryTagContainerView.frame.origin.x];
    }
    
}

@end
