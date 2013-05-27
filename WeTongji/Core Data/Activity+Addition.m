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
#import "Object+Addtion.h"

@implementation Activity (Addition)

+ (Activity *)insertActivity:(NSDictionary *)dict {
    NSString *activityID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!activityID || [activityID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    Activity *result = [Activity activityWithID:activityID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = activityID;
        result.objectClass = NSStringFromClass([Activity class]);
    }
    
    result.updatedAt = [NSDate date];
    result.beginTime = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.organizer = [NSString stringWithFormat:@"%@", dict[@"Organizer"]];
    result.what = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.canSchedule = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanSchedule"]]).boolValue);
    result.canLike = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanLike"]]).boolValue);
    [result configureActivityCategory:((NSString *)[NSString stringWithFormat:@"%@", dict[@"Channel_Id"]]).integerValue];
    
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"CreatedAt"]] convertToDate];
    result.content = [[NSString stringWithFormat:@"%@", dict[@"Description"]] clearAllBacklashR];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    if ([result.image isEmptyImageURL])
        result.image = nil;
    
    result.likeCount = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Like"]]).integerValue);
    result.organizerAvatar = [NSString stringWithFormat:@"%@", dict[@"OrganizerAvatar"]];
    
    if (!result.canSchedule.boolValue) {
        [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:result];
    }
    
    result.beginDay = [NSString yearMonthDayConvertFromDate:result.beginTime];
    
    return result;
}

+ (Activity *)activityWithID:(NSString *)activityID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", activityID]];
    
    Activity *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    WTLOG(@"activityWithID:%@, pointer:%p", activityID, result);
    
    return result;
}

+ (void)setAllActivitesFreeFromHolder:(Class)holderClass
                           inCategory:(NSNumber *)category {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"category == %@", category]];
    NSArray *allActivities = [context executeFetchRequest:request error:NULL];
    
    for(Activity *item in allActivities) {
        [item setObjectFreeFromHolder:holderClass];
    }
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
}

- (void)configureActivityCategory:(NSInteger)activityChannelID {
    switch (activityChannelID) {
        case 1:
            self.category = @(ActivityShowTypeAcademics);
            break;
        case 2:
            self.category = @(ActivityShowTypeCompetition);
            break;
        case 3:
            self.category = @(ActivityShowTypeEntertainment);
            break;
        case 4:
            self.category = @(ActivityShowTypeEnterprise);
            break;
        default:
            break;
    }
}

- (NSString *)categoryString {
    return [Activity convertCategoryStringFromCategory:self.category];
}

+ (NSString *)convertCategoryStringFromCategory:(NSNumber *)category {
    NSString *result = nil;
    switch (category.integerValue) {
        case ActivityShowTypeAcademics:
            result = NSLocalizedString(@"Academics", nil);
            break;
        case ActivityShowTypeCompetition:
            result = NSLocalizedString(@"Competition", nil);
            break;
        case ActivityShowTypeEntertainment:
            result = NSLocalizedString(@"Entertainment", nil);
            break;
        case ActivityShowTypeEnterprise:
            result = NSLocalizedString(@"Enterprise", nil);
            break;
        default:
            break;
    }
    return result;
}

@end
