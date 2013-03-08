//
//  Exam.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@interface Exam : Event

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * begin;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSNumber * hours;

@end
