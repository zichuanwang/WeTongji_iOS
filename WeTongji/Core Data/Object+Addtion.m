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

+ (NSArray *)getAllObjectsHeldByHolder:(id)holder
                      objectEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
    
    NSString *holderIdentifier = NSStringFromClass([holder class]);
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ in heldBy", holderIdentifier]];
    
    NSArray *result = [context executeFetchRequest:request error:NULL];
    
    return result;
}

- (void)setObjectHeldByHolder:(id)holder {
    NSMutableSet *newHolderSet = [NSMutableSet setWithSet:self.holderSet];
    [newHolderSet addObject:NSStringFromClass([holder class])];
    self.heldBy = newHolderSet;
}

- (void)setObjectFreeFromHolder:(id)holder {
    NSMutableSet *newHolderSet = [NSMutableSet setWithSet:self.holderSet];
    NSString *holderIdentifier = NSStringFromClass([holder class]);
    __block NSString *holderIdentifierToRemove = nil;
    [newHolderSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSString *identifier = obj;
        if ([identifier isEqualToString:holderIdentifier]) {
            holderIdentifierToRemove = holderIdentifier;
            *stop = YES;
        }
    }];
    if (holderIdentifierToRemove)
        [newHolderSet removeObject:holderIdentifierToRemove];
    self.heldBy = newHolderSet;
    
    if (newHolderSet.count == 0) {
        WTLOG(@"Delete object:%@", NSStringFromClass([self class]));
        NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
        [context deleteObject:self];
    }
}

+ (void)setAllObjectsFreeFromHolder:(id)holder {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:context]];
    
    NSString *holderIdentifier = NSStringFromClass([holder class]);
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ in heldBy", holderIdentifier]];
    
    NSArray *heldObjects = [context executeFetchRequest:request error:NULL];
    
    for(Object *item in heldObjects) {
        [item setObjectFreeFromHolder:holder];
    }
}

#pragma mark - Properties

- (NSSet *)holderSet {
    return self.heldBy;
}

@end
