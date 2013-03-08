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
    }
    
    result.identifier = activityID;
    result.begin = [NSString stringWithFormat:@"%@", dict[@"Begin"]];
    result.begin_time = [result.begin convertToDate];
    result.end = [NSString stringWithFormat:@"%@", dict[@"End"]];
    result.location = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.organizer = [NSString stringWithFormat:@"%@", dict[@"Organizer"]];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.canFavorite = (NSNumber *)dict[@"CanFavorite"];
    result.canSchedule = (NSNumber *)dict[@"CanSchedule"];
    result.canLike = (NSNumber *)dict[@"CanLike"];
    result.channelId = (NSNumber *)dict[@"Channel_Id"];
    result.createdAt = [NSString stringWithFormat:@"%@", dict[@"CreatedAt"]];
    result.activityDescription = [NSString stringWithFormat:@"%@", dict[@"Description"]];
    result.favorite = (NSNumber *)dict[@"Favorite"];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.like = (NSNumber *)dict[@"Like"];
    result.organizerAvatar = [NSString stringWithFormat:@"%@", dict[@"OrganizerAvatar"]];
    result.schedule = (NSNumber *)dict[@"Schedule"];
    result.status = [NSString stringWithFormat:@"%@", dict[@"Status"]];
    
    return result;
}

+ (Activity *)activityWithID:(NSString *)activityID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", activityID]];
    
    Activity *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

- (void)awakeFromFetch {
//    self.publish_day = [NSString yearMonthDayConvertFromDate:self.publish_date];
}

#pragma mark - Properties

- (NSString *)beginTimeString {
    NSDate *beginDate = [self.begin convertToDate];
    return [NSString yearMonthDayWeekTimeConvertFromDate:beginDate];
}

- (NSString *)beginToEndTimeString {
    NSDate *beginDate = [self.begin convertToDate];
    NSDate *endDate = [self.end convertToDate];
    return [NSString timeConvertFromBeginDate:beginDate endDate:endDate];
}

@end
