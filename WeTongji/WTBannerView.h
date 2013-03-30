//
//  WTBannerView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTBannerContainerViewStyleBlue,
    WTBannerContainerViewStyleClear,
} WTBannerContainerViewStyle;

@interface WTBannerView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *bannerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *bannerPageControl;
@property (nonatomic, weak) IBOutlet UIImageView *leftShadowImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rightShadowImageView;

+ (WTBannerView *)createBannerView;

- (void)addContainerViewWithImageURL:(NSString *)imageURLString
                           titleText:(NSString *)title
                    organizationName:(NSString *)organization
                               style:(WTBannerContainerViewStyle)style
                             atIndex:(NSUInteger)index;

- (void)addContainerViewWithImage:(UIImage *)image
                        titleText:(NSString *)title
                 organizationName:(NSString *)organization
                            style:(WTBannerContainerViewStyle)style
                          atIndex:(NSUInteger)index;

- (void)configureTestBanner;

@end

@interface WTBannerContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *labelContainerView;
@property (nonatomic, assign) WTBannerContainerViewStyle style;

@end
