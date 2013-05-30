//
//  LikeableObject+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "LikeableObject+Addition.h"
#import "WTCoreDataManager.h"

@implementation LikeableObject (Addition)

#pragma mark - Properties

- (BOOL)liked {
    return [[WTCoreDataManager sharedManager].currentUser.likedObjects containsObject:self];
}

- (void)setLiked:(BOOL)liked {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (liked) {
        [currentUser addLikedObjectsObject:self];
    } else {
        [currentUser removeLikedObjectsObject:self];
    }
}

@end
