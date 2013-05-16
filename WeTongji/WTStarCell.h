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
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topSeprateImageView;
@property (weak, nonatomic) IBOutlet UIView *highlightedBGView;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          Star:(Star *)star;
@end
