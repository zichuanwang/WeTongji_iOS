//
//  Object+Addtion.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Object+Addtion.h"
#import "WTCoreDataManager.h"
#import "Controller+Addition.h"

@implementation Object (Addtion)

+ (NSArray *)getAllObjectsHeldByHolder:(id)holder
                      objectEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
    
    Controller *controller = [Controller controllerModelForClass:[holder class]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", controller.hasObjects]];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    return result;
}

- (void)setObjectHeldByHolder:(id)holder {
    Controller *controller = [Controller controllerModelForClass:[holder class]];
    [controller addHasObjectsObject:self];
}

- (void)setObjectFreeFromHolder:(id)holder {
    Controller *controller = [Controller controllerModelForClass:[holder class]];
    [self removeBelongToControllersObject:controller];
    
    if (self.belongToControllers.count == 0) {
        WTLOG(@"Delete object:%@", NSStringFromClass([self class]));
        NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
        [context deleteObject:self];
    }
}

+ (void)setAllObjectsFreeFromHolder:(id)holder {
    Controller *controller = [Controller controllerModelForClass:[holder class]];
    [controller removeHasObjects:controller.hasObjects];
}

@end
