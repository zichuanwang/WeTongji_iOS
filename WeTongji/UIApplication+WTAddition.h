//
//  UIApplication+WTAddition.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootTabBarController.h"

@class WTNowViewController;
@class WTBillboardViewController;

@interface UIApplication (WTAddition)

@property (nonatomic, readonly) WTRootTabBarController *rootTabBarController;

@property (nonatomic, readonly) WTNowViewController *nowViewController;

@property (nonatomic, readonly) WTBillboardViewController *billboardViewController;

+ (void)showTopCorner;

+ (void)dismissKeyWindowViewControllerAnimated:(BOOL)animated;

+ (void)presentKeyWindowViewController:(UIViewController *)vc animated:(BOOL)animated;

@end
