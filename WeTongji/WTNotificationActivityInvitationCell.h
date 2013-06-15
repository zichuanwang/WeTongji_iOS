//
//  WTNotificationActivityInvitationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNotificationCell.h"
#import "WTNotificationInvitationCell.h"

@interface WTNotificationActivityInvitationCell : WTNotificationInvitationCell

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName
                                                                           activityTitle:(NSString *)activityTitle
                                                                                accepted:(BOOL)accepted;

@end
