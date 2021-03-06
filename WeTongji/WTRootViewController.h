//
//  WTRootViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNotificationBarButton.h"
#import "WTRootNavigationController.h"

@interface WTRootViewController : UIViewController <WTRootNavigationControllerDelegate>

@property (nonatomic, strong) WTNotificationBarButton *notificationButton;

- (void)didHideInnderModalViewController;

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender;

- (void)hanldeCurrentUserDidChangeNotification:(NSNotification *)notification;

@end
