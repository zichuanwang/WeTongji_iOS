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

@interface WTAssistantViewController ()

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
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(hanldeCurrentUserDidChangeNotification:) target:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification handler

- (void)hanldeCurrentUserDidChangeNotification:(NSNotification *)notification {
    [super hanldeCurrentUserDidChangeNotification:notification];
    if ([WTCoreDataManager sharedManager].currentUser) {
        [self configureUI];
    }
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
    for (int i = 0; i < 4; i++) {
        UIButton *assistantButton = [UIButton buttonWithType:UIButtonTypeCustom];
        assistantButton.tag = i;
        assistantButton.frame = CGRectMake(5 + (i % 2) * 155, 5 + (i >= 2) * 155, 155, 155);
        [assistantButton addTarget:self action:@selector(didClickAssistantButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *assistantButtonImage = nil;
        
        switch (i) {
            case WTAssistantButtonCategoryOA: {
                assistantButtonImage = [UIImage imageNamed:@"WTAssistantOA"];
                break;
            }
            case WTAssistantButtonCategoryLibrary: {
                assistantButtonImage = [UIImage imageNamed:@"WTAssistantLibrary"];
                break;
            }
            case WTAssistantButtonCategoryYellowPage: {
                assistantButtonImage = [UIImage imageNamed:@"WTAssistantYellowPage"];
                break;
            }
            case WTAssistantButtonCategoryRoute: {
                assistantButtonImage = [UIImage imageNamed:@"WTAssistantRoute"];
                break;
            }
            default:
                break;
        }
        [assistantButton setImage:assistantButtonImage forState:UIControlStateNormal];
        
        [self.view addSubview:assistantButton];
    }
}

- (void)showTabBar {
    WTRootTabBarController *tabBarController = (WTRootTabBarController *)self.tabBarController;
    [tabBarController showTabBar];
}

#pragma mark - Actions

- (void)didClickAssistantButton:(UIButton *)button {
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
        default:
            break;
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    return nil;
}

@end
