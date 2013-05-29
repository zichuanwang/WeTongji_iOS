//
//  Event.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommentableObject.h"

@class User;

@interface Event : CommentableObject

@property (nonatomic, retain) NSString * beginDay;
@property (nonatomic, retain) NSDate * beginTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * what;
@property (nonatomic, retain) NSString * where;
@property (nonatomic, retain) User *scheduledBy;

@end
