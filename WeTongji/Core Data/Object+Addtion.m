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

+ (void)clearAllHomeSelectedObjects {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"homeSelected == YES"]];
    NSArray *allHomeSelectedObjects = [context executeFetchRequest:request error:NULL];
    
    for(Object *item in allHomeSelectedObjects) {
        item.homeSelected = @(NO);
    }
}

+ (void)clearAllSearchResultObjects {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchResult == YES"]];
    NSArray *allSearchResultObjects = [context executeFetchRequest:request error:NULL];
    
    for(Object *item in allSearchResultObjects) {
        item.searchResult = @(NO);
    }
}

@end
