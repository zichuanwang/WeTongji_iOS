//
//  WTNewsCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNewsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *topSeperatorImageView;
@property (nonatomic, weak) IBOutlet UIView *highlightBgView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          category:(NSString *)category
                             title:(NSString *)title
                           summary:(NSString *)summary;

@end
