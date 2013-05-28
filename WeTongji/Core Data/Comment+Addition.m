//
//  Comment+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-28.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Comment+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"

@implementation Comment (Addition)

+ (Comment *)createTestComment {
    NSString *commentID = @"test";
    Comment *result = [Comment commmentWithID:commentID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = commentID;
    }
    return result;
}

+ (Comment *)insertComment:(NSDictionary *)dict {
    NSString *commentID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!commentID || [commentID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    Comment *result = [Comment commmentWithID:commentID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = commentID;
    }
    
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"PublishedAt"]] convertToDate];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Body"]];
    
    return result;
}

+ (Comment *)commmentWithID:(NSString *)commentID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", commentID]];
    
    Comment *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
