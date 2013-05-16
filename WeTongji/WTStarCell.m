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
    self.pageLabel.highlighted = highlighted;
    self.descriptionLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.pageLabel.shadowOffset = labelShadowOffset;
    self.descriptionLabel.shadowOffset = labelShadowOffset;
    
    self.highlightedBGView.alpha = highlighted ? 1.0f : 0;
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
        self.topSeprateImageView.hidden = YES;
    } else {
        self.topSeprateImageView.hidden = NO;
    }

    self.nameLabel.text = star.name;
    self.descriptionLabel.text = star.content;
    if(indexPath.row == 0)
    {
         self.pageLabel.text = @"本期人物";
         self.pageLabel.textColor = [UIColor colorWithRed:234/255.0 green:82/255.0 blue:81/255.9 alpha:1];
    }
    else
    {
        self.pageLabel.text = [NSString stringWithFormat:@"第%d期",1];
        self.pageLabel.textColor = [UIColor colorWithRed:12/255.0 green:192/255.0 blue:203/255.9 alpha:1];
    }
   [self.avatarImageView loadImageWithImageURLString:star.avatar];
    self.avatarImageView.layer.cornerRadius = 6.0;
    self.avatarImageView.layer.masksToBounds = YES;
}


@end
