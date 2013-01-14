//
//  News.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"


@interface News : Object

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * publish_date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * publish_day;

@end
