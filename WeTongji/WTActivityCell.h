//
//  WTActivityCell.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTActivityCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *image;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                             title:(NSString *)title
                              time:(NSString *)time
                          location:(NSString *)location
                         imageName:(NSString *)imageName;


@end
