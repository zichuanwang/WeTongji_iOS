//
//  Object.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Controller, User;

@interface Object : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * objectClass;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSSet *belongToControllers;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *likedBy;
@end

@interface Object (CoreDataGeneratedAccessors)

- (void)addBelongToControllersObject:(Controller *)value;
- (void)removeBelongToControllersObject:(Controller *)value;
- (void)addBelongToControllers:(NSSet *)values;
- (void)removeBelongToControllers:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
