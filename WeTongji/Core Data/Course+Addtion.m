//
//  Course+Addtion.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course+Addtion.h"
#import "WTCoreDataManager.h"

@implementation Course (Addtion)
+ (Course *)insertCourse:(NSDictionary *)dic
{
    NSString *courseNO = [NSString stringWithFormat:@"%@", dic[@"NO"]];
    
    if (!courseNO || [courseNO isEqualToString:@""]) {
        return nil;
    }
    
    Course *course = [Course courseWithCourseNO:courseNO];
    if (!course) {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
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

    return course;
}

+ (Course *)courseWithCourseNO:(NSString *)couserNO
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",couserNO];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    return [matches lastObject];
}

@end
