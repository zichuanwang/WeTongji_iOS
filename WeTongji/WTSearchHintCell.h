//
//  WTSearchHintCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

@interface WTSearchHintCell : UITableViewCell

@property (nonatomic, weak) IBOutlet OHAttributedLabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;
@property (nonatomic, weak) IBOutlet UIView *containerView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyWord:(NSString *)keyWord;

@end
