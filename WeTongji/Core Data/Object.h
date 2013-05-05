//
//  Object.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Object : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * homeSelected;

@end
