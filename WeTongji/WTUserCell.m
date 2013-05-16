//
//  WTUserCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserCell.h"
#import "User+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTUserCell

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
    self.schoolLabel.highlighted = highlighted;
    self.genderImageView.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.schoolLabel.shadowOffset = labelShadowOffset;
    
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
                              user:(User *)user {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:user.avatar];
    
    self.nameLabel.text = user.name;
    self.schoolLabel.text = user.department;
    if ([user.gender isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"WTGenderGrayMaleIcon"];
        self.genderImageView.highlightedImage = [UIImage imageNamed:@"WTGenderWhiteMaleIcon"];
    } else {
        self.genderImageView.image = [UIImage imageNamed:@"WTGenderGrayFemaleIcon"];
        self.genderImageView.highlightedImage = [UIImage imageNamed:@"WTGenderWhiteFemaleIcon"];
    }
}

@end
