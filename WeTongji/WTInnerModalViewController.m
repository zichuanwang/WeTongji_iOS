//
//  WTNotificationModalViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerModalViewController.h"

@interface WTInnerModalViewController ()

@property (nonatomic, strong) UIImageView *waterflowImageViewA;
@property (nonatomic, strong) UIImageView *waterflowImageViewB;

@end

@implementation WTInnerModalViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.view resetHeight:screenSize.height - 20 - 44 - 41];
    
    UIImage *topShadowImage = [UIImage imageNamed:@"WTTopShadow"];
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithImage:topShadowImage];
    [topShadowImageView resetSize:CGSizeMake(screenSize.width, 6)];
    [topShadowImageView resetOrigin:CGPointMake(0, self.view.frame.size.height - 6)];
    
    [self.view addSubview:topShadowImageView];
}

- (void)viewWillLayoutSubviews {
    [self adjustWaterflowView];
}

- (void)viewDidLayoutSubviews {
    [self adjustWaterflowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIImageView *)createWaterflowImageViewWithFrame:(CGRect)frame {
    UIImageView *result = nil;
    result = [[UIImageView alloc] initWithFrame:frame];
    result.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    result.image = [[UIImage imageNamed:@"WTInnerModalViewBg"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return result;
}

#pragma mark - Properties

- (UIImageView *)waterflowImageViewA {
    if (!_waterflowImageViewA) {
        UIScrollView *scrollView = [self waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewA = [WTInnerModalViewController createWaterflowImageViewWithFrame:scrollView.frame];
            [scrollView insertSubview:_waterflowImageViewA atIndex:0];
        }
    }
    return _waterflowImageViewA;
}

- (UIImageView *)waterflowImageViewB {
    if (!_waterflowImageViewB) {
        UIScrollView *scrollView = [self waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewB = [WTInnerModalViewController createWaterflowImageViewWithFrame:scrollView.frame];
            [scrollView insertSubview:_waterflowImageViewB atIndex:0];
        }
    }
    return _waterflowImageViewB;
}

#pragma mark - Adjust waterflow view method

- (void)adjustWaterflowView {
    UIImageView *scrollBackgroundViewA = [self waterflowBackgroundViewA];
    UIImageView *scrollBackgroundViewB = [self waterflowBackgroundViewB];
    UIScrollView *scrollView = [self waterflowScrollView];
    
    if (!(scrollBackgroundViewA && scrollBackgroundViewB && scrollView))
        return;
    
    CGFloat top = scrollView.contentOffset.y;
    CGFloat bottom = top + scrollView.frame.size.height;
    
    UIView *upperView = nil;
    UIView *lowerView = nil;
    BOOL alignToTop = NO;
    
    if ((alignToTop = [WTInnerModalViewController view:scrollBackgroundViewA containsPoint:top]) || [WTInnerModalViewController view:scrollBackgroundViewB containsPoint:bottom]) {
        upperView = scrollBackgroundViewA;
        lowerView = scrollBackgroundViewB;
    } else if((alignToTop = [WTInnerModalViewController view:scrollBackgroundViewB containsPoint:top]) || [WTInnerModalViewController view:scrollBackgroundViewA containsPoint:bottom]) {
        upperView = scrollBackgroundViewB;
        lowerView = scrollBackgroundViewA;
    }
    
    if (upperView && lowerView) {
        if (alignToTop) {
            [lowerView resetOriginY:upperView.frame.origin.y + upperView.frame.size.height];
        } else {
            [upperView resetOriginY:lowerView.frame.origin.y - lowerView.frame.size.height];
        }
    } else {
        [scrollBackgroundViewA resetOriginY:top];
        [scrollBackgroundViewB resetOriginY:scrollBackgroundViewA.frame.origin.y + scrollBackgroundViewA.frame.size.height];
    }
}

+ (BOOL)view:(UIView *)view containsPoint:(CGFloat)originY {
    return view.frame.origin.y <= originY && view.frame.origin.y + view.frame.size.height > originY;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self adjustWaterflowView];
}

#pragma mark - WTWaterflowDecoratorDataSource

- (UIImageView *)waterflowBackgroundViewA {
    return self.waterflowImageViewA;
}

- (UIImageView *)waterflowBackgroundViewB {
    return self.waterflowImageViewB;
}

- (UIScrollView *)waterflowScrollView {
    return nil;
}
@end
