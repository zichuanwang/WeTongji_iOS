//
//  WTBannerContainerView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTBannerItemViewStyleBlue,
    WTBannerItemViewStyleClear,
} WTBannerItemViewStyle;

#define BANNER_VIEW_ORIGINAL_HIEHGT     130.0f
#define BANNER_VIEW_ORIGINAL_WIDTH      320.0f

@class WTBannerItemView;
@class Object;
@protocol WTBannerContainerViewDelegate;

@interface WTBannerContainerView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *bannerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *bannerPageControl;
@property (nonatomic, weak) IBOutlet UIView *shadowContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *rightShadowImageView;
@property (nonatomic, weak) id<WTBannerContainerViewDelegate> delegate;

+ (WTBannerContainerView *)createBannerContainerView;

- (WTBannerItemView *)addItemViewWithImageURL:(NSString *)imageURLString
                      titleText:(NSString *)title
               organizationName:(NSString *)organization
                          style:(WTBannerItemViewStyle)style;

- (WTBannerItemView *)addItemViewWithImage:(UIImage *)image
                   titleText:(NSString *)title
            organizationName:(NSString *)organization
                       style:(WTBannerItemViewStyle)style;

- (WTBannerItemView *)itemViewAtIndex:(NSUInteger)index;

- (WTBannerItemView *)currentItemView;

- (void)configureBannerWithObjectsArray:(NSArray *)objectsArray;

- (void)configureBannerContainerViewHeight:(CGFloat)height;

- (void)reloadItemImages;

@end

@protocol WTBannerContainerViewDelegate <NSObject>

- (void)bannerContainerView:(WTBannerContainerView *)containerView
       didSelectModelObject:(Object *)modelObject;

@end

@interface WTBannerItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *labelContainerView;
@property (nonatomic, assign) WTBannerItemViewStyle style;
@property (nonatomic, copy) NSString *imageURLString;

- (void)configureBannerItemViewHeight:(CGFloat)height
                         enlargeRatio:(float)enlargeRatio
                          isEnlarging:(BOOL)isEnlarging;

- (void)configureViewWithModelObject:(Object *)object;

@end
