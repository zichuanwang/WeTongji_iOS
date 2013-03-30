//
//  WTActivityViewController.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/20/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTActivityViewController.h"
#import "OHAttributedLabel.h"
#import "WTResourceFactory.h"
#import "WTActivityCell.h"
#import "Activity+Addition.h"
#import "WTActivityDetailViewController.h"
#import "WTActivitySettingViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "NSString+WTAddition.h"

@interface WTActivityViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, readonly) UIButton *filterButton;

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nextPage = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    
    [self configureTableView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView resetHeight:self.view.frame.size.height];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIButton *)filterButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - Data load methods

- (void)clearAllData {
    [Activity clearAllActivites];
}

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get activities: %@", responseData);
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }
        
        if (success)
            success();
        
        NSArray *resultArray = resultDict[@"Activities"];
        for (NSDictionary *dict in resultArray) {
            [Activity insertActivity:dict];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get activities:%@", error.localizedDescription);
        
        if (failure)
            failure();
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getActivitiesInTypes:[userDefaults getActivityShowTypesArray] orderMethod:[userDefaults getActivityOrderMethod] smartOrder:[userDefaults getActivitySmartOrderProperty] showExpire:![userDefaults getActivityHidePastProperty] page:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Activities", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self
                                                                                          action:@selector(didClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:)];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickFilterButton:(UIButton *)sender {
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (sender.selected) {
        sender.selected = NO;
        
        WTActivitySettingViewController *vc = [[WTActivitySettingViewController alloc] init];
        vc.delegate = self;
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTActivityCell *activityCell = (WTActivityCell *)cell;
    
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *timeString = nil;
    ActivityOrderMethod orderMethod = [[NSUserDefaults standardUserDefaults] getActivityOrderMethod];
    if (orderMethod == ActivityOrderByPublishDate)
        timeString = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Published at", nil), [NSString yearMonthDayWeekTimeConvertFromDate:activity.created_at]];
    else
        timeString = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Start time", nil), [NSString yearMonthDayWeekTimeConvertFromDate:activity.begin_time]];
    
    [activityCell configureCellWithIndexPath:indexPath title:activity.title time:timeString location:activity.where imageURL:activity.image];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    [super insertCellAtIndexPath:indexPath];
    [self.dragToLoadDecorator scrollViewDidLoadNewCell];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ActivityOrderMethod orderMethod = [userDefaults getActivityOrderMethod];
    BOOL smartOrder = [userDefaults getActivitySmartOrderProperty];
    BOOL showExpire = ![userDefaults getActivityHidePastProperty];
    BOOL orderByAsc = ![WTRequest shouldActivityOrderByDesc:orderMethod smartOrder:smartOrder showExpire:showExpire];
    NSArray *descriptors = nil;
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"update_time" ascending:YES];
    
    switch (orderMethod) {
        case ActivityOrderByPublishDate:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        case ActivityOrderByPopularity:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"like_count" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        case ActivityOrderByStartDate:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"begin_time" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        default:
            break;
    }
    
    [request setSortDescriptors:descriptors];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTActivityCell";
}

- (NSString *)customSectionNameKeyPath {
    return nil;
}

- (void)fetchedResultsControllerDidPerformFetch:(NSFetchedResultsController *)aFetchedResultsController {
    if ([aFetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTActivityDetailViewController *detailVC = [WTActivityDetailViewController createActivityDetailViewControllerWithActivity:activity backBarButtonText:NSLocalizedString(@"Activities", nil)];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    self.filterButton.selected = YES;
}

#pragma mark - WTInnerSettingViewControllerDelegate

- (void)innerSettingViewController:(WTInnerSettingViewController *)controller
                  didFinishSetting:(BOOL)modified {
    if (modified) {
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
        [self.dragToLoadDecorator setTopViewLoading:NO];
    }
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

- (NSString *)userDefaultKey {
    return @"WTActivityController";
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragUp {
    [self loadMoreDataWithSuccessBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:NO];
    }];
}

- (void)dragToLoadDecoratorDidDragDown {
    self.nextPage = 1;
    [self loadMoreDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
