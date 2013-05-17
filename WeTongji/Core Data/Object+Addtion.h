//
//  Object+Addtion.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Object.h"

@interface Object (Addtion)

@property (nonatomic, readonly) NSSet *holderSet;

- (void)setObjectHeldByHolder:(id)holder;

- (void)setObjectFreeFromHolder:(id)holder;

+ (void)setAllObjectsFreeFromHolder:(id)holder;

+ (NSArray *)getAllObjectsHeldByHolder:(id)holder
                      objectEntityName:(NSString *)entityName;

@end
