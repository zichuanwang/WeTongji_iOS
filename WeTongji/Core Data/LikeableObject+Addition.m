//
//  LikeableObject+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "LikeableObject+Addition.h"
#import "WTCoreDataManager.h"
#import "NSNotificationCenter+WTAddition.h"
#import "BillboardPost.h"
#import "Activity.h"
#import "News.h"
#import "Star.h"
#import "Organization.h"

@implementation LikeableObject (Addition)

- (void)configureLikeInfo:(NSDictionary *)dict {
    self.likeCount = @([([NSString stringWithFormat:@"%@", dict[@"Like"]]) integerValue]);
    // TODO:
    if (dict[@"CanLike"])
        self.liked = ![[NSString stringWithFormat:@"%@", dict[@"CanLike"]] boolValue];
}

#pragma mark - Properties

- (BOOL)liked {
    return [[WTCoreDataManager sharedManager].currentUser.likedObjects containsObject:self];
}

- (void)setLiked:(BOOL)liked {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (!currentUser)
        return;
    if (liked) {
        if ([currentUser.likedObjects containsObject:self])
            return;
        WTLOG(@"add like object:%@, model:%@", self.identifier, self.objectClass);
        [currentUser addLikedObjectsObject:self];
    } else {
        if (![currentUser.likedObjects containsObject:self])
            return;
        WTLOG(@"remove like object:%@, model:%@", self.identifier, self.objectClass);
        [currentUser removeLikedObjectsObject:self];
    }
    
    return;
    NSInteger likeCountIncrement = liked ? 1 : -1;
    if ([self isKindOfClass:[BillboardPost class]]) {
        currentUser.likedBillboardCount = @(currentUser.likedBillboardCount.integerValue + likeCountIncrement);
    } else if ([self isKindOfClass:[Activity class]]) {
        currentUser.likedActivityCount = @(currentUser.likedActivityCount.integerValue + likeCountIncrement);
    } else if ([self isKindOfClass:[News class]]) {
        currentUser.likedNewsCount = @(currentUser.likedNewsCount.integerValue + likeCountIncrement);
    } else if ([self isKindOfClass:[Star class]]) {
        currentUser.likedStarCount = @(currentUser.likedStarCount.integerValue + likeCountIncrement);
    } else if ([self isKindOfClass:[Organization class]]) {
        currentUser.likedOrganizationCount = @(currentUser.likedOrganizationCount.integerValue + likeCountIncrement);
    } else if ([self isKindOfClass:[User class]]) {
        currentUser.likedUserCount = @(currentUser.likedUserCount.integerValue + likeCountIncrement);
    }
    [NSNotificationCenter postCurrentUserLikeCountDidChangeNotification];
}

@end
