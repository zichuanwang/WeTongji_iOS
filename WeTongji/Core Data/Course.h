//
//  Course.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@interface Course : Object

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * weekType;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSNumber * sectionStart;
@property (nonatomic, retain) NSNumber * sectionEnd;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSString * location;

@end
