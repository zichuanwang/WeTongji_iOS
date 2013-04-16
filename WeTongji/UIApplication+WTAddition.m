//
//  UIApplication+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIApplication+WTAddition.h"
#import "WTAppDelegate.h"
#import "WTNowViewController.h"
#import "WTNowNavigationController.h"

@implementation UIApplication (WTAddition)

+ (void)showTopCorner {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView *topLeftCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopLeft"]];
    UIImageView *topRightCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopRight"]];
    [topLeftCornerImageView resetOrigin:CGPointMake(0, 20)];
    [topRightCornerImageView resetOrigin:CGPointMake(screenSize.width - topRightCornerImageView.frame.size.width, 20)];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:topLeftCornerImageView];
    [keyWindow addSubview:topRightCornerImageView];
}

- (WTRootTabBarController *)rootTabBarController {
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    return (WTRootTabBarController *)appDelegate.window.rootViewController;
}

// TODO: 用此方法重新home的回调

- (WTNowViewController *)nowViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    WTNowNavigationController *nowNavigationController = rootTabBarViewController.viewControllers[1];
    return nowNavigationController.viewControllers[0];
}

@end
