//
//  Organization.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"


@interface Organization : Object

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * name;

@end
