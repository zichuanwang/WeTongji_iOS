//
//  WTLibraryViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLibraryViewController.h"
#import "WTResourceFactory.h"
#import "WTRootTabBarController.h"
#import "UIApplication+WTAddition.h"

@interface WTLibraryViewController ()

@property (nonatomic, strong) UIWebView *libraryWebView;
@property (nonatomic, strong) UIImageView *controlBarBgImageView;

@end

@implementation WTLibraryViewController

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
    [self.view resetHeight:[[UIScreen mainScreen] bounds].size.height - 20];
    [self configureNavigationBar];
    [self configureWebView];
    [self configureControlBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods to overwrite

- (BOOL)showMoreNavigationBarButton {
    return NO;
}

- (BOOL)showLikeNavigationBarButton {
    return NO;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Assistant", nil) target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"My Library", nil)];
}

- (void)configureWebView {
    self.libraryWebView = [[UIWebView alloc] init];
    NSURL *libraryURL = [NSURL URLWithString:@"http://www.lib.tongji.edu.cn/m/index.action"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:libraryURL];
    [self.libraryWebView loadRequest:requestObj];
    [self.libraryWebView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.libraryWebView.backgroundColor = [UIColor clearColor];
    self.libraryWebView.scrollView.backgroundColor = [UIColor clearColor];
    
    self.libraryWebView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 40);
    [self.view addSubview:self.libraryWebView];
}

- (void)configureControlBar {
    UIImage *controlBarBgImage = [UIImage imageNamed:@"WTWebViewControlBar"];
    self.controlBarBgImageView = [[UIImageView alloc] initWithImage:controlBarBgImage];
    [self.controlBarBgImageView resetOriginY:self.libraryWebView.frame.size.height];
    self.controlBarBgImageView.userInteractionEnabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"WTWebViewControlBarBackButton"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self.libraryWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(50, 10, 20, 20);
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *forwardButtonImage = [UIImage imageNamed:@"WTWebViewControlBarForwardButton"];
    [forwardButton setImage:forwardButtonImage forState:UIControlStateNormal];
    [forwardButton addTarget:self.libraryWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.frame = CGRectMake(150, 10, 20, 20);
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *reloadButtonImage = [UIImage imageNamed:@"WTWebViewControlBarReloadButton"];
    [reloadButton setImage:reloadButtonImage forState:UIControlStateNormal];
    [reloadButton addTarget:self.libraryWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.frame = CGRectMake(250, 10, 20, 20);
    
    [self.controlBarBgImageView addSubview:backButton];
    [self.controlBarBgImageView addSubview:forwardButton];
    [self.controlBarBgImageView addSubview:reloadButton];
    [self.view addSubview:self.controlBarBgImageView];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
