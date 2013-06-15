//
//  Course+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"
#import "CourseInfo.h"
#import "CourseTimetable.h"
#import "Event+Addition.h"

@interface Course (Addition)

+ (Course *)insertCourse:(NSDictionary *)dict;

+ (Course *)courseWithCourseID:(NSString *)courseID
                     beginTime:(NSDate *)beginTime;

@end

@interface CourseInfo (Addition)

+ (CourseInfo *)insertCourseInfo:(NSDictionary *)dict;

+ (CourseInfo *)courseInfoWithCourseID:(NSString *)courseID;

@end

@interface CourseTimetable (Addition)

+ (CourseTimetable *)insertCourseTimetable:(NSDictionary *)dict;

@end
