//
//  WTAbstractEventCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTAbstractEventCell.h"
#define kNowTimeLabelX 10
#define kNowTimeLabelY 19

@implementation WTAbstractEventCell

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

- (void)resetCellForNow
{
    self.nowView.hidden = FALSE;
    CGRect frame = self.timeLabel.frame;
    frame.origin.x = kNowTimeLabelX;
    frame.origin.y = kNowTimeLabelY;
    self.timeLabel.frame = frame;
}

- (void)resetCellForNormalAndPast
{
    CGRect frame = self.timeLabel.frame;
    frame.origin.x = self.nowView.frame.origin.x;
    frame.origin.y = self.nowView.frame.origin.y;
    self.timeLabel.frame = frame;
    self.nowView.hidden= YES;
}

- (void)updateCellStatus:(int)status
{
    if (status == ePAST) {
        [self resetCellForNormalAndPast];
        self.bgView.image = [UIImage imageNamed:@"past_event_cell"];
    } else if (status == eNORMAL){
        [self resetCellForNormalAndPast];
        self.bgView.image = [UIImage imageNamed:@"now_event_cell"];
    } else {
        [self resetCellForNow];
        self.bgView.image = [UIImage imageNamed:@"now_class_cell"];
    }
}

@end
