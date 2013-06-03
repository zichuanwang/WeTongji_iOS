//
//  User+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "User+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"

@implementation User (Addition)

+ (User *)insertUser:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSString *userID = [NSString stringWithFormat:@"%@", dict[@"UID"]];
    
    if (!userID || [userID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    User *result = [User userWithID:userID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        
        result.identifier = userID;
        result.objectClass = NSStringFromClass([User class]);
    }
    
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Avatar"]];
    result.birthday = [[NSString stringWithFormat:@"%@", dict[@"Birthday"]] convertToDate];
    result.department = [NSString stringWithFormat:@"%@", dict[@"Department"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.gender = [NSString stringWithFormat:@"%@", dict[@"Gender"]];
    result.major = [NSString stringWithFormat:@"%@", dict[@"Major"]];
    result.studentNumber = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.studyPlan = @([[NSString stringWithFormat:@"%@", dict[@"Plan"]] integerValue]);
    result.enrollYear = @([[NSString stringWithFormat:@"%@", dict[@"Year"]] integerValue]);
    result.motto = [NSString stringWithFormat:@"%@", dict[@"Words"]];
    if ([result.motto isEqualToString:@"<null>"] || [result.motto isEqualToString:@"(null)"]) {
        result.motto = nil;
    }
    
    result.emailAddress = [NSString stringWithFormat:@"%@", dict[@"Email"]];
    if ([result.emailAddress isEqualToString:@"<null>"]) {
        result.emailAddress = nil;
    }
    
    result.phoneNumber = [NSString stringWithFormat:@"%@", dict[@"Phone"]];
    if ([result.phoneNumber isEqualToString:@"<null>"]) {
        result.phoneNumber = nil;
    }
    
    result.sinaWeiboName = [NSString stringWithFormat:@"%@", dict[@"SinaWeibo"]];
    result.sinaWeiboName = [NSString stringWithFormat:@"%@", dict[@"Phone"]];
    if ([result.sinaWeiboName isEqualToString:@"<null>"]) {
        result.sinaWeiboName = nil;
    }
    
    result.qqAccount = [NSString stringWithFormat:@"%@", dict[@"QQ"]];
    if ([result.qqAccount isEqualToString:@"<null>"]) {
        result.qqAccount = nil;
    }
    
    BOOL isCurrentUserFriend = [[NSString stringWithFormat:@"%@", dict[@"IsFriend"]] boolValue];
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (isCurrentUserFriend) {
        [currentUser addFriendsObject:result];
    } else {
        [currentUser removeFriendsObject:result];
    }
    
    return result;
}

+ (User *)userWithID:(NSString *)userID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", userID]];
    
    User *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
