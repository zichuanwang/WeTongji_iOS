//
//  WTStarCell.m
//  WeTongji
//
//  Created by Song on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarCell.h"
#import "Star+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTStarCell

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
    if (self.selected == selected)
        return;
    [super setSelected:selected animated:animated];
    
    [self setHighlighted:selected animated:animated];
    // Configure the view for the selected state
}


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
    self.nameLabel.highlighted = highlighted;
    self.starNumberLabel.highlighted = highlighted;
    self.mottoLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.starNumberLabel.shadowOffset = labelShadowOffset;
    self.mottoLabel.shadowOffset = labelShadowOffset;
    
    self.highlightedBgView.alpha = highlighted ? 1.0f : 0;
    self.disclosureImageView.highlighted = highlighted;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              Star:(Star *)star;
{
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
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:star.avatar];
    
    self.nameLabel.text = star.name;
    self.mottoLabel.text = star.motto;
    
    if(indexPath.row == 0) {
        self.starNumberLabel.text = @"本期人物";
        self.starNumberLabel.textColor = [UIColor colorWithRed:234.0f / 255 green:82.0f / 255 blue:81.0f / 255 alpha:1.0f];
    }
    else {
        self.starNumberLabel.text = [NSString stringWithFormat:@"第%@期", star.starNumber];
        self.starNumberLabel.textColor = [UIColor colorWithRed:12.0f / 255 green:192.0f / 255 blue:203.0f / 255 alpha:1.0f];
    }
}


@end
