//
//  Course+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"

@interface Course (Addition)

@property (nonatomic, readonly) NSString *courseBeginToEndTime;

+ (Course *)insertCourse:(NSDictionary *)dic;
+ (Course *)courseScheduleAtDay:(NSDate *)date withCourseID:(NSString *)courseID;

+ (void)clearAllCourses;
@end
