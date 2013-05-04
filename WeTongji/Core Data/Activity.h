//
//  Activity.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Activity : Event

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSNumber * canSchedule;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizerAvatar;

@end
