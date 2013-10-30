//
//  WTOAViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOAViewController.h"
#import "WTResourceFactory.h"

@interface WTOAViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *oaWebView;
@property (nonatomic, weak) IBOutlet UIView *controlBar;

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
    [self configureNavigationBar];
    [self configureWebView];
    [self configureControlBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Assistant", nil) target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"OA System", nil)];
}

- (void)configureWebView {
    NSURL *oaURL = [NSURL URLWithString:@"http://wapoa.tongji.edu.cn/keryec/indexmb.nsf/gotoserver?openagent"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:oaURL];
    [self.oaWebView loadRequest:requestObj];
}

- (void)configureControlBar {
    self.controlBar.frame = CGRectMake(0, self.oaWebView.frame.size.height, 320, 50);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"WTWebViewControlBarBackButton"];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self.oaWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(70, 10, 20, 20);
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *forwardButtonImage = [UIImage imageNamed:@"WTWebViewControlBarForwardButton"];
    [forwardButton setBackgroundImage:forwardButtonImage forState:UIControlStateNormal];
    [forwardButton addTarget:self.oaWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.frame = CGRectMake(150, 10, 20, 20);
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *reloadButtonImage = [UIImage imageNamed:@"WTWebViewControlBarReloadButton"];
    [reloadButton setBackgroundImage:reloadButtonImage forState:UIControlStateNormal];
    [reloadButton addTarget:self.oaWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.frame = CGRectMake(230, 10, 20, 20);
    
    [self.controlBar addSubview:backButton];
    [self.controlBar addSubview:forwardButton];
    [self.controlBar addSubview:reloadButton];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
