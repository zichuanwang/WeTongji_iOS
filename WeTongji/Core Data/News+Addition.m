//
//  News+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+Addition.h"

@implementation News (Addition)

+ (News *)insertNews:(NSDictionary *)dict {
    NSString *newsID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!newsID || [newsID isEqualToString:@""]) {
        return nil;
    }
    
    News *result = [News newsWithID:newsID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    }
    
    result.identifier = newsID;
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Context"]];
    result.summary = [NSString stringWithFormat:@"%@", dict[@"Summary"]];
    result.publish_date = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    
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

- (void)awakeFromFetch {
    [super awakeFromFetch];
    self.publish_day = [NSString yearMonthDayConvertFromDate:self.publish_date];
}

@end