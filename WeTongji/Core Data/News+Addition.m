//
//  News+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News+Addition.h"

@implementation News (Addition)

+ (News *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *newsID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!newsID || [newsID isEqualToString:@""]) {
        return nil;
    }
    
    News *result = [News newsWithID:newsID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context];
    }
    
    result.identifier = newsID;
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Context"]];
    
    return result;
}

+ (News *)newsWithID:(NSString *)newsID inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", newsID]];
    
    News *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
