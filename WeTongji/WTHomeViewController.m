//
//  WTHomeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTBannerView.h"
#import "UIApplication+WTAddition.h"
#import "WTNewsViewController.h"
#import "WTActivityViewController.h"
#import "Event+Addition.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTBannerView *bannerView;
@property (nonatomic, strong) WTHomeNowContainerView *nowContainerView;

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
    [self configureBanner];
    [self configureNowView];
    
    [self configureNewsSelect];
    [self configureFeaturedSelect];
    [self configureActivitySelect];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 670);
    self.scrollView.scrollsToTop = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView resetHeight:self.view.frame.size.height];
    [self updateNowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNewsSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryNews itemInfoArray:@[@"", @"", @""]];
    containerView.delegate = self;
    [containerView resetOrigin:CGPointMake(0, 240)];
    [self.scrollView addSubview:containerView];
}

- (void)configureFeaturedSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryFeatured itemInfoArray:@[@"", @"", @""]];
    containerView.delegate = self;
    [containerView resetOrigin:CGPointMake(0, 380)];
    [self.scrollView addSubview:containerView];
}

- (void)configureActivitySelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryActivity itemInfoArray:@[@"", @"", @""]];
    containerView.delegate = self;
    [containerView resetOrigin:CGPointMake(0, 520)];
    [self.scrollView addSubview:containerView];
}

- (void)configureBanner {
    self.bannerView = [WTBannerView createBannerView];
    [self.bannerView configureTestBanner];
    [self.bannerView resetOrigin:CGPointZero];
    [self.scrollView addSubview:self.bannerView];
}

- (void)configureNavigationBar {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
}

- (void)configureNowView {
    WTHomeNowContainerView *nowContainerView = [WTHomeNowContainerView createHomeNowContainerView];
    [self.scrollView insertSubview:nowContainerView belowSubview:self.bannerView];
    [nowContainerView resetOriginY:self.bannerView.frame.size.height];
    self.nowContainerView = nowContainerView;
    [self updateNowView];
}

- (void)updateNowView {
    [self.nowContainerView configureNowContainerViewWithEvents:[Event getTodayEvents]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewOffsetY = scrollView.contentOffset.y;
    scrollViewOffsetY = scrollViewOffsetY < 0 ? 0 : scrollViewOffsetY;
    [self.bannerView configureBannerViewHeight:-scrollView.contentOffset.y + BANNER_VIEW_ORIGINAL_HIEHGT];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.bannerView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        self.bannerView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.bannerView.userInteractionEnabled = YES;
}

#pragma mark - Actions

- (IBAction)didClickShowNowTabButton:(UIButton *)sender {
    WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
    [tabBarVC clickTabWithName:WTRootTabBarViewControllerNow];
}

#pragma mark - WTHomeSelectContainerViewDelegate

- (void)homeSelectContainerViewDidClickSeeAllButton:(WTHomeSelectContainerView *)containerView {
    
    switch (containerView.category) {
        case WTHomeSelectContainerViewCategoryNews:
            [Flurry logEvent:@"Check All News" timed:YES];
            [self.navigationController pushViewController:[[WTNewsViewController alloc] init] animated:YES];
            break;
            
        case WTHomeSelectContainerViewCategoryActivity:
        {
            [Flurry logEvent:@"Check All Activities" timed:YES];
            [self.navigationController pushViewController:[[WTActivityViewController alloc] init] animated:YES];
        }
            break;
            
        case WTHomeSelectContainerViewCategoryFeatured:
            //TODO
            break;
            
        default:
            break;
    }
}

@end
