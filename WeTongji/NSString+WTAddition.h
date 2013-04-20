//
//  NSString+WTAddition.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-26.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//



@interface NSString (WTAddition)

- (NSDate *)convertToDate;
+ (NSString *)yearMonthDayConvertFromDate:(NSDate *)date;
+ (NSString *)yearMonthDayWeekConvertFromDate:(NSDate *)date;
+ (NSString *)yearMonthDayWeekTimeConvertFromDate:(NSDate *)date;
+ (NSString *)weekConvertFromDate:(NSDate *)date;
+ (NSString *)yearMonthDayTimeConvertFromDate:(NSDate *)date;
+ (NSString *)yearMonthDayWeekTimeConvertFromBeginDate:(NSDate *)begin
                                               endDate:(NSDate *)end;

+ (NSString *)timeConvertFromDate:(NSDate *)date;
+ (NSString *)timeConvertFromBeginDate:(NSDate *)begin endDate:(NSDate *)end;
+ (NSString *)weekDayConvertFromInteger:(NSInteger)weekday;

- (BOOL)isSuitableForPassword;
+ (NSString *)getTodayBeginDayFormatString;
+ (NSString *)getTomorrowBeginDayFormatString;
- (BOOL)isGIFURL;
- (BOOL)isEmptyImageURL;
- (NSString *)clearAllBacklashR;
+ (NSString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber;

@end
