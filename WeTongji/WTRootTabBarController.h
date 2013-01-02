//
//  WTRootTabBarController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTRootTabBarViewControllerHome = 0,
    WTRootTabBarViewControllerNow,
    WTRootTabBarViewControllerSearch,
    WTRootTabBarViewControllerBillboard,
    WTRootTabBarViewControllerMe,
} WTRootTabBarViewControllerName;

@interface WTRootTabBarController : UITabBarController

- (void)clickTabWithName:(WTRootTabBarViewControllerName)name;

- (void)hideTabBar;
- (void)showTabBar;

@end
