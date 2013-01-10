//
//  WTBannerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBannerView.h"

@interface WTBannerView()

@property (nonatomic, strong) NSMutableArray *bannerContainerViewArray;

@end

@implementation WTBannerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureTestBanner];
}

#pragma mark - Public methods

- (void)setImage:(UIImage *)image
       titleText:(NSString *)title
organizationName:(NSString *)organization
         atIndex:(NSUInteger)index {
    if (index >= self.bannerCount)
        return;
    WTBannerContainerView *containerView = self.bannerContainerViewArray[index];
    containerView.titleLabel.text = title;
    containerView.organizationNameLabel.text = organization;
    containerView.imageView.image = image;
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
    self.bannerCount = 3;
    NSArray *orgNameArray = @[@"WeTongji Dev Team", @"Tongji Apple Club", @"Apple Inc."];
    NSArray *titleArray = @[@"WeTongji 3.0 Coming Soon", @"Enroll 2012", @"WWDC 2011"];
    for(int i = 0; i < self.bannerCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"WTTestBanner%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [self setImage:image titleText:titleArray[i] organizationName:orgNameArray[i] atIndex:i];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bannerScrollView)
        [self updateBannerScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (scrollView == self.bannerScrollView)
            [self updateBannerScrollView];
    }
}

@end

@implementation WTBannerContainerView

@end
