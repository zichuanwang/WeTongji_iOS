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
    
    Exam *result = [Exam examWithID:examID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Exam"
                                             inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = examID;
        result.objectClass = NSStringFromClass([Exam class]);
    }
    result.what = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.beginTime = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    
    result.hours = [NSNumber numberWithInt: [[NSString stringWithFormat:@"%@", dict[@"Hours"]] intValue]];
    result.point = [NSNumber numberWithFloat: [[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]];
    result.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];
    
    result.beginDay = [NSString yearMonthDayConvertFromDate:result.beginTime];

    return result;
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
