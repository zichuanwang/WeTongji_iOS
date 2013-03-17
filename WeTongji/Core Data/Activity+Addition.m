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
    
    result.begin_time = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    result.end_time = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.organizer = [NSString stringWithFormat:@"%@", dict[@"Organizer"]];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.can_schedule = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanSchedule"]]).boolValue);
    result.can_like = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanLike"]]).boolValue);
    result.activity_type = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Channel_Id"]]).integerValue);
    result.created_at = [[NSString stringWithFormat:@"%@", dict[@"CreatedAt"]] convertToDate];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Description"]];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.like_count = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Like"]]).integerValue);
    result.organizer_avatar = [NSString stringWithFormat:@"%@", dict[@"OrganizerAvatar"]];
    
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
//    self.publish_day = [NSString yearMonthDayConvertFromDate:self.publish_date];
}

#pragma mark - Properties

- (NSString *)beginTimeString {
    return [NSString yearMonthDayWeekTimeConvertFromDate:self.begin_time];
}

- (NSString *)beginToEndTimeString {
    return [NSString timeConvertFromBeginDate:self.begin_time endDate:self.end_time];
}

@end
