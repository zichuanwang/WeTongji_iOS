//
//  WTNavigationController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRootNavigationController : UINavigationController

- (void)showInnerModalViewController:(UIViewController *)vc;

- (void)hideInnerModalViewController;

@end