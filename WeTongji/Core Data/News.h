//
//  News.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSDate * publish_date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end
