//
//  Activity.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-26.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractNowItem.h"


@interface Activity : AbstractNowItem

@property (nonatomic, retain) NSString * activityDescription;
@property (nonatomic, retain) NSString * begin;
@property (nonatomic, retain) NSNumber * canFavorite;
@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSNumber * canSchedule;
@property (nonatomic, retain) NSNumber * channelId;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * end;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizerAvatar;
@property (nonatomic, retain) NSNumber * schedule;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;

@end
