//
//  Event+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Event+Addition.h"
#import "Object+Addtion.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"

@implementation Event (Addition)

+ (NSArray *)getTodayEvents {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (!currentUser)
        return nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDate *lastMidnight = [[NSCalendar currentCalendar] dateFromComponents:todayComponents];
    NSDate *nextMidnight = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:lastMidnight options:NSWrapCalendarComponents];
    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (endTime >= %@) AND (endTime <= %@)", currentUser.scheduledEvents, [NSDate date], nextMidnight];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
    
    NSArray *allEvents = [context executeFetchRequest:request error:NULL];
    // TODO:test
    NSArray *result = nil;
    if (allEvents.count >= 2) {
        result = [NSArray arrayWithObjects:allEvents[0], allEvents[1], nil];
    } else if (allEvents.count == 1) {
        result = [NSArray arrayWithObject:allEvents.lastObject];
    }
    return result;
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    self.beginDay = [NSString yearMonthDayConvertFromDate:self.beginTime];
}

+ (void)setCurrentUserScheduledEventsFreeFromHolder:(id)holder
                                           fromDate:(NSDate *)beginDate
                                             toDate:(NSDate *)endDate {
    
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (!currentUser)
        return;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (beginTime >= %@) AND (beginTime <= %@)", currentUser.scheduledEvents, beginDate, endDate];
    NSArray *results = [context executeFetchRequest:request error:NULL];
    
    for(Event *item in results) {
        [item setObjectFreeFromHolder:holder];
    }
}

#pragma mark - Properties

- (BOOL)isEventStartToday {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDate *lastMidnight = [[NSCalendar currentCalendar] dateFromComponents:todayComponents];
    NSDate *nextMidnight = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:lastMidnight options:NSWrapCalendarComponents];
    return ([self.beginTime compare:lastMidnight] == NSOrderedDescending && [self.endTime compare:nextMidnight] == NSOrderedAscending);
}

- (NSString *)yearMonthDayBeginToEndTimeString {
    if ([self isEventStartToday]) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Today", nil), [NSString timeConvertFromBeginDate:self.beginTime endDate:self.endTime]];
    } else {
        return [NSString yearMonthDayWeekTimeConvertFromBeginDate:self.beginTime endDate:self.endTime];
    }
}

- (NSString *)beginToEndTimeString {
    return [NSString timeConvertFromBeginDate:self.beginTime endDate:self.endTime];
}

@end
