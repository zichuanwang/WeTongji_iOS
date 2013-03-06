//
//  Notification+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Notification+Addition.h"
#import "WTCoreDataManager.h"
#import "FriendInvitationNotification.h"
#import "ActivityInvitationNotification.h"
#import "User+Addition.h"
#import "WTNotificationFriendInvitationCell.h"

@implementation Notification (Addition)

+ (NSArray *)createTestFriendInvitationNotifications {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *testUserArray = [User createTestUsers];
    
    for (int i = 0; i < 5; i++) {
        NSString *notificationID = [NSString stringWithFormat:@"%d", i];
        
        if (!notificationID || [notificationID isEqualToString:@""]) {
            continue;
        }
        
        FriendInvitationNotification *result = (FriendInvitationNotification *)[Notification notificationWithID:notificationID];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"FriendInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
            result.identifier = notificationID;
            result.send_time = [NSDate date];
            result.sender = testUserArray[i];
        }
    
        result.accepted = @(NO);
        
        [resultArray addObject:result];
    }
    return resultArray;
}

+ (Notification *)notificationWithID:(NSString *)activityID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", activityID]];
    
    Notification *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

- (NSString *)customCellClassName {
    if ([self isMemberOfClass:[FriendInvitationNotification class]]) {
        return @"WTNotificationFriendInvitationCell";
    } else if ([self isMemberOfClass:[ActivityInvitationNotification class]]) {
        return @"WTNotificationActivityInvitationCell";
    } else {
        return nil;
    }
}

- (CGFloat)cellHeight {
    if ([self isMemberOfClass:[FriendInvitationNotification class]]) {
        FriendInvitationNotification *invitation = (FriendInvitationNotification *)self;
        return [WTNotificationFriendInvitationCell cellHeightWithNotificationObject:invitation];
    } else {
        return 0;
    }
}

@end
