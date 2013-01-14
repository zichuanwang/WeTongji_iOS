//
//  Image.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"


@interface Image : Object

@property (nonatomic, retain) id image;
@property (nonatomic) NSTimeInterval update_date;

@end
