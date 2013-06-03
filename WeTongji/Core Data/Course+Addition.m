//
//  CourseInstance+Addition.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course+Addition.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"

#define DAY_TIME_INTERVAL (60 * 60 * 24)
#define HOUR_TIME_INTERVAL (60 * 60)
#define MINUTE_TIME_INTERVAL 60

@implementation Course (Addition)
+ (Course *)insertCourse:(NSDictionary *)dict {
    NSString *courseID = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    
    if (!courseID || [courseID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    NSDate *courseDay = [[NSString stringWithFormat:@"%@", dict[@"Day"]] convertToDate];
    Course *result = [Course courseScheduleAtDay:courseDay withCourseID:courseID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = courseID;
        result.objectClass = NSStringFromClass([Course class]);
    }

    result.what = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    
    result.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    
    result.courseDay = courseDay;
    result.sectionStart = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] intValue]];
    result.sectionEnd = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] intValue]];
    result.beginTime = [courseDay dateByAddingTimeInterval:
                         [Course getDayTimeIntervalFromSection:result.sectionStart.intValue]];
    result.endTime = [courseDay dateByAddingTimeInterval:
                       [Course getDayTimeIntervalFromSection:result.sectionEnd.intValue]];
    
    result.hours = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"Hours"]] intValue]];
    result.credit = [NSNumber numberWithFloat: [[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]];
    result.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];
    
    result.weekType = [NSString stringWithFormat:@"%@", dict[@"WeekType"]];
    result.weekDay = [NSString stringWithFormat:@"%@", dict[@"WeekDay"]];
    
    result.beginDay = [result.beginTime convertToYearMonthDayString];
    
    return result;
}

+ (Course *)courseScheduleAtDay:(NSDate *)date withCourseID:(NSString *)courseID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"courseDay = %@ AND identifier = %@", date, courseID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    return [matches lastObject];
}

+ (NSTimeInterval)getDayTimeIntervalFromSection:(NSInteger)section {
    NSTimeInterval result = 0;
    switch (section) {
        case 1:
            result = 8 * HOUR_TIME_INTERVAL;
            break;
        case 2:
            result = 9 * HOUR_TIME_INTERVAL + 40 * MINUTE_TIME_INTERVAL;
            break;
        case 3:
            result = 10 * HOUR_TIME_INTERVAL;
            break;
        case 4:
            result = 11 * HOUR_TIME_INTERVAL + 40 * MINUTE_TIME_INTERVAL;
            break;
        case 5:
            result = 13 * HOUR_TIME_INTERVAL + 30 * MINUTE_TIME_INTERVAL;
            break;
        case 6:
            result = 15 * HOUR_TIME_INTERVAL + 5 * MINUTE_TIME_INTERVAL;
            break;
        case 7:
            result = 15 * HOUR_TIME_INTERVAL + 25 * MINUTE_TIME_INTERVAL;
            break;
        case 8:
            result = 17 * HOUR_TIME_INTERVAL;
            break;
        case 9:
            result = 18 * HOUR_TIME_INTERVAL + 30 * MINUTE_TIME_INTERVAL;
            break;
        case 10:
            result = 20 * HOUR_TIME_INTERVAL + 10 * MINUTE_TIME_INTERVAL;
            break;
        case 11:
            result = 21 * HOUR_TIME_INTERVAL + 5 * MINUTE_TIME_INTERVAL;
            break;
        default:
            break;
    }
    return result;
}

@end
