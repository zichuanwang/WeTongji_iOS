//
//  Activity.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Activity : Event

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * organizer_id;
@property (nonatomic, retain) NSString * content;

@end
