//
//  BillboardPost+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "BillboardPost+Addition.h"
#import "WTCoreDataManager.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"

@implementation BillboardPost (Addition)

+ (void)createTestBillboardPosts {
    
    for (int i = 0; i < 3; i++) {
        BillboardPost *result = nil;
        for (int j = 0; j < 3; j++) {
            NSString *postID = [NSString stringWithFormat:@"%d", i * 3 + j];
            result = [BillboardPost postWithID:postID];
            if (!result) {
                result = [NSEntityDescription insertNewObjectForEntityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
                result.identifier = postID;
                result.createdAt = [NSDate date];
            }
            
            result.image = @"http://pic.newssc.org/0/12/47/48/12474837_985448.jpg";
            result.title = @"谁认识这个美女!谁认识这个美女!谁认识这个美女!";
            result.content = @"章泽天是南京外国语学校公认的校花，学校健美操队队员。高一荣获全国健美操亚军，国家一级运动员称号。她本人非常喜欢粉红色。奶茶的照片被猫扑的一位名叫“mop笔袋男”的网友看到后，惊呼非常可爱，简直就像小周慧敏，并在帖子里求爱，请这位奶茶mm做自己的女朋友，并请求网友找出奶茶mm的详细资料。\n不到2天的时间， 这位奶茶mm的资料和照片就被晒到了网上。奶茶mm火了，从求爱贴到资料和照片公布不到一个星期。\n网友说这是10年末最后一位网络红人。\n其实在猫扑之前，她就已经在百度李毅吧、皇家马德里吧以及水木社区走红，关于她的帖子2012年12月20日登上水木社区“十大”头条。";
            
            if (i == 1)
                result.image = nil;
        }
    }
}

+ (BillboardPost *)insertBillboardPost:(NSDictionary *)dict {
    NSString *postID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    if (!postID || [postID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    BillboardPost *result = [BillboardPost postWithID:postID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = postID;
        result.objectClass = NSStringFromClass([BillboardPost class]);
    }
    if ([[NSString stringWithFormat:@"%@", dict[@"Title"]] length] > 0)
        result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    if ([result.image isEmptyImageURL])
        result.image = nil;
    
    if (result.image == nil && [[NSString stringWithFormat:@"%@", dict[@"Body"]] length] > 0) {
        result.content = [NSString stringWithFormat:@"%@", dict[@"Body"]];
    }
    
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"PublishedAt"]] convertToDate];
    result.commentCount = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CommentsCount"]]).integerValue);
    
    User *user = [User insertUser:dict[@"UserDetails"]];
    result.author = user;
    return result;
}

+ (BillboardPost *)postWithID:(NSString *)postID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", postID]];
    
    BillboardPost *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)clearAllBillboardPosts {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"BillboardPost" inManagedObjectContext:context]];
    NSArray *allBillboardPosts = [context executeFetchRequest:request error:NULL];
    
    for(BillboardPost *item in allBillboardPosts) {
        [context deleteObject:item];
    }
}

@end
