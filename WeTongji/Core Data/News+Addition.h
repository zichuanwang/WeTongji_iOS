//
//  News+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News.h"

@interface News (Addition)

+ (News *)insertNews:(NSDictionary *)dict;
+ (News *)newsWithID:(NSString *)newsID;

@end
