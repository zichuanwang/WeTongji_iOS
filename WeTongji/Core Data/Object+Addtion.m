//
//  Object+Addtion.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Object+Addtion.h"
#import "WTCoreDataManager.h"

@implementation Object (Addtion)

+ (void)clearAllHomeSelectedObject {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"homeSelected == YES"]];
    NSArray *allHomeSelectedObject = [context executeFetchRequest:request error:NULL];
    NSLog(@"home selected object count:%d", allHomeSelectedObject.count);
    
    for(Object *item in allHomeSelectedObject) {
        item.homeSelected = @(NO);
    }
}

@end
