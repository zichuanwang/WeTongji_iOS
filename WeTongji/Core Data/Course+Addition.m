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
    
    if (!courseID || [courseID isEqualToString:@""]) {
        return nil;
    }
    
    NSDate *courseDay = [[NSString stringWithFormat:@"%@", dict[@"Day"]] convertToDate];
    Course *course = [Course courseScheduleAtDay:courseDay withCourseID:courseID];
    if (!course) {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        course.identifier = courseID;
    }

    course.what = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    course.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    
    course.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    
    course.courseDay = courseDay;
    course.sectionStart = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] intValue]];
    course.sectionEnd = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] intValue]];
    course.beginTime = [courseDay dateByAddingTimeInterval:
                         [Course getDayTimeIntervalFromSection:course.sectionStart.intValue]];
    course.endTime = [courseDay dateByAddingTimeInterval:
                       [Course getDayTimeIntervalFromSection:course.sectionEnd.intValue]];
    
    course.hours = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"Hours"]] intValue]];
    course.point = [NSNumber numberWithFloat: [[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]];
    course.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];
    
    course.weekType = [NSString stringWithFormat:@"%@", dict[@"WeekType"]];
    course.weekDay = [NSString stringWithFormat:@"%@", dict[@"WeekDay"]];
    
    return course;
}

+ (Course *)courseScheduleAtDay:(NSDate *)date withCourseID:(NSString *)courseID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"courseDay = %@ AND identifier = %@", date, courseID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    return [matches lastObject];
}

+ (void)clearAllCourses
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:context]];
    NSArray *allCourses = [context executeFetchRequest:request error:NULL];
    
    for(Course *course in allCourses) {
        [context deleteObject:course];
    }
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

- (NSString *)courseBeginToEndTime
{
    return [NSString stringWithFormat:@"%@-%@",
            [NSString timeConvertFromDate:self.beginTime],[NSString timeConvertFromDate:self.endTime]];
}

@end
