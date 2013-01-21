//
//  Activity+Addition.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "Activity.h"

@interface Activity (Addition)

+ (Activity *)insertActivity:(NSDictionary *)dict;
+ (Activity *)activityWithID:(NSString *)activityID;

@end
