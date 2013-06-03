//
//  Organization+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Organization+Addition.h"
#import "WTCoreDataManager.h"

@implementation Organization (Addition)

+ (Organization *)insertOrganization:(NSDictionary *)dict {
    NSString *orgID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!orgID || [orgID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    Organization *result = [Organization organizationWithID:orgID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = orgID;
        result.objectClass = NSStringFromClass([Organization class]);
    }
    
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Display"]];
    result.administrator = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.about = [NSString stringWithFormat:@"%@", dict[@"Description"]];
    if ([result.about isEqualToString:@"<null>"]) {
        result.about = nil;
    }
        
    return result;
}

+ (Organization *)organizationWithID:(NSString *)orgID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Organization" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", orgID]];
    
    Organization *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
