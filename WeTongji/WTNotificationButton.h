//
//  WTNotificationButton.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNotificationButton : UIView

@property (nonatomic, assign, getter = isSelected) BOOL selected;

// The selector must be |doSomething:|
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)startShine;
- (void)stopShine;

@end
