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

#define BANNER_VIEW_ORIGINAL_HIEHGT     130.0f
#define BANNER_VIEW_ORIGINAL_WIDTH      320.0f

@interface WTBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *bannerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *bannerPageControl;
@property (nonatomic, weak) IBOutlet UIImageView *leftShadowImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rightShadowImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomShadowImageView;

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

- (void)configureBannerViewHeight:(CGFloat)height;

@end

@interface WTBannerContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *labelContainerView;
@property (nonatomic, assign) WTBannerContainerViewStyle style;

@property (nonatomic, assign) CGFloat organizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat titleLabelOriginY;

@property (nonatomic, assign) CGFloat formerOrganizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat formerTitleLabelOriginY;

@end
