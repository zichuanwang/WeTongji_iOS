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

+ (Exam *)insertExam:(NSDictionary *)dict {
    NSString *examID = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    
    if (!examID || [examID isEqualToString:@""]) {
        return nil;
    }
    
    Exam *exam = [Exam examWithID:examID];
    if (!exam) {
        exam = [NSEntityDescription insertNewObjectForEntityForName:@"Exam"
                                             inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        exam.identifier = examID;
    }
    exam.what = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    exam.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    exam.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    exam.begin_time = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    exam.end_time = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    
    exam.hours = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"Hours"]] intValue]];
    exam.point = [NSNumber numberWithFloat: [[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]];
    exam.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];

    return exam;
}

+ (Exam *)examWithID:(NSString *)examID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", examID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    return [matches lastObject];
}

+ (void)clearAllExams {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context]];
    NSArray *allCourses = [context executeFetchRequest:request error:NULL];
    
    for(Exam *exam in allCourses) {
        [context deleteObject:exam];
    }
}

@end
