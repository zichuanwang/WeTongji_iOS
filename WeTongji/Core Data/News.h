//
//  News.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
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
@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) NSString * publishDay;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;

@end
