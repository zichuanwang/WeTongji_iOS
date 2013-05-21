//
//  BillboardPost.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class BillboardComment;

@interface BillboardPost : Object

@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) id testImage;
@property (nonatomic, retain) NSSet *comments;
@end

@interface BillboardPost (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(BillboardComment *)value;
- (void)removeCommentsObject:(BillboardComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
