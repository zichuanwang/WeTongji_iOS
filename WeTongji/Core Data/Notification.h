//
//  Notification.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class User;

@interface Notification : Object

@property (nonatomic, retain) NSDate * send_time;
@property (nonatomic, retain) User *sender;
@property (nonatomic, retain) User *owner;

@end
