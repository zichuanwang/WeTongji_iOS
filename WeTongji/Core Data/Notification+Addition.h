//
//  Notification+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Notification.h"

@interface Notification (Addition)

+ (NSArray *)createTestFriendInvitationNotifications;

- (NSString *)customCellClassName;

- (CGFloat)cellHeight;

@end
