//
//  WTHomeViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTHomeViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *bannerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *bannerPageControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *panelMoreButton;

@end
