//
//  Course+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"
#import "Event+Addition.h"

@interface Course (Addition)

+ (Course *)insertCourse:(NSDictionary *)dict;

+ (Course *)courseScheduleAtDay:(NSDate *)date
                   withCourseID:(NSString *)courseID;

@end
