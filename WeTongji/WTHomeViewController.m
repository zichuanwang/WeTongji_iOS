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
#import "Event+Addition.h"
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Star+Addition.h"
#import "Course+Addition.h"
#import "Organization+Addition.h"
#import "Object+Addition.h"
#import "Organization+Addition.h"
#import "Advertisement+Addition.h"
#import "WTNewsDetailViewController.h"
#import "WTActivityDetailViewController.h"
#import "WTStarDetailViewController.h"
#import "WTOrganizationDetailViewController.h"
#import "WTCourseDetialViewController.h"
#import "WTNewsViewController.h"
#import "WTActivityViewController.h"
#import "WTStarViewController.h"
#import "WTHomeSelectContainerView.h"
#import "WTHomeNowView.h"

@interface WTHomeViewController () <WTHomeSelectContainerViewDelegate, WTHomeNowContainerViewDelegate, WTBannerContainerViewDelegate>

@property (nonatomic, strong) WTBannerContainerView *bannerContainerView;
@property (nonatomic, strong) WTHomeNowContainerView *nowContainerView;
@property (nonatomic, strong) NSMutableArray *homeSelectViewArray;

@property (nonatomic, assign) BOOL shouldLoadHomeItems;
@property (nonatomic, strong) NSTimer *loadHomeItemsTimer;

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
    [self configureBannerView];
    [self configureNowView];
    [self configureHomeSelectViews];
    [self configureScrollView];
    
    [self setUpLoadHomeSelectedItemsTimer];
    
    self.scrollView.scrollsToTop = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.scrollView resetHeight:self.view.frame.size.height];
    
    [self updateBannerView];
    [self updateNowView];
    [self updateHomeSelectViews];
    [self updateScrollView];
    
    if (self.shouldLoadHomeItems) {
        [self loadHomeSelectedItems];
        self.shouldLoadHomeItems = NO;
    }
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

#pragma mark - Load data methods

- (void)setUpLoadHomeSelectedItemsTimer {
    // 设定 10 分钟刷新频率
    self.loadHomeItemsTimer = [NSTimer scheduledTimerWithTimeInterval:10 * 60
											  target:self
											selector:@selector(loadHomeSelectedItemsTimerFired:)
											userInfo:nil
											 repeats:YES];
    
    // 立即刷新一次
    [self loadHomeSelectedItems];
}

- (void)loadHomeSelectedItemsTimerFired:(NSTimer *)timer {
    [self loadHomeSelectedItems];
}

- (void)loadHomeSelectedItems {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Get home recommendation succuess:%@", responseObject);
        
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setScrollEnabled:YES];
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        
        // Refill home select views
        [Object setAllObjectsFreeFromHolder:[WTHomeSelectContainerView class]];
        
        NSArray *activityInfoArray = resultDict[@"Activities"];
        for (NSDictionary *infoDict in activityInfoArray) {
            Activity *activity = [Activity insertActivity:infoDict];
            [activity setObjectHeldByHolder:[WTHomeSelectContainerView class]];
        }
        
        NSArray *newsInfoArray = resultDict[@"Information"];
        for (NSDictionary *infoDict in newsInfoArray) {
            News *news = [News insertNews:infoDict];
            [news setObjectHeldByHolder:[WTHomeSelectContainerView class]];
        }
        
        NSObject *starInfoObject = resultDict[@"Person"];
        
        if ([starInfoObject isKindOfClass:[NSArray class]]) {
            NSArray *starInfoArray = (NSArray *)starInfoObject;
            for (NSDictionary *infoDict in starInfoArray) {
                Star *star = [Star insertStar:infoDict];
                [star setObjectHeldByHolder:[WTHomeSelectContainerView class]];
            }
        } else if ([starInfoObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *starInfoDict = (NSDictionary *)starInfoObject;
            Star *star = [Star insertStar:starInfoDict];
            [star setObjectHeldByHolder:[WTHomeSelectContainerView class]];
        }
        
        NSDictionary *newestOrgDict = resultDict[@"AccountNewest"];
        Organization *newestOrg = [Organization insertOrganization:newestOrgDict];
        [newestOrg setObjectHeldByHolder:[WTHomeSelectContainerView class]];
        
        NSDictionary *popularOrgDict = resultDict[@"AccountPopulor"];
        Organization *popularOrg = [Organization insertOrganization:popularOrgDict];
        [popularOrg setObjectHeldByHolder:[WTHomeSelectContainerView class]];
        
        [self fillHomeSelectViews];
        
        // Refill banner view
        [Object setAllObjectsFreeFromHolder:[WTBannerContainerView class]];
        
        NSDictionary *bannerActivityInfo = resultDict[@"BannerActivity"];
        if ([bannerActivityInfo isKindOfClass:[NSDictionary class]]) {
            Activity *bannerActivity = [Activity insertActivity:bannerActivityInfo];
            [bannerActivity setObjectHeldByHolder:[WTBannerContainerView class]];
        }
        
        NSDictionary *bannerNewsInfo = resultDict[@"BannerInformation"];
        if ([bannerNewsInfo isKindOfClass:[NSDictionary class]]) {
            News *bannerNews = [News insertNews:bannerNewsInfo];
            [bannerNews setObjectHeldByHolder:[WTBannerContainerView class]];
        }
        
        NSArray *bannerAdvertisementArray = resultDict[@"BannerAdvertisements"];
        for (NSDictionary *adInfo in bannerAdvertisementArray) {
            Advertisement *ad = [Advertisement insertAdvertisement:adInfo];
            [ad setObjectHeldByHolder:[WTBannerContainerView class]];
        }
        
        [self fillBannerView];
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get home recommendation failure:%@", error.localizedDescription);
        self.shouldLoadHomeItems = YES;
        
    }];
    [request getHomeRecommendation];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = NO;
    [self updateScrollView];
}

- (void)updateScrollView {
    UIView *bottomView = self.homeSelectViewArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
}

- (void)configureHomeSelectViews {
    [self configureActivitySelect];
    [self configureNewsSelect];
    [self configureFeaturedSelect];
    [self fillHomeSelectViews];
}

- (void)updateHomeSelectViews {
    NSInteger index = 0;
    for (WTHomeSelectContainerView *homeSelectContainerView in self.homeSelectViewArray) {
        [homeSelectContainerView resetOrigin:CGPointMake(0, self.nowContainerView.frame.size
                                               .height + self.nowContainerView.frame.origin.y + homeSelectContainerView.frame.size.height * index)];
        [homeSelectContainerView updateItemViews];
        index++;
    }
}

- (void)fillHomeSelectViews {
    WTHomeSelectContainerView *activitySelectContainerView = self.homeSelectViewArray[0];
    [activitySelectContainerView configureItemInfoArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Activity"]];
    
    WTHomeSelectContainerView *newsSelectContainerView = self.homeSelectViewArray[1];
    [newsSelectContainerView configureItemInfoArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"News"]];
    
    WTHomeSelectContainerView *featuredSelectContainerView = self.homeSelectViewArray[2];
    NSMutableArray *featurerSelectInfoArray = [NSMutableArray arrayWithArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Star"]];
    [featurerSelectInfoArray addObjectsFromArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Organization"]];
    [featuredSelectContainerView configureItemInfoArray:featurerSelectInfoArray];
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

- (void)configureBannerView {
    self.bannerContainerView = [WTBannerContainerView createBannerContainerView];
    [self.bannerContainerView resetOrigin:CGPointZero];
    self.bannerContainerView.delegate = self;
    [self.scrollView addSubview:self.bannerContainerView];
    [self fillBannerView];
}

- (void)fillBannerView {
    [self.bannerContainerView configureBannerWithObjectsArray:[Object getAllObjectsHeldByHolder:[WTBannerContainerView class] objectEntityName:@"Object"]];
}

- (void)updateBannerView {
    [self.bannerContainerView reloadItemImages];
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

- (void)updateNowView {
    NSArray *events = [Event getTodayEvents];
    [self.nowContainerView configureNowContainerViewWithEvents:events];
    if (!events) {
        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height - self.nowContainerView.frame.size.height];
    } else {
        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height];
    }
}

- (void)pushDetailViewControllerWithModelObject:(Object *)modelObject {
    if ([modelObject isKindOfClass:[Activity class]]) {
        WTActivityDetailViewController *vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[News class]]) {
        WTNewsDetailViewController *vc = [WTNewsDetailViewController createDetailViewControllerWithNews:(News *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[Organization class]]) {
        WTOrganizationDetailViewController *vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:(Organization *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if([modelObject isKindOfClass:[Star class]]) {
        WTStarDetailViewController *vc = [WTStarDetailViewController createDetailViewControllerWithStar:(Star *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[Advertisement class]]) {
        Advertisement *ad = (Advertisement *)modelObject;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.website]];
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
            [[NSUserDefaults standardUserDefaults] setNewsShowTypes:NewsShowTypesAll];
            [self.navigationController pushViewController:[[WTNewsViewController alloc] init] animated:YES];
            break;
            
        case WTHomeSelectContainerViewCategoryActivity:
        {
            [Flurry logEvent:@"Check All Activities" timed:YES];
            [[NSUserDefaults standardUserDefaults] setActivityShowTypes:ActivityShowTypesAll];
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
    [self pushDetailViewControllerWithModelObject:modelObject];
}

- (void)homeSelectContainerView:(WTHomeSelectContainerView *)containerView
     didClickShowCategoryButton:(UIButton *)sender
                    modelObject:(Object *)modelObject {
    if ([modelObject isKindOfClass:[Activity class]]) {
        Activity *activity = (Activity *)modelObject;
        [[NSUserDefaults standardUserDefaults] setActivityShowTypes:activity.category.integerValue];
        WTActivityViewController *vc = [[WTActivityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[News class]]) {
        News *news = (News *)modelObject;
        [[NSUserDefaults standardUserDefaults] setNewsShowTypes:news.category.integerValue];
        WTNewsViewController *vc = [[WTNewsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[Star class]]) {
        WTStarViewController *vc = [[WTStarViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - WTHomeNowContainerViewDelegate

- (void)homeNowContainerViewDidSelectEvent:(Event *)event {
    if ([event isKindOfClass:[Activity class]]) {
        WTActivityDetailViewController *vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)event backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([event isKindOfClass:[Course class]]) {
        WTCourseDetialViewController *vc = [WTCourseDetialViewController createCourseDetailViewControllerWithCourse:(Course *)event backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - WTBannerContainerViewDelegate

- (void)bannerContainerView:(WTBannerContainerView *)containerView
       didSelectModelObject:(Object *)modelObject {
    [self pushDetailViewControllerWithModelObject:modelObject];
}

@end
