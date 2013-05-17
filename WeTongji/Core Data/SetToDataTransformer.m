
//
//  SetToDataTransformer.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "SetToDataTransformer.h"

@implementation WTSetToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    //Take an NSArray archive to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    return data;
}

- (id)reverseTransformedValue:(id)value {
    //Take NSData unarchive to NSArray
    NSSet *set = (NSSet *)[NSKeyedUnarchiver unarchiveObjectWithData:value];
    return set;
}

@end
