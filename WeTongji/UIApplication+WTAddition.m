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
#import "WTBillboardNavigationViewController.h"

static UIViewController *staticKeyWindowViewController;
static UIView           *staticKeyWindowBgView;


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

- (WTBillboardViewController *)billboardViewController {
    WTRootTabBarController *rootTabBarViewController = [UIApplication sharedApplication].rootTabBarController;
    WTBillboardNavigationViewController *billboardNavigationController = rootTabBarViewController.viewControllers[3];
    return billboardNavigationController.viewControllers[0];
}

#pragma mark - Key window view controller

+ (void)presentKeyWindowViewController:(UIViewController *)vc animated:(BOOL)animated {
    if (staticKeyWindowViewController)
        return;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    staticKeyWindowViewController = vc;
	staticKeyWindowBgView = [[UIView alloc] initWithFrame:screenBounds];
    vc.view.frame = screenBounds;
	staticKeyWindowBgView.backgroundColor = [UIColor blackColor];
        
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	[keyWindow addSubview:staticKeyWindowBgView];
	[keyWindow addSubview:vc.view];
    
    if(animated) {
        [vc.view resetOriginY:screenBounds.size.height];
        staticKeyWindowBgView.alpha = 0;
        [UIView animateWithDuration:0.25f animations:^{
            staticKeyWindowBgView.alpha = 1.0f;
            [vc.view resetOriginY:0];
        }];
    } else {
        staticKeyWindowBgView.alpha = 0;
    }
}

+ (void)dismissKeyWindowViewControllerAnimated:(BOOL)animated {
    if (animated) {
        staticKeyWindowBgView.alpha = 1.0f;
        [UIView animateWithDuration:0.25f animations:^{
            staticKeyWindowBgView.alpha = 0;
            [staticKeyWindowViewController.view resetOriginY:staticKeyWindowViewController.view.frame.size.height];
        } completion:^(BOOL finished) {
            [UIApplication clearKeyWindowViewController];
        }];
    } else {
        [UIApplication clearKeyWindowViewController];
    }
}

+ (void)clearKeyWindowViewController {
    [staticKeyWindowBgView removeFromSuperview];
    staticKeyWindowBgView = nil;
    [staticKeyWindowViewController.view removeFromSuperview];
    staticKeyWindowViewController = nil;
}

@end
