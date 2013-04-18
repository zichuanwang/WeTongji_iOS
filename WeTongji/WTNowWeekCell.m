//
//  WTNowWeekCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowWeekCell.h"
#import "WTNowTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WTNowWeekCell ()

@property (nonatomic, strong) WTNowTableViewController *tableViewController;

@end

@implementation WTNowWeekCell

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

- (void)awakeFromNib {
    self.tableViewController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.tableViewController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.tableViewController.view];
}

- (void)configureCellWithWeekNumber:(NSUInteger)weekNumber {
    self.tableViewController.weekNumber = weekNumber;
    self.tableViewController.tableView.contentOffset = CGPointMake(0, 1);
}

- (void)scrollToNow:(BOOL)animated {
    [self.tableViewController scrollToNow:animated];
}

#pragma mark - Properties

- (WTNowTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[WTNowTableViewController alloc] init];
    }
    return _tableViewController;
}

@end
