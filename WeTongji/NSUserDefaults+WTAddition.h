//
//  NSUserDefaults+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NewsOrderByPublishDate  = 1 << 0,
    NewsOrderByPopularity   = 1 << 1,
} NewsOrderMethod;

typedef enum {
    NewsShowTypeCampusUpdate        = 1 << 0,
    NewsShowTypeCollegeNotification = 1 << 1,
    NewsShowTypeAssociationNews     = 1 << 2,
    NewsShowTypeLocalRecommandation = 1 << 3,
} NewsShowTypes;

#define NewsShowTypesAll (NewsShowTypeCampusUpdate + NewsShowTypeCollegeNotification + NewsShowTypeAssociationNews + NewsShowTypeLocalRecommandation)

@interface NSUserDefaults (WTAddition)

- (NewsOrderMethod)getNewsOrderMethod;
- (void)setNewsOrderMethod:(NewsOrderMethod)method;

// 返回一个数组, 数组中的元素按 NewsShowType 排列, 类型均为包含一个BOOL类型数据的NSNumber
// - (NSArray *)getNewsShowTypes;

- (void)addNewsShowTypes:(NewsShowTypes)type;
- (void)removeNewsShowTypes:(NewsShowTypes)type;

@end
