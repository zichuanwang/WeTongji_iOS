//
//  Event+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Event.h"

@interface Event (Addition)

@property (nonatomic, readonly) NSString *yearMonthDayBeginToEndTimeString;
@property (nonatomic, readonly) NSString *beginToEndTimeString;

+ (NSArray *)getTodayEvents;

+ (void)clearCurrentUserScheduledEventsFrom:(NSDate *)beginDate
                                         to:(NSDate *)endDate;

@end
