//
//  WTBannerView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBannerView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *bannerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *bannerPageControl;
@property (nonatomic, strong) IBOutlet UIImageView *leftShadowImageView;
@property (nonatomic, strong) IBOutlet UIImageView *rightShadowImageView;
@property (nonatomic, assign) NSUInteger bannerCount;

- (void)setImage:(UIImage *)image
       titleText:(NSString *)title
organizationName:(NSString *)organization
         atIndex:(NSUInteger)index;

@end

@interface WTBannerContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
