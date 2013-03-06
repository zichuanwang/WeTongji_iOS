//
//  Course+Addtion.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course+Addtion.h"
#import "WTCoreDataManager.h"
#define DAY_TIME_INTERVAL (60 * 60 * 24)
#define HOUR_TIME_INTERVAL (60 * 60)
#define MINUTE_TIME_INTERVAL 60

@implementation Course (Addtion)
+ (Course *)insertCourse:(NSDictionary *)dic
{
    NSString *courseNO = [NSString stringWithFormat:@"%@", dic[@"NO"]];
    
    if (!courseNO || [courseNO isEqualToString:@""]) {
        return nil;
    }
    
    Course *course = [Course courseWithCourseNO:courseNO];
    if (!courseNO) {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    }
    course.identifier = courseNO;
    course.hours = dic[@"Hours"];
    course.point = dic[@"Point"];
    course.name = [NSString stringWithFormat:@"%@",dic[@"Name"]];
    course.teacher = [NSString stringWithFormat:@"%@",dic[@"Teacher"]];
    course.weekType = [NSString stringWithFormat:@"%@",dic[@"WeekType"]];
    course.weekDay = [NSString stringWithFormat:@"%@",dic[@"WeekDay"]];
    course.sectionStart = dic[@"SectionStart"];
    course.sectionEnd = dic[@"SectionEnd"];
    course.required = dic[@"Required"];
    course.location = [NSString stringWithFormat:@"%@",dic[@"Location"]];

    return course;
}

+ (Course *)courseWithCourseNO:(NSString *)couserNO
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",couserNO];
    request.sortDescriptors = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES]];
    
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
