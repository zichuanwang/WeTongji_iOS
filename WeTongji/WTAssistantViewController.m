//
//  WTAssistantViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTAssistantViewController.h"
#import "WTResourceFactory.h"
#import "WTOAViewController.h"
#import "WTLibraryViewController.h"
#import "WTYellowPageViewController.h"
#import "WTRouteViewController.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTRootTabBarController.h"
#import "UIApplication+WTAddition.h"
#import "UIImage+ScreenShoot.h"
#import "WTYibanViewController.h"

@interface WTAssistantViewController ()

@property (nonatomic, strong) UIImageView *screenShootImageView;
@property (nonatomic, strong) UIView *screenShootContainerView;

@end

@implementation WTAssistantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    
//    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(hanldeCurrentUserDidChangeNotification:) target:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.screenShootContainerView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIView *)screenShootContainerView {
    if (!_screenShootContainerView) {
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
    if (!_screenShootImageView) {
        _screenShootImageView = [[UIImageView alloc] initWithImage:[UIImage screenShoot]];
        [_screenShootImageView resetSize:[UIScreen mainScreen].bounds.size];
    }
    return _screenShootImageView;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureNavigationBar];
    [self configureAssistantButton];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Assistant", nil)];
}

- (void)configureAssistantButton {
    for (int i = 0; i < 5; i++) {
        UIButton *assistantButton = [UIButton buttonWithType:UIButtonTypeCustom];
        assistantButton.tag = i;
        assistantButton.frame = CGRectMake(5 + (i % 2) * 155, 5 + (i >= 2) * 155, 155, 155);
        [assistantButton addTarget:self action:@selector(didClickAssistantButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
        switch (i) {
            case WTAssistantButtonCategoryOA: {
                normalStateImage = [UIImage imageNamed:@"WTAssistantOA"];
                selectStateImage = [UIImage imageNamed:@"WTAssistantOAHl"];
                break;
            }
            case WTAssistantButtonCategoryLibrary: {
                normalStateImage = [UIImage imageNamed:@"WTAssistantLibrary"];
                selectStateImage = [UIImage imageNamed:@"WTAssistantLibraryHl"];
                break;
            }
            case WTAssistantButtonCategoryYellowPage: {
                normalStateImage = [UIImage imageNamed:@"WTAssistantYellowPage"];
                selectStateImage = [UIImage imageNamed:@"WTAssistantYellowPageHl"];
                break;
            }
            case WTAssistantButtonCategoryRoute: {
                normalStateImage = [UIImage imageNamed:@"WTAssistantRoute"];
                selectStateImage = [UIImage imageNamed:@"WTAssistantRouteHl"];
                break;
            }
            case WTAssistantButtonCategoryYiban: {
                normalStateImage = [UIImage imageNamed:@"WTAssistantYiban"];
                selectStateImage = [UIImage imageNamed:@"WTAssistantYibanHl"];
                
                [assistantButton resetWidth:155 * 2 + 5];
                [assistantButton resetOriginXByOffset:-2];
                [assistantButton resetOriginYByOffset:155];
                break;
            }

            default:
                break;
        }
        [assistantButton setImage:normalStateImage forState:UIControlStateNormal];
        [assistantButton setImage:selectStateImage forState:UIControlStateHighlighted];
        
        [self.scrollView addSubview:assistantButton];
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(assistantButton.frame))];
    }
}

- (void)hideTabBar {
    WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
    [tabBarVC hideTabBar];
}

- (void)showTabBar {
    WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
    [tabBarVC showTabBar];
}

#pragma mark - Actions
- (void)didClickAssistantButton:(UIButton *)button {
    [self.view addSubview:self.screenShootContainerView];

    NSLog(@"click button %d", button.tag);
    switch (button.tag) {
        case WTAssistantButtonCategoryOA: {
            NSLog(@"OA");
            WTOAViewController *vc = [[WTOAViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WTAssistantButtonCategoryLibrary: {
            NSLog(@"Library");
            WTLibraryViewController *vc = [[WTLibraryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WTAssistantButtonCategoryYellowPage: {
            NSLog(@"Yellow Page");
            WTYellowPageViewController *vc = [[WTYellowPageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WTAssistantButtonCategoryRoute: {
            NSLog(@"Route");
            WTRouteViewController *vc = [[WTRouteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WTAssistantButtonCategoryYiban: {
            NSLog(@"Yi Ban");
            WTYibanViewController *vc = [[WTYibanViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    return nil;
}

@end
