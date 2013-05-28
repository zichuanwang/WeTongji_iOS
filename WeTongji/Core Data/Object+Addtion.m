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
#import "BillboardPost.h"
#import "Activity.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation Object (Addtion)

+ (NSArray *)getAllObjectsHeldByHolder:(Class)holderClass
                      objectEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
    
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", controller.hasObjects]];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    return result;
}

- (void)setObjectHeldByHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [controller addHasObjectsObject:self];
}

- (void)setObjectFreeFromHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [self removeBelongToControllersObject:controller];
    
    if (self.belongToControllers.count == 0) {
        WTLOG(@"Delete object:%@", NSStringFromClass([self class]));
        NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
        [context deleteObject:self];
    }
}

+ (void)setAllObjectsFreeFromHolder:(Class)holderClass {
    Controller *controller = [Controller controllerModelForClass:holderClass];
    [controller removeHasObjects:controller.hasObjects];
}

- (NSInteger)getObjectModelType {
    NSInteger modelType = -1;
    if ([self isKindOfClass:[BillboardPost class]]) {
        modelType = WTSDKBillboard;
    }
    return modelType;
}

@end
