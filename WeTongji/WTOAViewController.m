//
//  WTOAViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOAViewController.h"
#import "WTResourceFactory.h"
#import "WTRootTabBarController.h"
#import "UIApplication+WTAddition.h"

@interface WTOAViewController ()

@property (nonatomic, strong) UIWebView *oaWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *controlBarBgImageView;
@property (nonatomic, strong) NSMutableArray *webviewControlButtonArray;

@end

@implementation WTOAViewController

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
    [self.view resetHeight:[[UIScreen mainScreen] bounds].size.height - 20];
    [self configureNavigationBar];
    [self configureWebView];
    [self configureControlBar];
    [self configureActivityIndicator];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
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
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"OA System", nil)];
}

- (void)configureWebView {
    self.oaWebView = [[UIWebView alloc] init];
    self.oaWebView.backgroundColor = [UIColor clearColor];
    self.oaWebView.scrollView.backgroundColor = [UIColor clearColor];
    [self.oaWebView setDelegate:self];
    [self.oaWebView setOpaque:NO];
    self.oaWebView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 40);
    
    NSURL *oaURL = [NSURL URLWithString:@"http://wapoa.tongji.edu.cn/keryec/indexmb.nsf/gotoserver?openagent"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:oaURL];
    [self.oaWebView loadRequest:requestObj];
    [self.oaWebView setContentMode:UIViewContentModeScaleAspectFill];

    [self.view addSubview:self.oaWebView];
}

- (void)configureControlBar {
    UIImage *controlBarBgImage = [UIImage imageNamed:@"WTWebViewControlBar"];
    self.controlBarBgImageView = [[UIImageView alloc] initWithImage:controlBarBgImage];
    [self.controlBarBgImageView resetOriginY:self.oaWebView.frame.size.height];
    self.controlBarBgImageView.userInteractionEnabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"WTWebViewControlBarBackButton"];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self.oaWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(50, 10, 20, 20);
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *forwardButtonImage = [UIImage imageNamed:@"WTWebViewControlBarForwardButton"];
    [forwardButton setBackgroundImage:forwardButtonImage forState:UIControlStateNormal];
    [forwardButton addTarget:self.oaWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.frame = CGRectMake(150, 10, 20, 20);
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *reloadButtonImage = [UIImage imageNamed:@"WTWebViewControlBarReloadButton"];
    [reloadButton setBackgroundImage:reloadButtonImage forState:UIControlStateNormal];
    [reloadButton addTarget:self.oaWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.frame = CGRectMake(250, 10, 20, 20);
    
    [self.controlBarBgImageView addSubview:backButton];
    [self.controlBarBgImageView addSubview:forwardButton];
    [self.controlBarBgImageView addSubview:reloadButton];
    [self.view addSubview:self.controlBarBgImageView];
    
    self.webviewControlButtonArray = [[NSMutableArray alloc] initWithObjects:backButton, forwardButton, reloadButton, nil];
}

- (void)configureActivityIndicator {
    UIButton *reloadButton = [self.webviewControlButtonArray lastObject];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setCenter:reloadButton.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.controlBarBgImageView insertSubview:self.activityIndicator belowSubview:reloadButton];
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

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[self.webviewControlButtonArray lastObject] setHidden:YES];
    [[self.webviewControlButtonArray lastObject] setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[self.webviewControlButtonArray lastObject] setHidden:NO];
    [[self.webviewControlButtonArray lastObject] setUserInteractionEnabled:YES];
    [self.activityIndicator stopAnimating];
}

@end
