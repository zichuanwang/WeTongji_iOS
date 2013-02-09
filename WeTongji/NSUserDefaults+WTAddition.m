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

@implementation NSUserDefaults (WTAddition)

+ (void)initialize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kNewsShowTypes] == nil) {
        [userDefaults setNewsShowTypes:NewsShowTypesAll];
    }
    if ([userDefaults objectForKey:kNewsOrderMethod] == nil) {
        [userDefaults setNewsOrderMethod:NewsOrderByPublishDate];
    }
    [userDefaults synchronize];
}

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

@end
