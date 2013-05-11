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
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    self.searchCategoryTagImageView.image = [[UIImage imageNamed:@"WTSearchTagBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.0f, 0, 4.0f)];
    
    NSString *categoryString = [NSString searchCategoryStringForCategory:category];
    self.searchCategoryLabel.text = categoryString;
    [self.searchCategoryLabel sizeToFit];
    [self.searchCategoryLabel resetHeight:self.searchCategoryTagContainerView.frame.size.height];
    [self.searchCategoryLabel resetWidth:self.searchCategoryLabel.frame.size.width + 12.0f];
    [self.searchCategoryTagContainerView resetWidth:self.searchCategoryLabel.frame.size.width];
    
    self.searchKeywordLabel.text = keyword;
    [self.searchKeywordLabel resetOriginX:self.searchCategoryTagContainerView.frame.origin.x + self.searchCategoryTagContainerView.frame.size.width + 12.0f];
}

@end
