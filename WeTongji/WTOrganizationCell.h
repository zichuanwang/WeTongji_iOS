//
//  WTOrganizationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Organization;

@interface WTOrganizationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *highlightBgView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                      organization:(Organization *)org;

@end
