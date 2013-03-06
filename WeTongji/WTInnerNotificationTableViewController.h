//
//  WTInnerNotificationTableViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationViewController.h"
#import "WTCoreDataTableViewController.h"
#import "WTWaterflowDecorator.h"
#import "WTNotificationCell.h"

@interface WTInnerNotificationTableViewController : WTCoreDataTableViewController <WTWaterflowDecoratorDataSource, WTNotificationCellDelegate>

@end
