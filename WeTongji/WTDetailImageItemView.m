//
//  WTDetailImageItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailImageItemView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIImageView+AsyncLoading.h"

@interface WTDetailImageItemView () <UIAlertViewDelegate, UIScrollViewDelegate>

@end

@implementation WTDetailImageItemView

+ (WTDetailImageItemView *)createDetailItemViewWithImageURLString:(NSString *)imageURLString
                                                         delegate:(id<WTDetailImageItemViewDelegate>)delegate {
    WTDetailImageItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTDetailImageItemView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTDetailImageItemView class]]) {
            result = (WTDetailImageItemView *)view;
            break;
        }
    }
    
    result.delegate = delegate;
    [result configureViewWithImageURLString:imageURLString];
    
    return result;
}

- (void)awakeFromNib {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressImageView:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer* tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagScollViewView:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UI methods

- (void)configureViewWithImageURLString:(NSString *)imageURLString {
    [self.activityIndicator startAnimating];
    [self.imageView loadImageWithImageURLString:imageURLString success:^(UIImage *image) {
        [self.activityIndicator fadeOut];
        [self.activityIndicator startAnimating];
    } failure:^{
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Handle gesture

- (void)didLongPressImageView:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存图片" message:@"保存图片到相册？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}

- (void)didTagScollViewView:(UITapGestureRecognizer *)gesture {
    [self.delegate userTappedDetailImageItemView:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self performSelectorInBackground:@selector(saveImageInBackground:) withObject:self.imageView.image];
    }
}

#pragma mark - Save image methods

- (void)saveImageInBackground:(UIImage *)image {
    if (image) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:@"WeTongji" withCompletionBlock:^(NSError *error) {
            if (error != nil) {
                WTLOGERROR(@"WTImageView: save photo error {\n %@}", [error description]);
            }
        }];
    }
}

#pragma mark UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"scrollview contentsize:%@", NSStringFromCGSize(scrollView.contentSize));
}

@end
