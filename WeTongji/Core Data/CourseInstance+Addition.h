//
//  CourseInstance+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "CourseInstance.h"

@interface CourseInstance (Addition)

@property (nonatomic, readonly) NSString *courseBeginToEndTime;

+ (CourseInstance *)insertCourseInstance:(NSDictionary *)dic;
+ (CourseInstance *)courseInstanceAtDay:(NSDate *)date;
@end
