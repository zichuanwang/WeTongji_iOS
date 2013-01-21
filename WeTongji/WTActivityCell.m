//
//  WTActivityCell.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTActivityCell.h"

@interface WTActivityCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation WTActivityCell

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

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title time:(NSString *)time location:(NSString *)location imageName:(NSString *)imageName {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = [UIColor colorWithRed:221.0f / 255 green:221.0f / 255 blue:221.0f / 255 alpha:1.0f];
    } else {
        self.containerView.backgroundColor = [UIColor colorWithRed:232.0f / 255 green:232.0f / 255 blue:232.0f / 255 alpha:1.0f];
    }
    self.titleLabel.text = title;
    self.timeLabel.text = time;
    self.locationLabel.text = location;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
