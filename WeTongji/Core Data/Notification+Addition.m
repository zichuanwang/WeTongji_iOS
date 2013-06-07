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
#import "Activity+Addition.h"

@implementation Notification (Addition)

+ (NSSet *)insertNotifications:(NSDictionary *)dict {
    NSMutableSet *result = [NSMutableSet set];
    NSArray *notificationsInfoArray = dict[@"Notifications"];
    for (NSDictionary *info in notificationsInfoArray) {
        NSString *notificationType = [NSString stringWithFormat:@"%@", info[@"SourceType"]];
        NSDictionary *sourceDetailsInfo = info[@"SourceDetails"];
        
        // TODO:
        if (sourceDetailsInfo[@"RejectedAt"]) {
            if (![[NSString stringWithFormat:@"%@", sourceDetailsInfo[@"RejectedAt"]] isEqualToString:@"<null>"]) {
                WTLOGERROR(@"Rejected at is not null");
                continue;
            }
        }
        
        if ([notificationType isEqualToString:@"FriendInvite"]) {
            NSMutableDictionary *friendInviteInfo = [NSMutableDictionary dictionaryWithDictionary:sourceDetailsInfo];
            friendInviteInfo[@"Id"] = info[@"Id"];
            friendInviteInfo[@"SourceId"] = info[@"SourceId"];
            Notification *notification = [Notification insertFriendInvitationNotification:friendInviteInfo];
            [result addObject:notification];
        } else if ([notificationType isEqualToString:@"ActivityInvite"]) {
            NSMutableDictionary *activityInviteInfo = [NSMutableDictionary dictionaryWithDictionary:sourceDetailsInfo];
            activityInviteInfo[@"Id"] = info[@"Id"];
            activityInviteInfo[@"SourceId"] = info[@"SourceId"];
            Notification *notification = [Notification insertActivityInvitationNotification:activityInviteInfo];
            [result addObject:notification];
        }
    }
    return result;
}

+ (ActivityInvitationNotification *)insertActivityInvitationNotification:(NSDictionary *)dict {
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!notificationID || [notificationID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    ActivityInvitationNotification *result = (ActivityInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
    }
    result.sourceID = [NSString stringWithFormat:@"%@", dict[@"SourceId"]];
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    result.sender = [User insertUser:dict[@"UserDetails"]];
    result.activity = [Activity insertActivity:dict[@"ActivityDetails"]];
    
    if ([[NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]] isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (FriendInvitationNotification *)insertFriendInvitationNotification:(NSDictionary *)dict {
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!notificationID || [notificationID isEqualToString:@"null"]) {
        return nil;
    }
    
    FriendInvitationNotification *result = (FriendInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"FriendInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
    }
    
    result.sourceID = [NSString stringWithFormat:@"%@", dict[@"SourceId"]];
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    result.sender = [User insertUser:dict[@"UserDetails"]];
    
    if ([[NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]] isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (Notification *)notificationWithID:(NSString *)notificationID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", notificationID]];
    
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
    if ([self isKindOfClass:[InvitationNotification class]]) {
        InvitationNotification *invitation = (InvitationNotification *)self;
        return [WTNotificationInvitationCell cellHeightWithNotificationObject:invitation];
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
