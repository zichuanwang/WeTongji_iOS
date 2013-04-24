//
//  BillboardComment.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class BillboardPost, User;

@interface BillboardComment : Object

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) BillboardPost *belongTo;

@end
