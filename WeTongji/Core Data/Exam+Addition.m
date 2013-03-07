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
    exam.begin = [[NSString stringWithFormat:@"%@",dic[@"Begin"]] convertToDate];
    exam.beginTime = exam.begin;
    exam.end = [[NSString stringWithFormat:@"%@",dic[@"End"]] convertToDate];
    exam.point = dic[@"Point"];
    exam.required = dic[@"Required"];
    exam.hours = dic[@"Hours"];

    return exam;
}

+ (Exam *)examWithNo:(NSString *)examNO
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",examNO];
    request.sortDescriptors = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES]];
    
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    return [matches lastObject];
}

@end
