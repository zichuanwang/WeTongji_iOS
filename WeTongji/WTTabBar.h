//
//  WTTabBar.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTTabBarDelegate;

@interface WTTabBar : UIImageView

@property (nonatomic, weak) id<WTTabBarDelegate> delegate;

@end

@protocol WTTabBarDelegate <NSObject>

- (void)WTTabBar:(WTTabBar *)view
               didClickTabBarButton:(UIButton *)button;

@end
