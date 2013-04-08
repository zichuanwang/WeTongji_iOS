//
//  News+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"

@implementation News (Addition)

+ (NSArray *)createTestNewsArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSString *newsID = [NSString stringWithFormat:@"%d", i];
        News *result = [News newsWithID:newsID];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
            result.identifier = newsID;
        }
        switch (i) {
            case 0: {
                result.image_array = [NSArray arrayWithObject:@"http://pic11.nipic.com/20101129/1951702_194641008006_2.jpg"];
                result.title = @"测试新闻";
            }
                break;
            case 1: {
                result.title = @"测试新闻2";
            }
                break;
            case 2: {
                result.title = @"测试新闻3";
            }
                break;
                
            default:
                break;
        }
        [resultArray addObject:result];
    }
    return resultArray;
}

+ (News *)insertNews:(NSDictionary *)dict {
    NSString *newsID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!newsID || [newsID isEqualToString:@""]) {
        return nil;
    }
    
    News *result = [News newsWithID:newsID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = newsID;
    }
    
    result.update_time = [NSDate date];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Context"]];
    result.summary = [NSString stringWithFormat:@"%@", dict[@"Summary"]];
    result.publish_date = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    result.can_like = @([[NSString stringWithFormat:@"%@", dict[@"CanLike"]] boolValue]);
    result.like_count = @([[NSString stringWithFormat:@"%@", dict[@"Like"]] integerValue]);
    
    NSArray *imageArray = dict[@"Images"];
    result.image_array = imageArray;
    
    result.publish_day = [NSString yearMonthDayConvertFromDate:result.publish_date];
    
    return result;
}

+ (News *)newsWithID:(NSString *)newsID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", newsID]];
    
    News *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)clearAllNews {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:context]];
    NSArray *allNews = [context executeFetchRequest:request error:NULL];

    for(News *item in allNews) {
        [context deleteObject:item];
    }
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    self.publish_day = [NSString yearMonthDayConvertFromDate:self.publish_date];
}

@end
