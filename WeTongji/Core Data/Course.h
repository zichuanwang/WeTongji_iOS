//
//  Course.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class CourseInfo;

@interface Course : Event

@property (nonatomic, retain) NSNumber * isAudit;
@property (nonatomic, retain) CourseInfo *info;

@end
