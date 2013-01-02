//
//  WTNavigationController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTRootNavigationController.h"
#import "WTRootTabBarController.h"
#import "UIApplication+Addition.h"
#import "UIImage+ScreenShoot.h"
#import "WTNotificationBarButton.h"

@interface WTRootNavigationController ()

@property (nonatomic, strong) UIViewController *innerModalViewController;

@property (nonatomic, strong) UIImageView *screenShootImageView;
@property (nonatomic, strong) UIView *screenShootContainerView;

@property (nonatomic, strong) UIImageView *navigationBarShadowImageView;

@end

@implementation WTRootNavigationController

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
	// Do any additional setup after loading the view.
    [self configureNavigationBar];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"WTNavigationBarBg"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarShadow"]];
    [shadowImageView resetOriginY:self.navigationBar.frame.size.height];
    [self.navigationBar insertSubview:shadowImageView atIndex:0];
    self.navigationBarShadowImageView = shadowImageView;
    
    [self showTopCorner];
}

- (void)showTopCorner {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView *topLeftCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopLeft"]];
    UIImageView *topRightCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerTopRight"]];
    [topLeftCornerImageView resetOrigin:CGPointMake(0, 0)];
    [topRightCornerImageView resetOrigin:CGPointMake(screenSize.width - topRightCornerImageView.frame.size.width, 0)];
    
    [self.navigationBar addSubview:topLeftCornerImageView];
    [self.navigationBar addSubview:topRightCornerImageView];
}

#pragma mark - Public methods

- (void)showInnerModalViewController:(UIViewController *)vc {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.screenShootContainerView resetOriginY:screenSize.height - self.screenShootContainerView.frame.size.height];
    
    WTRootTabBarController *tabBarVC = (WTRootTabBarController *)[UIApplication sharedApplication].rootViewController;
    [tabBarVC hideTabBar];
    
    [self.view insertSubview:self.screenShootContainerView belowSubview:self.navigationBarShadowImageView];
    
    [vc.view resetOriginY:-vc.view.frame.size.height];
    [self.topViewController.view addSubview:vc.view];
    
    self.innerModalViewController = vc;
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [vc.view resetOriginY:0];
        [self.screenShootContainerView resetOriginYByOffset:vc.view.frame.size.height];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)hideInnerModalViewController {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.innerModalViewController.view resetOriginY:-self.innerModalViewController.view.frame.size.height];
        [self.screenShootContainerView resetOriginYByOffset:-self.innerModalViewController.view.frame.size.height];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        
        [self.innerModalViewController.view removeFromSuperview];
        self.innerModalViewController = nil;
        
        // release screen shoot views
        [self.screenShootContainerView removeFromSuperview];
        self.screenShootImageView = nil;
        self.screenShootContainerView = nil;
        
        WTRootTabBarController *tabBarVC = (WTRootTabBarController *)[UIApplication sharedApplication].rootViewController;
        [tabBarVC showTabBar];
    }];
}

#pragma mark - Properties

- (UIView *)screenShootContainerView {
    if(!_screenShootContainerView) {
        _screenShootContainerView = [[UIView alloc] init];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [_screenShootContainerView resetSize:CGSizeMake(screenSize.width, screenSize.height - 44 - 20)];
        [self.screenShootImageView resetOriginY:0 - 44 - 20];
        
        [_screenShootContainerView addSubview:self.screenShootImageView];
        
        _screenShootContainerView.clipsToBounds = YES;
    }
    return _screenShootContainerView;
}

- (UIImageView *)screenShootImageView {
    if(!_screenShootImageView) {
        self.navigationBarShadowImageView.hidden = YES;
        _screenShootImageView = [[UIImageView alloc] initWithImage:[UIImage screenShoot]];
        self.navigationBarShadowImageView.hidden = NO;
        [_screenShootImageView resetSize:[UIScreen mainScreen].bounds.size];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreenShootImageView:)];
        [_screenShootImageView addGestureRecognizer:tap];
        _screenShootImageView.userInteractionEnabled = YES;
    }
    return _screenShootImageView;
}

#pragma mark - Handle gesture recognizer

- (void)didTapScreenShootImageView:(UIGestureRecognizer *)gestureRecognizer {
    [self hideInnerModalViewController];
    WTNotificationBarButton *notificationButton = (WTNotificationBarButton *)self.topViewController.navigationItem.leftBarButtonItem;
    notificationButton.selected = NO;
}

@end
