//
//  Star+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Star+Addition.h"
#import "WTCoreDataManager.h"
#import "Object+Addtion.h"
#import "NSString+WTAddition.h"

@implementation Star (Addition)

+ (Star *)insertStar:(NSDictionary *)dict {
    NSString *starID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!starID || [starID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    Star *result = [Star starWithID:starID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = starID;
        result.objectClass = NSStringFromClass([Star class]);
    }
    
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Avatar"]];
    result.canLike = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CanLike"]]).boolValue);
    result.content = [NSString stringWithFormat:@"%@", dict[@"Description"]];
    
    NSArray *imageArray = dict[@"Images"];
    if (imageArray.count == 0) {
        result.imageArray = nil;
    } else {
        result.imageArray = imageArray;
    }

    result.jobTitle = [NSString stringWithFormat:@"%@", dict[@"JobTitle"]];
    result.likeCount = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"Like"]]).integerValue);
    result.studentNumber = [NSString stringWithFormat:@"%@", dict[@"StudentNO"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.motto = [NSString stringWithFormat:@"%@", dict[@"Words"]];
    result.starNumber = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"CreatedAt"]] convertToDate];
    NSLog(@"create at:%@", result.createdAt);
    
    return result;
}

+ (Star *)starWithID:(NSString *)starID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", starID]];
    
    Star *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
