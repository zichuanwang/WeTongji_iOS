//
//  WTUserCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface WTUserCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *genderImageView;
@property (nonatomic, weak) IBOutlet UILabel *schoolLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *highlightBgView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              user:(User *)user;

@end