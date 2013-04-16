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
#import "WTActivityDetailViewController.h"
#import "Activity+Addition.h"
#import "News+Addition.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTBannerContainerView *bannerContainerView;
@property (nonatomic, strong) WTHomeNowContainerView *nowContainerView;
@property (nonatomic, strong) NSMutableArray *homeSelectViewArray;

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
    [self configureHomeSelectViews];
    
    
    self.scrollView.scrollsToTop = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollView resetHeight:self.view.frame.size.height];
    [self updateNowView];
    [self updateHomeSelectViews];
    [self updateScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSMutableArray *)homeSelectViewArray {
    if (!_homeSelectViewArray) {
        _homeSelectViewArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _homeSelectViewArray;
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    [self updateScrollView];
}

- (void)updateScrollView {
    UIView *bottomView = self.homeSelectViewArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
}

- (void)configureHomeSelectViews {
    [self configureActivitySelect];
    [self configureFeaturedSelect];
    [self configureNewsSelect];
    [self updateHomeSelectViews];
    [self configureScrollView];
}

- (void)updateHomeSelectViews {
    NSInteger index = 0;
    for (WTHomeSelectContainerView *homeSelectContainerView in self.homeSelectViewArray) {
        [homeSelectContainerView resetOrigin:CGPointMake(0, self.nowContainerView.frame.size
                                               .height + self.nowContainerView.frame.origin.y + homeSelectContainerView.frame.size.height * index)];
        index++;
    }
    WTHomeSelectContainerView *activitySelectContainerView = self.homeSelectViewArray[0];
    [activitySelectContainerView updateItemInfoArray:[Activity getHomeSelectActivityArray]];
    
    WTHomeSelectContainerView *featuredSelectContainerView = self.homeSelectViewArray[1];
    [featuredSelectContainerView updateItemInfoArray:@[@"", @"", @""]];
    
    WTHomeSelectContainerView *newsSelectContainerView = self.homeSelectViewArray[2];
    [newsSelectContainerView updateItemInfoArray:[News getHomeSelectNewsArray]];
    
}

- (void)configureNewsSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryNews];
    containerView.delegate = self;
    [self.homeSelectViewArray addObject:containerView];
    [self.scrollView addSubview:containerView];
}

- (void)configureFeaturedSelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryFeatured];
    containerView.delegate = self;
    [self.homeSelectViewArray addObject:containerView];
    [self.scrollView addSubview:containerView];
}

- (void)configureActivitySelect {
    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryActivity];
    containerView.delegate = self;
    [self.homeSelectViewArray addObject:containerView];
    [self.scrollView addSubview:containerView];
}

- (void)configureBanner {
    self.bannerContainerView = [WTBannerContainerView createBannerContainerView];
    [self.bannerContainerView configureTestBanner];
    [self.bannerContainerView resetOrigin:CGPointZero];
    [self.scrollView addSubview:self.bannerContainerView];
}

- (void)configureNavigationBar {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
}

- (void)configureNowView {
    WTHomeNowContainerView *nowContainerView = [WTHomeNowContainerView createHomeNowContainerViewWithDelegate:self];
    [self.scrollView insertSubview:nowContainerView belowSubview:self.bannerContainerView];
    [nowContainerView resetOriginY:self.bannerContainerView.frame.size.height];
    self.nowContainerView = nowContainerView;
    [self updateNowView];
}

#define BANNER_CONTAINER_VIEW_HEIGHT    130.0f

- (void)updateNowView {
    NSArray *events = [Event getTodayEvents];
    [self.nowContainerView configureNowContainerViewWithEvents:events];
    if (!events) {
        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.size.height - self.nowContainerView.frame.size.height];
    } else {
        [self.nowContainerView resetOriginY:BANNER_CONTAINER_VIEW_HEIGHT];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewOffsetY = scrollView.contentOffset.y;
    scrollViewOffsetY = scrollViewOffsetY < 0 ? 0 : scrollViewOffsetY;
    [self.bannerContainerView configureBannerContainerViewHeight:-scrollView.contentOffset.y + BANNER_VIEW_ORIGINAL_HIEHGT];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.bannerContainerView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        self.bannerContainerView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.bannerContainerView.userInteractionEnabled = YES;
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

- (void)homeSelectContainerView:(WTHomeSelectContainerView *)containerView
           didSelectModelObject:(Object *)modelObject {
    if ([modelObject isKindOfClass:[Activity class]]) {
        WTActivityDetailViewController *vc = [WTActivityDetailViewController createActivityDetailViewControllerWithActivity:(Activity *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[News class]]) {
        
    }
}

#pragma mark - WTHomeNowContainerViewDelegate

- (void)homeNowContainerViewDidSelectEvent:(Event *)event {
    if ([event isKindOfClass:[Activity class]]) {
        WTActivityDetailViewController *vc = [WTActivityDetailViewController createActivityDetailViewControllerWithActivity:(Activity *)event backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
