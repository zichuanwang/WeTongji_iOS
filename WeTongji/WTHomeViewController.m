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
#import "WTActivityDetailViewController.h"
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Star+Addition.h"
#import "Object+Addtion.h"
#import "WTNewsDetailViewController.h"
#import "WTCategoryActivityViewController.h"
#import "WTCategoryNewsViewController.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTBannerContainerView *bannerContainerView;
@property (nonatomic, strong) WTHomeNowContainerView *nowContainerView;
@property (nonatomic, strong) NSMutableArray *homeSelectViewArray;

@property (nonatomic, assign) BOOL shouldUpdateHomeSelectViews;
@property (nonatomic, assign) BOOL shouldLoadHomeSelectedItems;
@property (nonatomic, strong) NSTimer *loadHomeSelectedItemsTimer;

@end

@implementation WTHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shouldUpdateHomeSelectViews = YES;
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
    
    [self setUpLoadHomeSelectedItemsTimer];
    
    self.scrollView.scrollsToTop = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.scrollView resetHeight:self.view.frame.size.height];
    [self updateNowView];
    [self updateHomeSelectViews];
    [self updateScrollView];
    
    if (self.shouldLoadHomeSelectedItems) {
        [self loadHomeSelectedItems];
        self.shouldLoadHomeSelectedItems = NO;
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
    self.loadHomeSelectedItemsTimer = [NSTimer scheduledTimerWithTimeInterval:10 * 60
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
        
        [Object clearAllHomeSelectedObjects];
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *activityInfoArray = resultDict[@"Activities"];
        for (NSDictionary *infoDict in activityInfoArray) {
            Activity *activity = [Activity insertActivity:infoDict];
            activity.homeSelected = @(YES);
        }
        
        NSArray *newsInfoArray = resultDict[@"Information"];
        for (NSDictionary *infoDict in newsInfoArray) {
            News *news = [News insertNews:infoDict];
            news.homeSelected = @(YES);
        }
        
        NSObject *starInfoObject = resultDict[@"Person"];
        
        if ([starInfoObject isKindOfClass:[NSArray class]]) {
            NSArray *starInfoArray = (NSArray *)starInfoObject;
            for (NSDictionary *infoDict in starInfoArray) {
                Star *star = [Star insertStar:infoDict];
                star.homeSelected = @(YES);
            }
        } else if ([starInfoObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *starInfoDict = (NSDictionary *)starInfoObject;
            Star *star = [Star insertStar:starInfoDict];
            star.homeSelected = @(YES);
        }
        self.shouldUpdateHomeSelectViews = YES;
        [self updateHomeSelectViews];
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get home recommendation failure:%@", error.localizedDescription);
        self.shouldLoadHomeSelectedItems = YES;
        
    }];
    [request getHomeRecommendation];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    // self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
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
    [self updateHomeSelectViews];
    [self configureScrollView];
}

- (void)updateHomeSelectViews {
    NSInteger index = 0;
    for (WTHomeSelectContainerView *homeSelectContainerView in self.homeSelectViewArray) {
        [homeSelectContainerView resetOrigin:CGPointMake(0, self.nowContainerView.frame.size
                                               .height + self.nowContainerView.frame.origin.y + homeSelectContainerView.frame.size.height * index)];
        [homeSelectContainerView updateItemViews];
        index++;
    }
    
    if (!self.shouldUpdateHomeSelectViews)
        return;
    
    WTHomeSelectContainerView *activitySelectContainerView = self.homeSelectViewArray[0];
    [activitySelectContainerView updateItemInfoArray:[Activity getHomeSelectActivityArray]];

    WTHomeSelectContainerView *newsSelectContainerView = self.homeSelectViewArray[1];
    [newsSelectContainerView updateItemInfoArray:[News getHomeSelectNewsArray]];
    
    WTHomeSelectContainerView *featuredSelectContainerView = self.homeSelectViewArray[2];
    [featuredSelectContainerView updateItemInfoArray:[Star getHomeSelectStarArray]];
    
    self.shouldUpdateHomeSelectViews = NO;
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

- (void)updateNowView {
    NSArray *events = [Event getTodayEvents];
    [self.nowContainerView configureNowContainerViewWithEvents:events];
    if (!events) {
        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height - self.nowContainerView.frame.size.height];
    } else {
        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height];
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
        WTNewsDetailViewController *vc = [WTNewsDetailViewController createNewsDetailViewControllerWithNews:(News *)modelObject backBarButtonText:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)homeSelectContainerView:(WTHomeSelectContainerView *)containerView
     didClickShowCategoryButton:(UIButton *)sender
                    modelObject:(Object *)modelObject {
    if ([modelObject isKindOfClass:[Activity class]]) {
        Activity *activity = (Activity *)modelObject;
        WTCategoryActivityViewController *vc = [WTCategoryActivityViewController createViewControllerWithActivityCategory:activity.category];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[News class]]) {
        News *news = (News *)modelObject;
        WTCategoryNewsViewController *vc = [WTCategoryNewsViewController createViewControllerWithNewsCategory:news.category];
        [self.navigationController pushViewController:vc animated:YES];
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
