//
//  WTNowBaseCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

typedef enum {
    WTNowBaseCellTypePast,
    WTNowBaseCellTypeNormal,
    WTNowBaseCellTypeNow,
} WTNowBaseCellType;

@interface WTNowBaseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *nowView;
@property (nonatomic, weak) IBOutlet UILabel *whenLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *friendsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *whereLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ringImageView;
@property (nonatomic, weak) IBOutlet UILabel *nowLabel;

- (void)updateCellStatus:(WTNowBaseCellType)type;

@end
