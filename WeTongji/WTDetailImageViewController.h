//
//  WTImageViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTDetaiImageViewControllerDelegate;

@interface WTDetailImageViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) id<WTDetaiImageViewControllerDelegate> delegate;

+ (void)showDetailImageViewWithImageURLString:(NSString *)imageURLString
                                fromImageView:(UIImageView *)fromImageView
                                     fromRect:(CGRect)fromRect
                                     delegate:(id<WTDetaiImageViewControllerDelegate>)delegate;

+ (void)showDetailImageViewWithImageURLArray:(NSArray *)imageURLArray
                                 currentPage:(NSUInteger)currentPage
                               fromImageView:(UIImageView *)fromImageView
                                    fromRect:(CGRect)fromRect
                                    delegate:(id<WTDetaiImageViewControllerDelegate>)delegate;

@end

@protocol WTDetaiImageViewControllerDelegate <NSObject>

@optional
- (void)detailImageViewControllerDidDismiss:(NSUInteger)currentPage;

@end
