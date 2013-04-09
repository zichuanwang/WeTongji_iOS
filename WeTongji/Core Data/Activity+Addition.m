//
//  Activity+Addition.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "Activity+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"

@implementation Activity (Addition)

+ (Activity *)insertActivity:(NSDictionary *)dict {
    NSString *activityID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!activityID || [activityID isEqualToString:@""]) {
        return nil;
    }
    
    Activity *result = [Activity activityWithID:activityID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = activityID;
    }
    
    result.updateTime = [NSDate date];
    result.beginTime = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.organizer = [NSString stringWithFormat:@"%@", dict[@"Organizer"]];
    result.what = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.canSchedule = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanSchedule"]]).boolValue);
    result.canLike = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanLike"]]).boolValue);
    result.activityType = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Channel_Id"]]).integerValue);
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"CreatedAt"]] convertToDate];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Description"]];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.likeCount = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Like"]]).integerValue);
    result.organizerAvatar = [NSString stringWithFormat:@"%@", dict[@"OrganizerAvatar"]];
    
    if (!result.canSchedule.boolValue) {
        [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:result];
    }
    
    return result;
}

+ (Activity *)activityWithID:(NSString *)activityID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", activityID]];
    
    Activity *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)clearAllActivites {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:context]];
    NSArray *allActivities = [context executeFetchRequest:request error:NULL];
    
    for(Activity *item in allActivities) {
        [context deleteObject:item];
    }
}

- (void)awakeFromFetch {
}

@end
