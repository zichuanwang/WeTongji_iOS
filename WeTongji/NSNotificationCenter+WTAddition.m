//
//  NSNotificationCenter+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSNotificationCenter+WTAddition.h"

#define kWTInnerSettingItemDidModify    @"WTInnerSettingItemDidModify"
#define kWTCurrentUserDidChange         @"WTCurrentUserDidChange"

@implementation NSNotificationCenter (WTAddition)

+ (void)postInnerSettingItemDidModifyNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTInnerSettingItemDidModify object:nil userInfo:nil];
}

+ (void)registerInnerSettingItemDidModifyNotificationWithSelector:(SEL)aSelector
                                                           target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTInnerSettingItemDidModify
                 object:nil];
}

+ (void)postCurrentUserDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTCurrentUserDidChange object:nil userInfo:nil];
}

+ (void)registerCurrentUserDidChangeNotificationWithSelector:(SEL)aSelector
                                                      target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTCurrentUserDidChange
                 object:nil];
}

@end
