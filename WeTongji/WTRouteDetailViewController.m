//
//  WTRouteDetailViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRouteDetailViewController.h"
#import "WTResourceFactory.h"
#import "WTRouteImageView.h"
#import "WTRouteDetailView.h"

@interface WTRouteDetailViewController ()

@property (nonatomic, strong) NSDictionary *routeInfo;

@property (nonatomic, strong) WTRouteImageView *routeImageView;
@property (nonatomic, strong) WTRouteDetailView *routeDetailView;

@end

@implementation WTRouteDetailViewController

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
    [self configureNavigationBar];
    [self configureRouteImageView];
    [self configureRouteDetailView];
    [self configureScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTRouteDetailViewController *)createDetailViewControllerWithRouteInfo:(NSDictionary *)routeInfo {
    WTRouteDetailViewController *result = [[WTRouteDetailViewController alloc] init];
    result.routeInfo = routeInfo;
    return result;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Traffic Guide", nil) target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Detail", nil)];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.routeDetailView.frame.origin.y + self.routeDetailView.frame.size.height);
}

- (void)configureRouteImageView {
    [self.routeImageView removeFromSuperview];
    WTRouteImageView *routeImageView = [WTRouteImageView createRouteImageViewWithImageNamge:self.routeInfo];
    [self.scrollView addSubview:routeImageView];
    self.routeImageView = routeImageView;
}

- (void)configureRouteDetailView {
    [self.routeDetailView removeFromSuperview];
    WTRouteDetailView *routeDetailView = [WTRouteDetailView createRouteDetailViewWithRouteInfo:self.routeInfo];
    [routeDetailView resetOriginY:self.routeImageView.frame.size.height];
    [self.scrollView addSubview:routeDetailView];
    self.routeDetailView = routeDetailView;
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
