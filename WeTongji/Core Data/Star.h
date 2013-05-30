//
//  Star.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LikeableObject.h"


@interface Star : LikeableObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) id imageArray;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * motto;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * starNumber;
@property (nonatomic, retain) NSString * studentNumber;

@end
