//
//  WTBannerContainerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBannerView.h"
#import "UIImageView+AsyncLoading.h"

@interface WTBannerContainerView()

@property (nonatomic, strong) NSMutableArray *bannerItemViewArray;
@property (nonatomic, assign) NSUInteger bannerItemCount;

@property (nonatomic, assign) CGFloat originalBottomY;

@property (nonatomic, assign) CGFloat formerEnlargeRatio;

@property (nonatomic, assign) CGFloat pageControlOriginY;

@end

@implementation WTBannerContainerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)didMoveToSuperview {
    self.originalBottomY = self.frame.origin.y + self.frame.size.height;
    self.pageControlOriginY = self.bannerPageControl.frame.origin.y;
}

#pragma mark - Public methods

+ (WTBannerContainerView *)createBannerContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WTBannerContainerView" owner:self options:nil] lastObject];
}

- (void)configureBannerContainerViewHeight:(CGFloat)height {
    if (height < BANNER_VIEW_ORIGINAL_HIEHGT)
        return;
    
    CGFloat enlargeRatio = height / BANNER_VIEW_ORIGINAL_HIEHGT;
    BOOL isEnlarging = enlargeRatio > self.formerEnlargeRatio;
    self.formerEnlargeRatio = enlargeRatio;
    
    CGSize bannerViewSize = CGSizeMake(floorf(enlargeRatio * BANNER_VIEW_ORIGINAL_WIDTH), height);

    [self resetSize:bannerViewSize];
    [self resetOriginY:self.originalBottomY - bannerViewSize.height];
    [self resetCenterX:BANNER_VIEW_ORIGINAL_WIDTH / 2];
    
    [self.bannerPageControl resetCenterX:self.frame.size.width / 2];
    [self.bannerPageControl resetOriginY:bannerViewSize.height - BANNER_VIEW_ORIGINAL_HIEHGT + self.pageControlOriginY];
    [self.bottomShadowImageView resetOriginY:bannerViewSize.height];
        
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * self.bannerItemCount, bannerViewSize.height);
    self.bannerScrollView.contentOffset = CGPointMake(self.frame.size.width * self.bannerPageControl.currentPage, 0);
    [self.bannerScrollView resetHeight:bannerViewSize.height];
        
    for (int i = 0; i < self.bannerItemViewArray.count; i++) {
        WTBannerItemView *containerView = self.bannerItemViewArray[i];
        [containerView resetOriginX:containerView.frame.size.width * i];
        [containerView configureBannerItemViewHeight:bannerViewSize.height
                                        enlargeRatio:enlargeRatio
                                         isEnlarging:isEnlarging];
    }
}

- (void)addItemViewWithImage:(UIImage *)image
                   titleText:(NSString *)title
            organizationName:(NSString *)organization
                       style:(WTBannerItemViewStyle)style
                     atIndex:(NSUInteger)index {
    [self addItemViewWithTitleText:title
                  organizationName:organization
                             style:style
                           atIndex:index];
    
    WTBannerItemView *containerView = self.bannerItemViewArray[index];
    containerView.imageView.image = image;
}

- (void)addItemViewWithImageURL:(NSString *)imageURLString
                      titleText:(NSString *)title
               organizationName:(NSString *)organization
                          style:(WTBannerItemViewStyle)style
                        atIndex:(NSUInteger)index {
    [self addItemViewWithTitleText:title
                  organizationName:organization
                             style:style
                           atIndex:index];
    
    WTBannerItemView *containerView = self.bannerItemViewArray[index];
    [containerView.imageView loadImageWithImageURLString:imageURLString];
}

- (void)addItemViewWithTitleText:(NSString *)title
                organizationName:(NSString *)organization
                           style:(WTBannerItemViewStyle)style
                         atIndex:(NSUInteger)index {
    self.bannerItemCount = self.bannerItemCount + 1;
    WTBannerItemView *itemView = self.bannerItemViewArray[index];
    itemView.titleLabel.text = title;
    itemView.organizationNameLabel.text = organization;
    itemView.style = style;
}

#pragma mark - Properties

- (NSMutableArray *)bannerItemViewArray {
    if (_bannerItemViewArray == nil) {
        _bannerItemViewArray = [[NSMutableArray alloc] init];
    }
    return _bannerItemViewArray;
}

- (void)setBannerItemCount:(NSUInteger)bannerItemCount {
    if (bannerItemCount > _bannerItemCount) {
        for(NSUInteger i = _bannerItemCount; i < bannerItemCount; i++) {
            WTBannerItemView *itemView = [self createBannerItemViewAtIndex:i];
            [self.bannerItemViewArray addObject:itemView];
            [self.bannerScrollView addSubview:itemView];
        }
    } else if (bannerItemCount < _bannerItemCount) {
        for(NSUInteger i = bannerItemCount; i < _bannerItemCount; i++) {
            WTBannerItemView *itemView = self.bannerItemViewArray[i];
            [itemView removeFromSuperview];
            [self.bannerItemViewArray removeObjectAtIndex:i];
        }
    } else
        return;
    
    _bannerItemCount = bannerItemCount;
    self.bannerPageControl.numberOfPages = bannerItemCount;
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * bannerItemCount, self.bannerScrollView.frame.size.height);
    
    [self.rightShadowImageView resetOrigin:CGPointMake(self.bannerScrollView.contentSize.width, 0)];
}

#pragma mark - UI methods

- (WTBannerItemView *)createBannerItemViewAtIndex:(NSUInteger)index {
    WTBannerItemView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTBannerItemView" owner:self options:nil] lastObject];
    [result resetOrigin:CGPointMake(self.bannerScrollView.frame.size.width * index, 0)];
    result.backgroundColor = [UIColor clearColor];
    return result;
}

- (void)updateBannerPateControl {
    int currentPage = self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width;
    self.bannerPageControl.currentPage = currentPage;
}

- (void)configureTestBanner {
    NSArray *orgNameArray = @[@"WeTongji Dev Team", @"Tongji Apple Club", @"Apple Inc."];
    NSArray *titleArray = @[@"WeTongji 3.0 Coming Soon", @"Enroll 2012", @"WWDC 2011"];
    for(int i = 0; i < orgNameArray.count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"WTTestBanner%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        [self addItemViewWithImage:image
                         titleText:titleArray[i]
                  organizationName:orgNameArray[i]
                             style:WTBannerItemViewStyleBlue
                           atIndex:i];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bannerScrollView)
        [self updateBannerPateControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (scrollView == self.bannerScrollView) {
            [self updateBannerPateControl];
        }
    }
}

@end

@interface WTBannerItemView ()

@property (nonatomic, assign) CGFloat organizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat titleLabelOriginY;

@property (nonatomic, assign) CGFloat formerOrganizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat formerTitleLabelOriginY;

@end

@implementation WTBannerItemView

- (void)awakeFromNib {
    self.organizationNameLabelOriginY = self.organizationNameLabel.frame.origin.y;
    self.titleLabelOriginY = self.titleLabel.frame.origin.y;
}

- (void)configureBannerItemViewHeight:(CGFloat)height
                         enlargeRatio:(float)enlargeRatio
                          isEnlarging:(BOOL)isEnlarging {
    
    [self resetHeight:height];
    [self.imageView resetHeight:height];
    [self.labelContainerView resetHeight:height];
    
    [self.titleLabel resetCenterX:self.labelContainerView.frame.size.width / 2];
    [self.organizationNameLabel resetCenterX:self.labelContainerView.frame.size.width / 2];
    
    
    CGFloat titleLabelOriginY = self.titleLabelOriginY * enlargeRatio;
    CGFloat organizationNameLabelOriginY = self.organizationNameLabelOriginY * enlargeRatio;
    
    titleLabelOriginY = isEnlarging ? MAX(titleLabelOriginY, self.formerTitleLabelOriginY) : MIN(titleLabelOriginY, self.formerTitleLabelOriginY);
    organizationNameLabelOriginY = isEnlarging ? MAX(organizationNameLabelOriginY, self.formerOrganizationNameLabelOriginY) : MIN(organizationNameLabelOriginY, self.formerOrganizationNameLabelOriginY);
    
    [self.titleLabel resetOriginY:titleLabelOriginY];
    [self.organizationNameLabel resetOriginY:organizationNameLabelOriginY];
    
    self.formerTitleLabelOriginY = titleLabelOriginY;
    self.formerOrganizationNameLabelOriginY = organizationNameLabelOriginY;
}

- (void)setStyle:(WTBannerItemViewStyle)style {
    switch (style) {
        case WTBannerItemViewStyleBlue:
        {
            self.labelContainerView.hidden = NO;
        }
            break;
        case WTBannerItemViewStyleClear:
        {
            self.labelContainerView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

@end
