//
//  Image.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSDate * update_date;

@end
