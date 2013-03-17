//
//  WTNavigationController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTDisableNavBarTypeNone,
    WTDisableNavBarTypeLeft,
    WTDisableNavBarTypeRight,
} WTDisableNavBarType;

@protocol WTRootNavigationControllerDelegate;

@interface WTRootNavigationController : UINavigationController

- (void)showInnerModalViewController:(UIViewController *)innerController
                sourceViewController:(UIViewController<WTRootNavigationControllerDelegate> *)sourceController
                   disableNavBarType:(WTDisableNavBarType)type;

- (void)hideInnerModalViewController;

@end

@protocol WTRootNavigationControllerDelegate <NSObject>

@optional
- (void)didHideInnderModalViewController;

- (void)willHideInnderModalViewController;

@end
