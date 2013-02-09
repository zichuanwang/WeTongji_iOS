//
//  UIApplication+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIApplication+WTAddition.h"
#import "WTAppDelegate.h"

@implementation UIApplication (WTAddition)

- (WTRootTabBarController *)rootTabBarController {
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    return (WTRootTabBarController *)appDelegate.window.rootViewController;
}

@end
