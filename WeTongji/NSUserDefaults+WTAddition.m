//
//  NSUserDefaults+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSUserDefaults+WTAddition.h"

#define kNewsOrderMethod        @"NewsOrderMethod"
#define kNewsShowTypes          @"NewsShowTypes"
#define kNewsSmartOrder         @"NewsSmartOrder"

#define kActivityOrderMethod    @"ActivityOrderMethod"
#define kActivityShowTypes      @"ActivityShowTypes"
#define kActivitySmartOrder     @"ActivitySmartOrder"
#define kActivityHidePast       @"ActivityHidePast"

@implementation NSUserDefaults (WTAddition)

+ (void)initialize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kNewsShowTypes] == nil) {
        [userDefaults setNewsShowTypes:NewsShowTypesAll];
    }
    if ([userDefaults objectForKey:kNewsOrderMethod] == nil) {
        [userDefaults setNewsOrderMethod:NewsOrderByPublishDate];
    }
    if ([userDefaults objectForKey:kNewsSmartOrder] == nil) {
        [userDefaults setNewsSmartOrderProperty:YES];
    }
    if ([userDefaults objectForKey:kActivityOrderMethod] == nil) {
        [userDefaults setActivityOrderMethod:ActivityOrderByPublishDate];
    }
    if ([userDefaults objectForKey:kActivityShowTypes] == nil) {
        [userDefaults setActivityShowTypes:ActivityShowTypesAll];
    }
    if ([userDefaults objectForKey:kActivitySmartOrder] == nil) {
        [userDefaults setActivitySmartOrderProperty:YES];
    }
    if ([userDefaults objectForKey:kActivityHidePast] == nil) {
        [userDefaults setActivityHidePastProperty:YES];
    }
    
    [userDefaults synchronize];
}

#pragma mark - News

- (NewsOrderMethod)getNewsOrderMethod {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NewsOrderMethod method = [userDefaults integerForKey:kNewsOrderMethod];
    return method;
}

- (void)setNewsOrderMethod:(NewsOrderMethod)method {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:method forKey:kNewsOrderMethod];
    [userDefaults synchronize];
}

- (NewsShowTypes)getNewsShowTypes {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NewsShowTypes types = [userDefaults integerForKey:kNewsShowTypes];
    return types;
}

- (void)setNewsShowTypes:(NewsShowTypes)types {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:types forKey:kNewsShowTypes];
    [userDefaults synchronize];
}

- (void)addNewsShowTypes:(NewsShowTypes)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NewsShowTypes types = [userDefaults getNewsShowTypes];
    types |= type;
    NSLog(@"add %d, result %d", type, types);
    [userDefaults setNewsShowTypes:types];
}

- (void)removeNewsShowTypes:(NewsShowTypes)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NewsShowTypes types = [userDefaults getNewsShowTypes];
    types &= ~type;
    NSLog(@"remove %d, result %d", type, types);
    [userDefaults setNewsShowTypes:types];
}

- (void)setNewsSmartOrderProperty:(BOOL)on {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:kNewsSmartOrder];
    [userDefaults synchronize];
}

#pragma mark - Activity

- (void)setActivityOrderMethod:(ActivityOrderMethod)method {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:method forKey:kActivityOrderMethod];
    [userDefaults synchronize];
}

- (void)setActivityShowTypes:(NewsShowTypes)types {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:types forKey:kActivityShowTypes];
    [userDefaults synchronize];
}

- (void)setActivitySmartOrderProperty:(BOOL)on {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:kActivitySmartOrder];
    [userDefaults synchronize];
}

- (void)setActivityHidePastProperty:(BOOL)on {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:kActivityHidePast];
    [userDefaults synchronize];
}

- (ActivityShowTypes)getActivityShowTypes {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kActivityShowTypes];
}

- (NSArray *)getActivityShowTypesArray {
    NSMutableArray *result = [NSMutableArray array];
    ActivityShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getActivityShowTypes];
    for (int i = 0; i < ActivityShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @((showTypes & showType) != 0);
        [result addObject:show];
    }
    return result;
}

- (ActivityOrderMethod)getActivityOrderMethod {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kActivityOrderMethod];
}

- (BOOL)getActivityHidePastProperty {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kActivityHidePast];
}

- (BOOL)getActivitySmartOrderProperty {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kActivitySmartOrder];
}

@end
