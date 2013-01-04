//
//  WTEventTableViewCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

enum eCellStatus{
  ePAST = 0,
  eNORMAL = 1,
  eNOW = 2
};

@interface WTEventTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *bgView;
@property (nonatomic, weak) IBOutlet UIView *nowView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *friendsNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventLocationLabel;
- (void)updateCellStatus:(int)status;
@end
