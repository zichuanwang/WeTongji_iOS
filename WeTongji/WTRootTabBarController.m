//
//  WTRootTabBarController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTRootTabBarController.h"

@interface WTRootTabBarController ()

@property (nonatomic, strong) UIImageView *tabBarBgImageView;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation WTRootTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showCustomTabBar];
    [self adjustBuiltInTabBar];
    
    [self clickTabWithName:WTRootTabBarViewControllerHome];
    self.selectedViewController.view.superview.clipsToBounds = NO;
}

#pragma mark - UI methods

- (void)addCustomTabBarBg {
    UIImage *bgImage = [UIImage imageNamed:@"WTTabBarBg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    bgImageView.frame = CGRectMake(0, screenSize.height - bgImage.size.height, screenSize.width, bgImage.size.height);
    
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.tabBarBgImageView = bgImageView;
    self.tabBarBgImageView.userInteractionEnabled = YES;
    
    UIImageView *bottomLeftCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerBottomLeft"]];
    UIImageView *bottomRightCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerBottomRight"]];
    
    UIImageView *tabBarBottomLeftCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerBottomLeft"]];
    UIImageView *tabBarBottomRightCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTCornerBottomRight"]];
    
    [bottomLeftCornerImageView resetOrigin:CGPointMake(0, 1 - bottomLeftCornerImageView.frame.size.height)];
    [bottomRightCornerImageView resetOrigin:CGPointMake(screenSize.width - bottomRightCornerImageView.frame.size.width, 1 - bottomLeftCornerImageView.frame.size.height)];
    
    [tabBarBottomLeftCornerImageView resetOrigin:CGPointMake(0, bgImageView.frame.size.height - tabBarBottomLeftCornerImageView.frame.size.height)];
    [tabBarBottomRightCornerImageView resetOrigin:CGPointMake(screenSize.width - tabBarBottomRightCornerImageView.frame.size.width, bgImageView.frame.size.height - bottomLeftCornerImageView.frame.size.height)];
    
    [bgImageView addSubview:bottomLeftCornerImageView];
    [bgImageView addSubview:bottomRightCornerImageView];
    [bgImageView addSubview:tabBarBottomLeftCornerImageView];
    [bgImageView addSubview:tabBarBottomRightCornerImageView];
    [self.view addSubview:bgImageView];
}

- (void)addCustomTabBarButtons {
    int viewCount = self.viewControllers.count;
	self.buttonArray = [NSMutableArray arrayWithCapacity:viewCount];
	for (int i = 0; i < viewCount; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.tag = i;
		[btn addTarget:self action:@selector(didClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(64 * i, 0, 64, self.tabBarBgImageView.frame.size.height + 4);
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
		switch (i) {
            case 0: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonHome"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonHomeHl"];
                break;
            }
            case 1: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonNow"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonNowHl"];
                break;
            }
            case 2: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearch"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearchHl"];
                break;
            }
            case 3: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoard"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoardHl"];
                break;
            }
            case 4: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonMe"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonMeHl"];
                break;
            }
        }
        [btn setImage:normalStateImage forState:UIControlStateNormal];
        [btn setImage:selectStateImage forState:UIControlStateSelected];
        
		[self.buttonArray addObject:btn];
		[self.tabBarBgImageView addSubview:btn];
	}
}

- (void)setBuildInTabBarHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view resetOriginY:screenSize.height - height];
            [view resetHeight:height];
        } else if(view != self.tabBarBgImageView) {
            [view resetHeight:screenSize.height - height];
        }
    }
}

- (void)adjustBuiltInTabBar {
    self.tabBar.hidden = YES;
    [self setBuildInTabBarHeight:self.tabBarBgImageView.frame.size.height - 1];
}

- (void)showCustomTabBar {
    [self addCustomTabBarBg];
    [self addCustomTabBarButtons];
    ((UIButton *)self.buttonArray[0]).selected = YES;
}

#pragma mark - Public methods

- (void)clickTabWithName:(WTRootTabBarViewControllerName)name {
    [self didClickTabBarButton:self.buttonArray[name]];
}

- (void)hideTabBar {
    [self setBuildInTabBarHeight:0];
    self.tabBarBgImageView.hidden = YES;
}

- (void)showTabBar {
    [self adjustBuiltInTabBar];
    self.tabBarBgImageView.hidden = NO;
}

#pragma mark - Actions 

- (void)didClickTabBarButton:(UIButton *)button {
    self.selectedIndex = button.tag;
    
    // |button.tag == 4| 时似乎系统有bug，用下面的方法折衷
    if (button.tag == 4) {
        self.selectedViewController = [self.viewControllers lastObject];
    }
    
    for (UIButton* btn in self.buttonArray) {
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    
    button.selected = YES;
    button.userInteractionEnabled = NO;
}

@end