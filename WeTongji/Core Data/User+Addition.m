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
    result.emailAddress = [NSString stringWithFormat:@"%@", dict[@"Email"]];
    result.gender = [NSString stringWithFormat:@"%@", dict[@"Gender"]];
    result.major = [NSString stringWithFormat:@"%@", dict[@"Major"]];
    result.studentNumber = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.phoneNumber = [NSString stringWithFormat:@"%@", dict[@"Phone"]];
    result.studyPlan = @([[NSString stringWithFormat:@"%@", dict[@"Plan"]] integerValue]);
    result.sinaWeiboName = [NSString stringWithFormat:@"%@", dict[@"SinaWeibo"]];
    result.enrollYear = @([[NSString stringWithFormat:@"%@", dict[@"Year"]] integerValue]);
    result.qqAccount = [NSString stringWithFormat:@"%@", dict[@"QQ"]];
    
    BOOL isCurrentUserFriend = [[NSString stringWithFormat:@"%@", dict[@"IsFriend"]] boolValue];
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (isCurrentUserFriend) {
        [currentUser addFriendsObject:result];
    } else {
        [currentUser removeFriendsObject:result];
    }
    
    return result;
}

+ (User *)createTestUserWithName:(NSString *)name {
    User *result = [User userWithID:name];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = name;
    }
    result.name = name;
    return result;
}

+ (NSArray *)createTestUsers {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *testUserNameArray = @[@"唐雅怡", @"冯泽西", @"蔡思雨", @"周杰伦", @"方璐"];
    
    for (int i = 0; i < 5; i++) {
        NSString *userID = [NSString stringWithFormat:@"%d", i];
        
        if (!userID || [userID isEqualToString:@""]) {
            continue;
        }
        
        User *result = [User userWithID:userID];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
            result.identifier = userID;
        }
        
        result.name = testUserNameArray[i];
        [resultArray addObject:result];
    }
    return resultArray;
}

+ (User *)userWithID:(NSString *)userID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", userID]];
    
    User *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
