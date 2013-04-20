//
//  WTImageViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailImageViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTDetailImageItemView.h"

@interface WTDetailImageViewController () <WTDetailImageItemViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) NSArray *imageURLArray;
@property (nonatomic, assign) NSUInteger initPage;

@end

@implementation WTDetailImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showDetailImageViewWithImageURLString:(NSString *)imageURLString {
    [WTDetailImageViewController showDetailImageViewWithImageURLArray:@[imageURLString] currentPage:0];
}

+ (void)showDetailImageViewWithImageURLArray:(NSArray *)imageURLArray
                                 currentPage:(NSUInteger)currentPage {
    WTDetailImageViewController *vc = [WTDetailImageViewController createDetailImageViewControllerWithImageURLArray:imageURLArray];
    vc.initPage = currentPage;
    [vc show];
}

+ (WTDetailImageViewController *)createDetailImageViewControllerWithImageURLArray:(NSArray *)imageURLArray {
    WTDetailImageViewController *result = [[WTDetailImageViewController alloc] init];
    result.itemViewArray = [NSMutableArray arrayWithCapacity:4];
    result.imageURLArray = imageURLArray;
    return result;
}

#pragma mark - UI methods

- (void)show {
    [UIApplication presentKeyWindowViewController:self animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 1;
    }];
}

- (void)dismissView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIApplication dismissKeyWindowViewControllerAnimated:NO];
    }];
}

#define IMAGE_ITEM_VIEW_SPACING 20.0f

- (void)configureView {
    for (NSString *imageURLString in self.imageURLArray) {
        WTDetailImageItemView *itemView = [WTDetailImageItemView createDetailItemViewWithImageURLString:imageURLString
                                                                                               delegate:self];
        [itemView resetSize:self.view.frame.size];
        [itemView resetOriginX:self.scrollView.frame.size.width * self.itemViewArray.count];
        [self.scrollView addSubview:itemView];
        
        NSLog(@"item view frame:%@", NSStringFromCGRect(itemView.frame));
        
        [self.itemViewArray addObject:itemView];
    }
    self.pageControl.numberOfPages = self.imageURLArray.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.imageURLArray.count, self.scrollView.frame.size.height);
    
    self.pageControl.currentPage = self.initPage;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width * self.initPage, 0);
}

- (void)updatePageControl {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if (self.pageControl.currentPage != currentPage) {
        WTDetailImageItemView *itemView = self.itemViewArray[self.pageControl.currentPage];
        itemView.scrollView.zoomScale = 1.0f;
        
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark - WTDetailImageItemViewDelegate

- (void)userTappedDetailImageItemView:(WTDetailImageItemView *)itemView {
    [self dismissView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self updatePageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl];
}

@end