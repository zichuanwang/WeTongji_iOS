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
#import "NSString+WTAddition.h"

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
            result.sendTime = [NSDate date];
            result.sender = testUserArray[i];
        }
    
        result.accepted = @(NO);
        
        [resultArray addObject:result];
    }
    return resultArray;
}

+ (void)insertNotifications:(NSDictionary *)dict {
    NSArray *friendInvitationArray = dict[@"FriendInvites"];
    for (NSDictionary *friendInvitationDict in friendInvitationArray) {
        [Notification insertFriendInvitationNotification:friendInvitationDict];
    }
}

+ (FriendInvitationNotification *)insertFriendInvitationNotification:(NSDictionary *)dict {
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!notificationID || [notificationID isEqualToString:@""]) {
        return nil;
    }
    
    FriendInvitationNotification *result = (FriendInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"FriendInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
    }
    
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    NSString *senderName = [NSString stringWithFormat:@"%@", dict[@"From"]];
    result.sender = [User createTestUserWithName:senderName];
    
    NSString *acceptDateString = [NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]];
    if ([acceptDateString isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (Notification *)notificationWithID:(NSString *)activityID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", activityID]];
    
    Notification *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)deleteNotificationWithID:(NSString *)notificationID {
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", notificationID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
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

+ (void)clearAllNotifications {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context]];
    NSArray *allNotifications = [context executeFetchRequest:request error:NULL];
    
    for(Notification *item in allNotifications) {
        [context deleteObject:item];
    }
}

@end
