//
//  WTOrganizationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationCell.h"
#import "UIImageView+AsyncLoading.h"
#import "Organization+Addition.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTOrganizationCell

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
    self.aboutLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.aboutLabel.shadowOffset = labelShadowOffset;
    
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
                      organization:(Organization *)org {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:org.avatar];
    
    self.nameLabel.text = org.name;
    self.aboutLabel.text = org.about;
}

@end
