//
//  Activity.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Activity : Event

@property (nonatomic, retain) NSNumber * activity_type;
@property (nonatomic, retain) NSNumber * can_like;
@property (nonatomic, retain) NSNumber * can_schedule;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * like_count;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizer_avatar;

@end
