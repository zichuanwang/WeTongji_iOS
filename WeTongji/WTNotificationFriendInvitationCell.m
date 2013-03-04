//
//  WTNotificationFriendInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationFriendInvitationCell.h"
#import "FriendInvitationNotification.h"

@interface WTNotificationFriendInvitationCell()

@end

@implementation WTNotificationFriendInvitationCell

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

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    
}

#pragma mark - Methods to overwrite

+ (CGFloat)cellHeightWithNotificationObject:(FriendInvitationNotification *)notification {
    if (notification.accepted.boolValue) {
        return 76;
    } else {
        return 130;
    }
}

@end
