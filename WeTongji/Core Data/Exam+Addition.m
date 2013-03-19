//
//  Exam+Addition.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Exam+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"

@implementation Exam (Addition)

+ (Exam *)insertExam:(NSDictionary *)dic
{
    NSString *examNo = [NSString stringWithFormat:@"%@",dic[@"NO"]];
    
    if (!examNo || [examNo isEqualToString:@""]) {
        return nil;
    }
    
    Exam *exam = [Exam examWithNo:examNo];
    if (!exam) {
        exam = [NSEntityDescription insertNewObjectForEntityForName:@"Exam"
                                             inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    }
    exam.identifier = examNo;
    exam.name = [NSString stringWithFormat:@"%@",dic[@"Name"]];
    exam.teacher = [NSString stringWithFormat:@"%@",dic[@"Teacher"]];
    exam.location = [NSString stringWithFormat:@"%@",dic[@"Location"]];
    exam.where = exam.location;
    exam.begin = [[NSString stringWithFormat:@"%@",dic[@"Begin"]] convertToDate];
    exam.begin_time = exam.begin;
    exam.end = [[NSString stringWithFormat:@"%@",dic[@"End"]] convertToDate];
    exam.point = (NSNumber *)dic[@"Point"];
    exam.required = (NSNumber *)dic[@"Required"];
    exam.hours = (NSNumber *)dic[@"Hours"];

    return exam;
}

+ (Exam *)examWithNo:(NSString *)examNO
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",examNO];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    return [matches lastObject];
}

+ (void)clearAllExams
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context]];
    NSArray *allCourses = [context executeFetchRequest:request error:NULL];
    
    for(Exam *exam in allCourses) {
        [context deleteObject:exam];
    }
}

@end
