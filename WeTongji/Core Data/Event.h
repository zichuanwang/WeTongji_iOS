//
//  Event.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@interface Event : Object

@property (nonatomic, retain) NSDate * begin_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * what;
@property (nonatomic, retain) NSString * where;

@end
