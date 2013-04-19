//
//  WTActivityCell.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTActivityCell.h"
#import "UIImageView+AsyncLoading.h"

@interface WTActivityCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation WTActivityCell

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
    self.titleLabel.highlighted = highlighted;
    self.timeLabel.highlighted = highlighted;
    self.locationLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.titleLabel.shadowOffset = labelShadowOffset;
    self.timeLabel.shadowOffset = labelShadowOffset;
    self.locationLabel.shadowOffset = labelShadowOffset;
    
    self.highlightBgView.alpha = highlighted ? 1.0f : 0;
    self.disclosureImageView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected)
        return;
    [super setSelected:selected animated:animated];
    
    [self setHighlighted:selected animated:animated];
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title time:(NSString *)time location:(NSString *)location imageURL:(NSString *)imageURL {
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
    
    self.titleLabel.text = title;
    self.timeLabel.text = time;
    self.locationLabel.text = location;
    [self.posterImageView loadImageWithImageURLString:imageURL];
}

@end
