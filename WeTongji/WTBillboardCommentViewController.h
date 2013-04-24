//
//  WTBillboardCommentViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"

@class BillboardPost;
@protocol WTBillboardCommentViewControllerDataSource;

@interface WTBillboardCommentViewController : WTCoreDataTableViewController

@property (nonatomic, weak) id<WTBillboardCommentViewControllerDataSource> dataSource;

+ (WTBillboardCommentViewController *)createCommentViewControllerWithBillboardPost:(BillboardPost *)post
                                                                        dataSource:(id<WTBillboardCommentViewControllerDataSource>)dataSource;

@end

@protocol WTBillboardCommentViewControllerDataSource <NSObject>

- (UIView *)commentViewControllerTableViewHeaderView;

@end