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
#import "LikeableObject+Addition.h"

#define DAY_TIME_INTERVAL (60 * 60 * 24)
#define HOUR_TIME_INTERVAL (60 * 60)
#define MINUTE_TIME_INTERVAL 60

@implementation Course (Addition)

+ (Course *)insertCourse:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    CourseInfo *info = [CourseInfo insertCourseInfo:dict[@"CourseDetails"]];
    if (!info)
        return nil;
    
    NSString *courseID = info.identifier;
    
    NSDate *courseDay = [[NSString stringWithFormat:@"%@", dict[@"Day"]] convertToDate];
    NSInteger sectionStart = [[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] integerValue];
    NSInteger sectionEnd = [[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] integerValue];
    NSDate *beginTime = [courseDay dateByAddingTimeInterval:
                         [Course getDayTimeIntervalFromSection:sectionStart]];
    NSDate *endTime = [courseDay dateByAddingTimeInterval:
                       [Course getDayTimeIntervalFromSection:sectionEnd]];
    
    
    Course *result = [Course courseWithCourseID:courseID beginTime:beginTime];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = courseID;
        result.objectClass = NSStringFromClass([Course class]);
    }

    result.updatedAt = [NSDate date];
    
    result.info = info;
    result.beginTime = beginTime;
    result.endTime = endTime;
    
    result.what = info.courseName;
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.friendsCount = info.friendsCount;
    
    result.beginDay = [result.beginTime convertToYearMonthDayString];

    // TODO:
    [result configureLikeInfo:dict];
    
    return result;
}

+ (Course *)courseWithCourseID:(NSString *)courseID
                     beginTime:(NSDate *)beginTime {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@ AND beginTime == %@", courseID, beginTime];
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

@implementation CourseInfo (Addition)

+ (CourseInfo *)insertCourseInfo:(NSDictionary *)dict {
    NSString *courseID = [NSString stringWithFormat:@"%@", dict[@"UNO"]];
    
    if ([courseID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    CourseInfo *result = [CourseInfo courseInfoWithCourseID:courseID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInfo"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = courseID;
        result.objectClass = NSStringFromClass([CourseInfo class]);
    }
    
    result.updatedAt = [NSDate date];
    
    result.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    result.hours = @([[NSString stringWithFormat:@"%@", dict[@"Hours"]] integerValue]);
    result.credit = @([[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]);
    result.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];
    result.isAudit = @([[NSString stringWithFormat:@"%@", dict[@"IsAudit"]] boolValue]);
    result.courseNo = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.courseName = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.friendsCount = @([[NSString stringWithFormat:@"%@", dict[@"FriendsCount"]] integerValue]);
    
    for (NSManagedObject *timetable in result.timetables) {
        [[WTCoreDataManager sharedManager].managedObjectContext deleteObject:timetable];
    }
    NSArray *courseTimetableDictArray = dict[@"Sections"];
    for (NSDictionary *timetableDict in courseTimetableDictArray) {
        CourseTimetable *timetable = [CourseTimetable insertCourseTimetable:timetableDict];
        if (timetable) {
            [result addTimetablesObject:timetable];
            timetable.identifier = result.identifier;
        }
    }
    
    return result;
}

+ (CourseInfo *)courseInfoWithCourseID:(NSString *)courseID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CourseInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", courseID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    return [matches lastObject];
}

@end

@implementation CourseTimetable (Addition)

+ (CourseTimetable *)insertCourseTimetable:(NSDictionary *)dict {
    if (!dict || dict.count == 0)
        return nil;
    CourseTimetable *result = [NSEntityDescription insertNewObjectForEntityForName:@"CourseTimetable"
                                                            inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    
    result.startSection = @([[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] integerValue]);
    result.endSection = @([[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] integerValue]);
    result.weekType = [NSString stringWithFormat:@"%@", dict[@"WeekType"]];
    result.weekDay = [NSString stringWithFormat:@"%@", dict[@"WeekDay"]];
    result.location = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    
    return result;
}

@end
