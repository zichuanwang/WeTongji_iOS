//
//  News.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"


@interface News : Object

@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) id imageArray;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizerAvatar;
@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) NSString * publishDay;
@property (nonatomic, retain) NSNumber * readCount;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * category;

@end
