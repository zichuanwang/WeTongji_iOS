//
//  WTNewsViewController.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/10/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCoreDataTableViewController.h"
#import "WTRootNavigationController.h"
#import "WTInnerSettingViewController.h"

@interface WTNewsViewController : WTCoreDataTableViewController <WTRootNavigationControllerDelegate, WTInnerSettingViewControllerDelegate>

@property (nonatomic, readonly) NSInteger nextPage;

@end
