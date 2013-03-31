//
//  WTBannerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBannerView.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

@interface WTBannerView()

@property (nonatomic, strong) NSMutableArray *bannerContainerViewArray;
@property (nonatomic, assign) NSUInteger bannerCount;

@property (nonatomic, assign) CGFloat originalBottomY;

@property (nonatomic, assign) CGFloat formerEnlargeRatio;

@property (nonatomic, assign) CGFloat pageControlOriginY;

@end

@implementation WTBannerView

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

+ (WTBannerView *)createBannerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil] lastObject];
}

- (void)configureBannerViewHeight:(CGFloat)height {
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
        
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * self.bannerCount, bannerViewSize.height);
    self.bannerScrollView.contentOffset = CGPointMake(self.frame.size.width * self.bannerPageControl.currentPage, 0);
    [self.bannerScrollView resetHeight:bannerViewSize.height];
        
    for (int i = 0; i < self.bannerContainerViewArray.count; i++) {
        WTBannerContainerView *containerView = self.bannerContainerViewArray[i];
        [containerView resetOriginX:containerView.frame.size.width * i];
        [containerView configureBannerContainerViewHeight:bannerViewSize.height
                                             enlargeRatio:enlargeRatio
                                              isEnlarging:isEnlarging];
    }
}

- (void)addContainerViewWithImage:(UIImage *)image
                        titleText:(NSString *)title
                 organizationName:(NSString *)organization
                            style:(WTBannerContainerViewStyle)style
                          atIndex:(NSUInteger)index {
    [self addContainerViewWithTitleText:title
                       organizationName:organization
                                  style:style
                                atIndex:index];
    
    WTBannerContainerView *containerView = self.bannerContainerViewArray[index];
    containerView.imageView.image = image;
}

- (void)addContainerViewWithImageURL:(NSString *)imageURLString
                           titleText:(NSString *)title
                    organizationName:(NSString *)organization
                               style:(WTBannerContainerViewStyle)style
                             atIndex:(NSUInteger)index {
    [self addContainerViewWithTitleText:title
                       organizationName:organization
                                  style:style
                                atIndex:index];
    
    WTBannerContainerView *containerView = self.bannerContainerViewArray[index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [containerView.imageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             containerView.imageView.image = image;
                                             [containerView.imageView fadeIn];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             
                                         }];
}

- (void)addContainerViewWithTitleText:(NSString *)title
                     organizationName:(NSString *)organization
                                style:(WTBannerContainerViewStyle)style
                              atIndex:(NSUInteger)index {
    self.bannerCount = self.bannerCount + 1;
    WTBannerContainerView *containerView = self.bannerContainerViewArray[index];
    containerView.titleLabel.text = title;
    containerView.organizationNameLabel.text = organization;
    containerView.style = style;
}

#pragma mark - Properties

- (NSMutableArray *)bannerContainerViewArray {
    if (_bannerContainerViewArray == nil) {
        _bannerContainerViewArray = [[NSMutableArray alloc] init];
    }
    return _bannerContainerViewArray;
}

- (void)setBannerCount:(NSUInteger)bannerCount {
    if (bannerCount > _bannerCount) {
        for(NSUInteger i = _bannerCount; i < bannerCount; i++) {
            WTBannerContainerView *containerView = [self createBannerContainerViewAtIndex:i];
            [self.bannerContainerViewArray addObject:containerView];
            [self.bannerScrollView addSubview:containerView];
        }
    } else if (bannerCount < _bannerCount) {
        for(NSUInteger i = bannerCount; i < _bannerCount; i++) {
            WTBannerContainerView *containerView = [self createBannerContainerViewAtIndex:i];
            [containerView removeFromSuperview];
            [self.bannerContainerViewArray removeObjectAtIndex:i];
        }
    } else
        return;
    
    _bannerCount = bannerCount;
    self.bannerPageControl.numberOfPages = bannerCount;
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * bannerCount, self.bannerScrollView.frame.size.height);
    
    [self.rightShadowImageView resetOrigin:CGPointMake(self.bannerScrollView.contentSize.width, 0)];
}

#pragma mark - UI methods

- (WTBannerContainerView *)createBannerContainerViewAtIndex:(NSUInteger)index {
    WTBannerContainerView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTBannerContainerView" owner:self options:nil] lastObject];
    [result resetOrigin:CGPointMake(self.bannerScrollView.frame.size.width * index, 0)];
    result.backgroundColor = [UIColor clearColor];
    return result;
}

- (void)updateBannerScrollView {
    int currentPage = self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width;
    self.bannerPageControl.currentPage = currentPage;
}

- (void)configureTestBanner {
    NSArray *orgNameArray = @[@"WeTongji Dev Team", @"Tongji Apple Club", @"Apple Inc."];
    NSArray *titleArray = @[@"WeTongji 3.0 Coming Soon", @"Enroll 2012", @"WWDC 2011"];
    for(int i = 0; i < orgNameArray.count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"WTTestBanner%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        [self addContainerViewWithImage:image
                              titleText:titleArray[i]
                       organizationName:orgNameArray[i]
                                  style:WTBannerContainerViewStyleBlue
                                atIndex:i];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bannerScrollView)
        [self updateBannerScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (scrollView == self.bannerScrollView) {
            [self updateBannerScrollView];
        }
    }
}

@end

@interface WTBannerContainerView ()

@property (nonatomic, assign) CGFloat organizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat titleLabelOriginY;

@property (nonatomic, assign) CGFloat formerOrganizationNameLabelOriginY;
@property (nonatomic, assign) CGFloat formerTitleLabelOriginY;

@end

@implementation WTBannerContainerView

- (void)awakeFromNib {
    self.organizationNameLabelOriginY = self.organizationNameLabel.frame.origin.y;
    self.titleLabelOriginY = self.titleLabel.frame.origin.y;
}

- (void)configureBannerContainerViewHeight:(CGFloat)height
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

- (void)setStyle:(WTBannerContainerViewStyle)style {
    switch (style) {
        case WTBannerContainerViewStyleBlue:
        {
            self.labelContainerView.hidden = NO;
        }
            break;
        case WTBannerContainerViewStyleClear:
        {
            self.labelContainerView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

@end
