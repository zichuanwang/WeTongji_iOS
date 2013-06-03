//
//  Activity.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Organization;

@interface Activity : Event

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) Organization *author;

@end
