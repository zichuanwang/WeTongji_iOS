//
//  LikeableObject.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class User;

@interface LikeableObject : Object

@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) User *likedBy;

@end
