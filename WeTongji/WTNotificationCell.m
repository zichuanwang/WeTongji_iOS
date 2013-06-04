//
//  WTNotificationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationCell.h"
#import <QuartzCore/QuartzCore.h>
#import "User+Addition.h"
#import "Notification+Addition.h"
#import "NSString+WTAddition.h"
#import "UIImageView+AsyncLoading.h"

@implementation WTNotificationCell

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
    [self configureAvatarImageView];
}

#pragma mark - UI methods

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

#pragma mark - Methods to overwrite

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    self.notification = notification;
    [self.avatarImageView loadImageWithImageURLString:notification.sender.avatar];
    self.timeLabel.text = [notification.sendTime convertToYearMonthDayWeekTimeString];
}

@end
