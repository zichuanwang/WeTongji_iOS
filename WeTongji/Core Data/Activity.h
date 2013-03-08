//
//  Activity.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Activity : Event

@property (nonatomic, retain) NSString * activity_description;
@property (nonatomic, retain) NSString * begin;
@property (nonatomic, retain) NSNumber * can_favorite;
@property (nonatomic, retain) NSNumber * can_like;
@property (nonatomic, retain) NSNumber * can_schedule;
@property (nonatomic, retain) NSNumber * channel_Id;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * end;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizer_avatar;
@property (nonatomic, retain) NSNumber * schedule;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;

@end
