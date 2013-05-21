//
//  BillboardPost+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "BillboardPost.h"

@interface BillboardPost (Addition)

+ (void)createTestBillboardPosts;

+ (void)clearAllBillboardPosts;

+ (BillboardPost *)insertBillboardPost:(NSDictionary *)dict;

+ (BillboardPost *)createTestBillboardPostWithTitle:(NSString *)title
                                            content:(NSString *)content
                                              image:(UIImage *)image;

@end
