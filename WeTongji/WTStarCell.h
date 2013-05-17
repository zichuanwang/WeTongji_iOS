//
//  WTStarCell.h
//  WeTongji
//
//  Created by Song on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Star;

@interface WTStarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mottoLabel;
@property (weak, nonatomic) IBOutlet UILabel *starNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topSeperatorImageView;
@property (weak, nonatomic) IBOutlet UIView *highlightedBgView;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              Star:(Star *)star;
@end
