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

@implementation Star (Addition)

+ (Star *)insertStar:(NSDictionary *)dict {
    NSString *starID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!starID || [starID isEqualToString:@""]) {
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
    
    return result;
}

+ (Star *)starWithID:(NSString *)starID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", starID]];
    
    Star *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)setAllStarsFreeFromHolder:(id)holder {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:context]];
    NSArray *allStars = [context executeFetchRequest:request error:NULL];
    
    for(Star *item in allStars) {
        [item setObjectFreeFromHolder:holder];
    }
}

@end
