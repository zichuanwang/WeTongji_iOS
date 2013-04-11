//
//  Activity+Addition.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "Activity.h"
#import "Event+Addition.h"

@interface Activity (Addition)

@property (nonatomic, readonly) NSString *activityTypeString;

+ (Activity *)insertActivity:(NSDictionary *)dict;

+ (Activity *)activityWithID:(NSString *)activityID;

+ (void)clearAllActivites;

+ (NSArray *)getHomeSelectActivityArray;

@end
