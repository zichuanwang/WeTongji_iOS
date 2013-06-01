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
    NewsOrderMethod method = [self integerForKey:kNewsOrderMethod];
    return method;
}

- (void)setNewsOrderMethod:(NewsOrderMethod)method {
    [self setInteger:method forKey:kNewsOrderMethod];
    [self synchronize];
}

- (BOOL)getNewsSmartOrderProperty {
    return [self boolForKey:kNewsSmartOrder];

}

- (NewsShowTypes)getNewsShowTypes {
    NewsShowTypes types = [self integerForKey:kNewsShowTypes];
    return types;
}

- (void)setNewsShowTypes:(NewsShowTypes)types {
    [self setInteger:types forKey:kNewsShowTypes];
    [self synchronize];
}

- (void)addNewsShowTypes:(NewsShowTypes)type {
    NewsShowTypes types = [self getNewsShowTypes];
    types |= type;
    NSLog(@"add %d, result %d", type, types);
    [self setNewsShowTypes:types];
}

- (void)removeNewsShowTypes:(NewsShowTypes)type {
    NewsShowTypes types = [self getNewsShowTypes];
    types &= ~type;
    NSLog(@"remove %d, result %d", type, types);
    [self setNewsShowTypes:types];
}

- (void)setNewsSmartOrderProperty:(BOOL)on {
    [self setBool:on forKey:kNewsSmartOrder];
    [self synchronize];
}

+ (NSArray *)getNewsShowTypesArray {
    NSMutableArray *result = [NSMutableArray array];
    NewsShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getNewsShowTypes];
    for (int i = 0; i < NewsShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        NSNumber *show = @((showTypes & showType) != 0);
        [result addObject:show];
    }
    return result;
}

+ (NSSet *)getNewsShowTypesSet {
    NSMutableSet *result = [NSMutableSet set];
    NewsShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getNewsShowTypes];
    for (int i = 0; i < NewsShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        if ((showTypes & showType) != 0) {
            [result addObject:@(showType)];
        }
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
    
    if ([self getNewsOrderMethod] != NewsDefaultOrderMethod)
        return YES;
    
    if ([self getNewsShowTypes] != NewsDefaultShowTypes)
        return YES;
    
    if ([self getNewsSmartOrderProperty] != NewsDefaultSmartOrder)
        return YES;
    
    return NO;
}

#pragma mark - Activity

- (BOOL)isActivitySettingDifferentFromDefaultValue {
    
    if ([self getActivityOrderMethod] != ActivityDefaultOrderMethod)
        return YES;
    
    if ([self getActivityShowTypes] != ActivityDefaultShowTypes)
        return YES;
    
    if ([self getActivitySmartOrderProperty] != ActivityDefaultSmartOrder)
        return YES;
    
    if ([self getActivityHidePastProperty] != ActivityDefaultHidePast)
        return YES;
    
    return NO;
}

- (void)setActivityOrderMethod:(ActivityOrderMethod)method {
    [self setInteger:method forKey:kActivityOrderMethod];
    [self synchronize];
}

- (void)setActivityShowTypes:(ActivityShowTypes)types {
    [self setInteger:types forKey:kActivityShowTypes];
    [self synchronize];
}

- (void)setActivitySmartOrderProperty:(BOOL)on {
    [self setBool:on forKey:kActivitySmartOrder];
    [self synchronize];
}

- (void)setActivityHidePastProperty:(BOOL)on {
    [self setBool:on forKey:kActivityHidePast];
    [self synchronize];
}

- (ActivityShowTypes)getActivityShowTypes {
    return [self integerForKey:kActivityShowTypes];
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

+ (NSSet *)getActivityShowTypesSet {
    NSMutableSet *result = [NSMutableSet set];
    ActivityShowTypes showTypes = [[NSUserDefaults standardUserDefaults] getActivityShowTypes];
    for (int i = 0; i < ActivityShowTypesCount; i++) {
        NSInteger showType = 1 << i;
        if ((showTypes & showType) != 0) {
            [result addObject:@(showType)];
        }
    }
    return result;
}

- (ActivityOrderMethod)getActivityOrderMethod {
    return [self integerForKey:kActivityOrderMethod];
}

- (BOOL)getActivityHidePastProperty {
    return [self boolForKey:kActivityHidePast];
}

- (BOOL)getActivitySmartOrderProperty {
    return [self boolForKey:kActivitySmartOrder];
}

#pragma mark - Search history

#define kSearchHistoryArray     @"SearchHistoryArray"
#define kSearchHistoryKeyword   @"SearchHistoryKeyword"
#define kSearchHistoryCateogory @"SearchHistoryCateogory"

#define SEARCH_HISTORY_ARRAY_MAX_CAPACITY   10

+ (NSString *)getSearchHistoryKeyword:(NSDictionary *)dict {
    return [dict objectForKey:kSearchHistoryKeyword];
}

+ (NSInteger)getSearchHistoryCategory:(NSDictionary *)dict {
    NSNumber *categoryNumber = [dict objectForKey:kSearchHistoryCateogory];
    return categoryNumber.integerValue;
}

- (void)addSearchHistoryItemWithSearchKeyword:(NSString *)keyword
                               searchCategory:(NSInteger)category {
    
    NSDictionary *item = @{kSearchHistoryKeyword : keyword, kSearchHistoryCateogory : @(category)};
    
    NSMutableArray *searchHistoryArray = [NSMutableArray arrayWithArray:[self getSearchHistoryArray]];
    if (searchHistoryArray.count >= SEARCH_HISTORY_ARRAY_MAX_CAPACITY) {
        [searchHistoryArray removeLastObject];
    }
    [searchHistoryArray insertObject:item atIndex:0];
    [self setObject:searchHistoryArray forKey:kSearchHistoryArray];
    [self synchronize];
}

- (void)clearAllSearchHistoryItems {
    [self setObject:nil forKey:kSearchHistoryArray];
    [self synchronize];
}

- (NSArray *)getSearchHistoryArray {
    return [self arrayForKey:kSearchHistoryArray];
}

#pragma mark - Current user info

#define kCurrentUserMotto       @"CurrentUserMotto"
#define kCurrentUserPhone       @"CurrentUserPhone"
#define kCurrentUserEmail       @"CurrentUserEmail"
#define kCurrentUserSinaWeibo   @"CurrentUserSinaWeibo"
#define kCurrentUserQQ          @"CurrentUserQQ"

- (void)setCurrentUserMotto:(NSString *)motto {
    [self setObject:motto forKey:kCurrentUserMotto];
    [self synchronize];
}

- (void)setCurrentUserPhone:(NSString *)phone {
    [self setObject:phone forKey:kCurrentUserPhone];
    [self synchronize];
}

- (void)setCurrentUserEmail:(NSString *)email {
    [self setObject:email forKey:kCurrentUserEmail];
    [self synchronize];
}

- (void)setCurrentUserSinaWeibo:(NSString *)sinaWeibo {
    [self setObject:sinaWeibo forKey:kCurrentUserSinaWeibo];
    [self synchronize];
}

- (void)setCurrentUserQQ:(NSString *)QQ {
    [self setObject:QQ forKey:kCurrentUserQQ];
    [self synchronize];
}

- (NSString *)getCurrentUserMotto {
    return [self stringForKey:kCurrentUserMotto];
}

- (NSString *)getCurrentUserPhone {
    return [self stringForKey:kCurrentUserPhone];
}

- (NSString *)getCurrentUserEmail {
    return [self stringForKey:kCurrentUserEmail];
}

- (NSString *)getCurrentUserSinaWeibo {
    return [self stringForKey:kCurrentUserSinaWeibo];
}

- (NSString *)getCurrentUserQQ {
    return [self stringForKey:kCurrentUserQQ];
}

@end
