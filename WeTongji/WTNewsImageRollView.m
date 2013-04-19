//
//  WTNewsImageRollView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsImageRollView.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

@interface WTNewsImageRollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation WTNewsImageRollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WTNewsImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray {
    WTNewsImageRollView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTNewsImageRollView class]]) {
            result = (WTNewsImageRollView *)view;
            break;
        }
    }
    result.imageViewArray = [NSMutableArray arrayWithCapacity:4];
    
    for (NSString *imageURLString in imageURLArray) {
        [result addImageViewWithImageURLString:imageURLString];
        [result.imageViewArray addObject:imageURLString];
    }
    
    result.scrollView.contentSize = CGSizeMake(result.scrollView.frame.size.width * result.imageViewArray.count, result.scrollView.frame.size.height);
    result.pageControl.numberOfPages = result.imageViewArray.count;
    
    return result;
}

- (void)addImageViewWithImageURLString:(NSString *)imageURLString {
    WTNewsImageRollItemView *itemView = [WTNewsImageRollItemView createItemViewWithImageURLString:imageURLString];
    itemView.center = CGPointMake((self.scrollView.frame.size.width * (self.imageViewArray.count * 2 + 1)) / 2, self.scrollView.frame.size.height / 2);
    [self.scrollView addSubview:itemView];
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

@implementation WTNewsImageRollItemView

+ (WTNewsImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString {
    WTNewsImageRollItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsImageRollView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTNewsImageRollItemView class]]) {
            result = (WTNewsImageRollItemView *)view;
            break;
        }
    }
    [result configureView];
    [result loadImageWithImageURLString:imageURLString];
    
    return result;
}

- (void)configureView {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 2.0f;
}

- (void)loadImageWithImageURLString:(NSString *)imageURLString {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [self.imageView setImageWithURLRequest:request
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                self.imageView.image = image;
                                                [self.imageView fadeIn];
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                
                                            }];
}

@end
