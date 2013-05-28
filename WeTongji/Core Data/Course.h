//
//  Course.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Course : Event

@property (nonatomic, retain) NSDate * courseDay;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSNumber * sectionEnd;
@property (nonatomic, retain) NSNumber * sectionStart;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * weekType;

@end
