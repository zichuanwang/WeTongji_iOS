//
//  NSString+WTAddition.m
//  WeTongji
//
//  Created by 紫川 王 on 12-4-26.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+WTAddition.h"

@implementation NSString (WTAddition)


- (NSDate *)convertToDate {
    NSString *src = self;
    if([src characterAtIndex:src.length - 3] == ':') {
        src = [src stringByReplacingCharactersInRange:NSMakeRange(src.length - 3, 1) withString:@""];
    }
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
    
    NSDate *date = [form dateFromString:src];
    return date;
}

+ (NSString *)yearMonthDayConvertFromDate:(NSDate *)date {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"]) {
        [form setDateFormat:@"M-d-yyyy"];
    } else if ([language isEqualToString:@"zh-Hans"]) {
        [form setDateFormat:@"yyyy-M-d"];
    } else {
        [form setDateFormat:@"yyyy-M-d"];
    }
    
    NSString *result = [form stringFromDate:date];
    return result;
}

+ (NSString *)weekDayConvertFromInteger:(NSInteger)weekday {
    NSString *weekdayStr = nil;
    switch (weekday) {
        case 1:
            weekdayStr = NSLocalizedString(@"Sun", nil);
            break;
        case 2:
            weekdayStr = NSLocalizedString(@"Mon", nil);;
            break;
        case 3:
            weekdayStr = NSLocalizedString(@"Tue", nil);
            break;
        case 4:
            weekdayStr = NSLocalizedString(@"Wed", nil);
            break;
        case 5:
            weekdayStr = NSLocalizedString(@"Thu", nil);
            break;
        case 6:
            weekdayStr = NSLocalizedString(@"Fri", nil);
            break;
        case 7:
            weekdayStr = NSLocalizedString(@"Sat", nil);
            break;
            
        default:
            break;
    }
    return weekdayStr;
}

+ (NSString *)weekConvertFromDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int weekday = [comps weekday];
    
    return [NSString weekDayConvertFromInteger:weekday];
}

+ (NSString *)yearMonthDayWeekConvertFromDate:(NSDate *)date {
    NSString *result = [NSString yearMonthDayConvertFromDate:date];
    result = [NSString stringWithFormat:@"%@ %@", result, [NSString weekConvertFromDate:date]];
    return result;
}

+ (NSString *)yearMonthDayTimeConvertFromDate:(NSDate *)date {
    NSString *result = [NSString yearMonthDayConvertFromDate:date];
    result = [NSString stringWithFormat:@"%@ %@", result, [NSString timeConvertFromDate:date]];
    return result;
}

+ (NSString *)yearMonthDayWeekTimeConvertFromDate:(NSDate *)date {
    NSString *result = [NSString yearMonthDayWeekConvertFromDate:date];
    result = [NSString stringWithFormat:@"%@ %@", result, [NSString timeConvertFromDate:date]];
    return result;
}

+ (NSString *)timeConvertFromDate:(NSDate *)date {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"HH:mm"];
    NSString *result = [form stringFromDate:date];
    return result;
}

+ (NSString *)timeConvertFromBeginDate:(NSDate *)begin endDate:(NSDate *)end {
    NSString *timeStr = [NSString timeConvertFromDate:begin];
    timeStr = [NSString stringWithFormat:@"%@ - %@", timeStr, [NSString timeConvertFromDate:end]];
    return timeStr;
}

+ (NSString *)yearMonthDayWeekTimeConvertFromBeginDate:(NSDate *)begin
                                               endDate:(NSDate *)end {
    NSString *timeStr = [NSString yearMonthDayWeekTimeConvertFromDate:begin];
    timeStr = [NSString stringWithFormat:@"%@ - %@", timeStr, [NSString timeConvertFromDate:end]];
    return timeStr;
}

- (BOOL)isSuitableForPassword {
    BOOL result = YES;
    NSString *password = self;
    for(int i = 0; i < password.length; i++) {
        unichar c = [password characterAtIndex:i];
        if(isalnum(c) == 0 && c != '_') {
            result = NO;
            break;
        }
    }
    return result;
}

+ (NSString *)getTodayBeginDayFormatString {
    return [NSString yearMonthDayWeekConvertFromDate:[NSDate date]];
}

+ (NSString *)getTomorrowBeginDayFormatString {
    return [NSString yearMonthDayWeekConvertFromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24]];
}

- (BOOL)isGIFURL {
    BOOL result = NO;
    NSString* extName = [self substringFromIndex:([self length] - 3)];
    if ([extName compare:@"gif"] == NSOrderedSame)
        result =  YES;
    return result;
}

- (BOOL)isEmptyImageURL {
    if (self.length < 11)
        return true;
    return [[self substringWithRange:NSMakeRange(self.length - 11, 11)] isEqualToString:@"missing.png"];
}

- (NSString *)clearAllBacklashR {
    NSMutableString *mutableSelf = [NSMutableString stringWithString:self];
    [mutableSelf replaceOccurrencesOfString:@"\r" withString:@"" options:0 range:NSMakeRange(0, mutableSelf.length)];
    return mutableSelf;
}

+ (NSString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber {
    NSString *friendString = countNumber.integerValue > 1 ? @"Friends" : @"Friend";
    NSString *resultString = [NSString stringWithFormat:@"%d %@", countNumber.integerValue, NSLocalizedString(friendString, nil)];
    return resultString;
}

+ (NSString *)commentCountStringConvertFromCountNumber:(NSNumber *)countNumber {
    NSString *friendString = countNumber.integerValue > 1 ? @"Comments" : @"Comment";
    NSString *resultString = [NSString stringWithFormat:@"%d %@", countNumber.integerValue, NSLocalizedString(friendString, nil)];
    return resultString;
}

+ (NSString *)searchCategoryStringForCategory:(NSInteger)category {
    NSString *result = nil;
    switch (category) {
        case 0:
        {
            result = NSLocalizedString(@"all", nil);
        }
            break;
        case 1:
        {
            result = NSLocalizedString(@"users", nil);
        }
            break;
        case 2:
        {
            result = NSLocalizedString(@"organizations", nil);
        }
            break;
        case 3:
        {
            result = NSLocalizedString(@"activities", nil);
        }
            break;
        case 4:
        {
            result = NSLocalizedString(@"news", nil);
        }
            break;
        case 5:
        {
            result = NSLocalizedString(@"stars", nil);
        }
            break;
        default:
            break;
    }
    return result;
}

- (UIColor *)converHexStringToColorWithAlpha:(CGFloat)alpha {
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    // 例子, stringToConvert #ffffff
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return DEFAULT_VOID_COLOR;
    // 分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:alpha];
}

@end
