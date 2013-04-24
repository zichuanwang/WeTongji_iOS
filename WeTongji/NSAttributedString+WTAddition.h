//
//  NSAttributedString+WTAddition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (WTAddition)

+ (NSAttributedString *)friendCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                           font:(UIFont *)font
                                                      textColor:(UIColor *)color;

+ (NSAttributedString *)commentCountStringConvertFromCountNumber:(NSNumber *)countNumber
                                                            font:(UIFont *)font
                                                       textColor:(UIColor *)color;

@end