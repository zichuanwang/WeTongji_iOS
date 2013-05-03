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

+ (NSArray *)getHomeSelectNewsArray {
    NSMutableArray *result = [NSMutableArray array];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:NO]];
    NSArray *allNews = [context executeFetchRequest:request error:NULL];
    
    result = [NSArray arrayWithArray:[allNews subarrayWithRange:NSMakeRange(0, MIN(4, allNews.count))]];
    
    return result;
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
    
    result.updateTime = [NSDate date];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.content = [[NSString stringWithFormat:@"%@", dict[@"Context"]] clearAllBacklashR];
    result.summary = [NSString stringWithFormat:@"%@", dict[@"Summary"]];
    result.publishDate = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    result.canLike = @([[NSString stringWithFormat:@"%@", dict[@"CanLike"]] boolValue]);
    result.likeCount = @([[NSString stringWithFormat:@"%@", dict[@"Like"]] integerValue]);
    result.readCount = @([[NSString stringWithFormat:@"%@", dict[@"Read"]] integerValue]);
    result.organizer = [NSString stringWithFormat:@"%@", dict[@"Organizer"]];
    result.organizerAvatar = [NSString stringWithFormat:@"%@", dict[@"OrganizerAvatar"]];
    result.source = [NSString stringWithFormat:@"%@", dict[@"Source"]];
    
    NSArray *imageArray = dict[@"Images"];
    if (imageArray.count == 0)
        imageArray = nil;
    result.imageArray = imageArray;
    
    NSString *categoryString = [NSString stringWithFormat:@"%@", dict[@"Category"]];
    if ([categoryString isEqualToString:@"校园新闻"])
        result.category = @(NewsShowTypeCampusUpdate);
    else if ([categoryString isEqualToString:@"团体通告"])
        result.category = @(NewsShowTypeClubNews);
    else if ([categoryString isEqualToString:@"周边推荐"])
        result.category = @(NewsShowTypeLocalRecommandation);
    else if ([categoryString isEqualToString:@"校务信息"])
        result.category = @(NewsShowTypeAdministrativeAffairs);
    else {
        NSAssert(NO, @"Error");
    }
    
    result.publishDay = [NSString yearMonthDayConvertFromDate:result.publishDate];
    
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
    self.publishDay = [NSString yearMonthDayConvertFromDate:self.publishDate];
}

- (NSString *)yearMonthDayTimePublishTimeString {
    return [NSString yearMonthDayTimeConvertFromDate:self.publishDate];
}

- (NSString *)categoryString {
    switch (self.category.integerValue) {
        case NewsShowTypeCampusUpdate:
            return NSLocalizedString(@"Campus Update", nil);
        case NewsShowTypeClubNews:
            return NSLocalizedString(@"Club News", nil);
        case NewsShowTypeLocalRecommandation:
            return NSLocalizedString(@"Local Recommandation", nil);
        case NewsShowTypeAdministrativeAffairs:
            return NSLocalizedString(@"Administrative Affairs", nil);
        case NewsShowTypeMyCollege:
            return NSLocalizedString(@"My College", nil);
        default:
            break;
    }
    return nil;
}

@end
