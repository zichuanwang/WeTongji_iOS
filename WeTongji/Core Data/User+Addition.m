//
//  User+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "User+Addition.h"
#import "WTCoreDataManager.h"

@implementation User (Addition)

+ (User *)insertUser:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context {
    return nil;
}

+ (NSArray *)createTestUsers {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *testUserNameArray = @[@"试一个很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的名字", @"冯泽西", @"蔡思雨", @"周杰伦", @"王二狗"];
    
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
