//
//  WTHomeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTBannerView.h"
#import "OHAttributedLabel.h"
#import "WTHomeSelectContainerView.h"
#import "UIApplication+Addition.h"


@interface WTHomeViewController ()

@property (nonatomic, strong) WTBannerView *bannerView;

@end

@implementation WTHomeViewController

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
    [self configureBackgroung];
    [self configureBanner];
    [self configureNowPanel];
    
    [self configureNewsSelect];
    [self configureFeaturedSelect];
    [self configureActivitySelect];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 670);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNewsSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryNews itemInfoArray:@[@"", @"", @""]];
    [containerView resetOrigin:CGPointMake(0, 240)];
    [self.scrollView addSubview:containerView];
}

- (void)configureFeaturedSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryFeatured itemInfoArray:@[@"", @"", @""]];
    [containerView resetOrigin:CGPointMake(0, 380)];
    [self.scrollView addSubview:containerView];
}

- (void)configureActivitySelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryActivity itemInfoArray:@[@"", @"", @""]];
    [containerView resetOrigin:CGPointMake(0, 520)];
    [self.scrollView addSubview:containerView];
}

- (void)configureBanner {
    self.bannerView = [[[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil] lastObject];
    [self.bannerView resetOrigin:CGPointZero];
    [self.scrollView addSubview:self.bannerView];
}

- (void)configureBackgroung {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
}

- (void)configureNavigationBar {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

- (void)configureNowPanel {
    NSMutableAttributedString *text = [self.nowPanelFriendLabel.attributedText mutableCopy];
    [text setTextBold:YES range:NSMakeRange(0, 1)];
    self.nowPanelFriendLabel.attributedText = text;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark - Actions

- (IBAction)didClickShowNowTabButton:(UIButton *)sender {
    WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
    [tabBarVC clickTabWithName:WTRootTabBarViewControllerNow];
}

@end
