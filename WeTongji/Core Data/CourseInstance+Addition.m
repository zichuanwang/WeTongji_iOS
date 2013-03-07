//
//  CourseInstance+Addition.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "CourseInstance+Addition.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"

#define DAY_TIME_INTERVAL (60 * 60 * 24)
#define HOUR_TIME_INTERVAL (60 * 60)
#define MINUTE_TIME_INTERVAL 60

@implementation CourseInstance (Addition)
+ (CourseInstance *)insertCourseInstance:(NSDictionary *)dic
{
    NSString *courseNO = [NSString stringWithFormat:@"%@", dic[@"NO"]];
    
    if (!courseNO || [courseNO isEqualToString:@""]) {
        return nil;
    }
    
    NSDate *courseDay = [[NSString stringWithFormat:@"%@",dic[@"Day"]] convertToDate];
    CourseInstance *course = [CourseInstance courseInstanceAtDay:courseDay];
    if (!course) {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    }
    course.identifier = courseNO;
    course.hours = (NSNumber *)dic[@"Hours"];
    course.point = (NSNumber *)dic[@"Point"];
    course.name = [NSString stringWithFormat:@"%@",dic[@"Name"]];
    course.teacher = [NSString stringWithFormat:@"%@",dic[@"Teacher"]];
    course.weekType = [NSString stringWithFormat:@"%@",dic[@"WeekType"]];
    course.weekDay = [NSString stringWithFormat:@"%@",dic[@"WeekDay"]];
    course.sectionStart = (NSNumber *)dic[@"SectionStart"];
    course.sectionEnd = (NSNumber *)dic[@"SectionEnd"];
    course.required = (NSNumber *)dic[@"Required"];
    course.location = [NSString stringWithFormat:@"%@",dic[@"Location"]];
    course.courseAtDay = courseDay;
    course.beginTime = [courseDay dateByAddingTimeInterval:[CourseInstance getDayTimeIntervalFromSection:course.sectionStart]];
    
    return course;
}

+ (CourseInstance *)courseInstanceAtDay:(NSDate *)date
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CourseInstace"];
    request.predicate = [NSPredicate predicateWithFormat:@"courseAtDay = %@",date];
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
