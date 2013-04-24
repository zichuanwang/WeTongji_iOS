//
//  NSAttributedString+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSAttributedString+WTAddition.h"
#import "NSAttributedString+Attributes.h"

@implementation NSAttributedString (WTAddition)

+ (NSAttributedString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                           font:(UIFont *)font
                                                      textColor:(UIColor *)color {
    NSString *friendString = countNumber.integerValue > 1 ? @"Friends" : @"Friend";
    NSString *countString = [NSString stringWithFormat:@"%d", countNumber.integerValue];
    NSString *resultString = [NSString stringWithFormat:@"%@ %@", countString, NSLocalizedString(friendString, nil)];
    
    NSMutableAttributedString *resultAttribuedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [resultAttribuedString setTextAlignment:kCTTextAlignmentRight lineBreakMode:kCTLineBreakByCharWrapping];
    [resultAttribuedString setTextColor:color];
    [resultAttribuedString setFont:font];
    [resultAttribuedString setTextBold:YES range:NSMakeRange(0, countString.length)];
    
    return resultAttribuedString;
}

+ (NSAttributedString *)commentCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                            font:(UIFont *)font
                                                       textColor:(UIColor *)color {
    NSString *friendString = countNumber.integerValue > 1 ? @"Comments" : @"Comment";
    NSString *countString = [NSString stringWithFormat:@"%d", countNumber.integerValue];
    NSString *resultString = [NSString stringWithFormat:@"%@ %@", countString, NSLocalizedString(friendString, nil)];
    
    NSMutableAttributedString *resultAttribuedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [resultAttribuedString setTextBold:YES range:NSMakeRange(0, countString.length)];
    [resultAttribuedString setTextColor:color];
    [resultAttribuedString setFont:font];
    
    return resultAttribuedString;
}

@end
