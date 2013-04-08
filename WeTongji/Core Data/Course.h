//
//  Course.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Course : Event

@property (nonatomic, retain) NSDate * course_day;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSNumber * section_end;
@property (nonatomic, retain) NSNumber * section_start;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * week_day;
@property (nonatomic, retain) NSString * week_type;

@end
