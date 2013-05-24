//
//  WTActivityImageRollView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityImageRollView.h"
#import "UIImageView+AsyncLoading.h"

@interface WTActivityImageRollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation WTActivityImageRollView

- (WTActivityImageRollItemView *)currentItemView {
    return [self itemViewAtIndex:self.pageControl.currentPage];
}

- (WTActivityImageRollItemView *)itemViewAtIndex:(NSUInteger)index {
    return [self.itemViewArray objectAtIndex:index];
}

- (void)reloadItemImages {
    for (WTActivityImageRollItemView *itemView in self.itemViewArray) {
        [itemView.imageView loadImageWithImageURLString:itemView.imageURLString success:^(UIImage *image) {
            itemView.imageView.image = image;
        } failure:nil];
    }
}

+ (WTActivityImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray {
    WTActivityImageRollView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTActivityImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTActivityImageRollView class]]) {
            result = (WTActivityImageRollView *)view;
            break;
        }
    }
    result.itemViewArray = [NSMutableArray arrayWithCapacity:4];
    
    for (NSString *imageURLString in imageURLArray) {
        [result addImageViewWithImageURLString:imageURLString];
    }
    
    result.scrollView.contentSize = CGSizeMake(result.scrollView.frame.size.width * result.itemViewArray.count, result.scrollView.frame.size.height);
    result.pageControl.numberOfPages = result.itemViewArray.count;
    
    return result;
}

- (void)addImageViewWithImageURLString:(NSString *)imageURLString {
    WTActivityImageRollItemView *itemView = [WTActivityImageRollItemView createItemViewWithImageURLString:imageURLString];
    itemView.imageURLString = imageURLString;
    
    [itemView resetOriginX:self.itemViewArray.count * self.scrollView.frame.size.width];
    
    [self.rightShadowImageView resetOriginX:(self.itemViewArray.count + 1) * self.scrollView.frame.size.width];
    
    [self.scrollView addSubview:itemView];
    [self.itemViewArray addObject:itemView];
}

- (void)updateScrollView {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self updateScrollView];
    }
}

@end

@interface WTActivityImageRollItemView ()

@end

@implementation WTActivityImageRollItemView

+ (WTActivityImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString {
    WTActivityImageRollItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTActivityImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTActivityImageRollItemView class]]) {
            result = (WTActivityImageRollItemView *)view;
            break;
        }
    }
    [result loadImageWithImageURLString:imageURLString];
    
    return result;
}

- (void)loadImageWithImageURLString:(NSString *)imageURLString {
    [self.imageView loadImageWithImageURLString:imageURLString];
}

@end