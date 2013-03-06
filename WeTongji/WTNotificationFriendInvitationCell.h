//
//  WTNotificationFriendInvitationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNotificationCell.h"

@class FriendInvitationNotification;

@interface WTNotificationFriendInvitationCell : WTNotificationCell

@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *ignoreButton;
@property (nonatomic, weak) IBOutlet UIView *buttonContainerView;

- (IBAction)didClickAcceptButton:(UIButton *)sender;
- (IBAction)didClickIgnoreButton:(UIButton *)sender;

+ (CGFloat)cellHeightWithNotificationObject:(FriendInvitationNotification *)notification;

@end
