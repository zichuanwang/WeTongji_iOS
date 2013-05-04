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

#define ActivityDefaultOrderMethod  ActivityOrderByPublishDate
#define ActivityDefaultShowTypes    ActivityShowTypesAll
#define ActivityDefaultSmartOrder   YES
#define ActivityDefaultHidePast     YES

#define NewsDefaultOrderMethod      NewsOrderByPublishDate
#define NewsDefaultShowTypes        NewsShowTypesAll
#define NewsDefaultSmartOrder       YES

@implementation NSUserDefaults (WTAddition)

+ (void)initialize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kNewsShowTypes] == nil) {
        [userDefaults setNewsShowTypes:NewsDefaultShowTypes];
    }
    if ([userDefaults objectForKey:kNewsOrderMethod] == nil) {
        [userDefaults setNewsOrderMethod:NewsDefaultOrderMethod];
    }
    if ([userDefaults objectForKey:kNewsSmartOrder] == nil) {
        [userDefaults setNewsSmartOrderProperty:NewsDefaultSmartOrder];
    }
    if ([userDefaults objectForKey:kActivityOrderMethod] == nil) {
        [userDefaults setActivityOrderMethod:ActivityDefaultOrderMethod];
    }
    if ([userDefaults objectForKey:kActivityShowTypes] == nil) {
        [userDefaults setActivityShowTypes:ActivityDefaultShowTypes];
    }
    if ([userDefaults objectForKey:kActivitySmartOrder] == nil) {
        [userDefaults setActivitySmartOrderProperty:ActivityDefaultSmartOrder];
    }
    if ([userDefaults objectForKey:kActivityHidePast] == nil) {
        [userDefaults setActivityHidePastProperty:ActivityDefaultHidePast];
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

- (BOOL)getNewsSmartOrderProperty {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kNewsSmartOrder];

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

+ (NSArray *)getNewsShowTypesArray {
    NSMutableArray *result = [NSMutableArray array];
    ActivityShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getNewsShowTypes];
    for (int i = 0; i < NewsShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @((showTypes & showType) != 0);
        [result addObject:show];
    }
    return result;
}

+ (NSArray *)getNewsShowTypesArrayWithNewsShowType:(NewsShowTypes)type {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < NewsShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @(type == showType);
        [result addObject:show];
    }
    return result;
}

- (BOOL)isNewsSettingDifferentFromDefaultValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults getNewsOrderMethod] != NewsDefaultOrderMethod)
        return YES;
    
    if ([userDefaults getNewsShowTypes] != NewsDefaultShowTypes)
        return YES;
    
    if ([userDefaults getNewsSmartOrderProperty] != NewsDefaultSmartOrder)
        return YES;
    
    return NO;
}

#pragma mark - Activity

- (BOOL)isActivitySettingDifferentFromDefaultValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults getActivityOrderMethod] != ActivityDefaultOrderMethod)
        return YES;
    
    if ([userDefaults getActivityShowTypes] != ActivityDefaultShowTypes)
        return YES;
    
    if ([userDefaults getActivitySmartOrderProperty] != ActivityDefaultSmartOrder)
        return YES;
    
    if ([userDefaults getActivityHidePastProperty] != ActivityDefaultHidePast)
        return YES;
    
    return NO;
}

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

+ (NSArray *)getActivityShowTypesArray {
    NSMutableArray *result = [NSMutableArray array];
    ActivityShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getActivityShowTypes];
    for (int i = 0; i < ActivityShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @((showTypes & showType) != 0);
        [result addObject:show];
    }
    return result;
}

+ (NSArray *)getActivityShowTypesArrayWithActivityShowType:(ActivityShowTypes)type {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < ActivityShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @(type == showType);
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
