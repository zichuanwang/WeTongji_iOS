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
#import "UIImageView+ContentScale.h"
#import "UIApplication+WTAddition.h"

@interface WTDetailImageItemView () <UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL detectedDoubleTapOnScrollView;

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
    
    [result resetSize:[UIScreen mainScreen].bounds.size];
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
    
    UITapGestureRecognizer* doubleTapGestureRecognizer;
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapScrollView:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapGestureRecognizer];
    
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
}

#pragma mark - UI methods

- (void)configureViewWithImageURLString:(NSString *)imageURLString {

    [self.activityIndicator startAnimating];
    [self.imageView loadImageWithImageURLString:imageURLString success:^(UIImage *image) {
        self.imageView.image = image;
        self.imageView.alpha = 1.0f;
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        
        [self.imageView resetSize:CGSizeMake(image.size.width * self.imageView.contentScaleFactor, image.size.height * self.imageView.contentScaleFactor)];
        self.imageView.center = self.center;
        
        self.scrollView.contentSize = self.imageView.frame.size;

    } failure:^{
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Handle gesture

- (void)didLongPressImageView:(UILongPressGestureRecognizer *)gesture {
    if (!self.imageView.image)
        return;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
            [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
        }
            break;
            
        default:
            break;
    }
}

- (CGRect)scrollViewZoomRectWithCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = self.scrollView.frame.size.height / self.scrollView.maximumZoomScale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / self.scrollView.maximumZoomScale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)didDoubleTapScrollView:(UITapGestureRecognizer *)gesture {
    self.detectedDoubleTapOnScrollView = YES;
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        CGRect zoomRect = [self scrollViewZoomRectWithCenter:[gesture locationInView:self.imageView]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
    self.scrollView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        self.detectedDoubleTapOnScrollView = NO;
        self.scrollView.userInteractionEnabled = YES;
    });
}

- (void)didTagScollViewView:(UITapGestureRecognizer *)gesture {    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        if (!self.detectedDoubleTapOnScrollView)
            [self.delegate userTappedDetailImageItemView:self];
    });
}

#pragma mark - UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self saveImageInBackground:self.imageView.image];
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
    if (self.imageView.image)
        return self.imageView;
    else
        return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

@end
