//
//  WTImageViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDetailImageViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

+ (void)showDetailImageViewWithImageURLString:(NSString *)imageURLString;

+ (void)showDetailImageViewWithImageURLArray:(NSArray *)imageURLArray
                                 currentPage:(NSUInteger)currentPage;

@end
