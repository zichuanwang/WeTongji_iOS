//
//  WTNewsViewController.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/10/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTNewsViewController.h"
#import "WTResourceFactory.h"
#import "News+Addition.h"
#import "Object+Addition.h"
#import "Controller+Addition.h"
#import "WTNewsCell.h"
#import "WTNewsSettingViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "WTNewsDetailViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "UIView+TableViewSectionHeader.h"

@interface WTNewsViewController ()

@property (nonatomic, readonly) UIButton *filterButton;

@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTNewsViewController

+ (WTNewsViewController *)createViewController {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"WTNewsViewController" owner:nil options:nil];
    
    WTNewsViewController *result = objects.lastObject;
    
    return result;
}

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
        
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get news: %@", responseData);
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            // [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            // [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }
        
        NSArray *resultArray = resultDict[@"Information"];
        for(NSDictionary *dict in resultArray) {
            News *news = [News insertNews:dict];
            [self configureLoadedNews:news];
        }
        
        if (success)
            success();
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get news:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    [self configureLoadDataRequest:request];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearOutdatedData {
    NSSet *newsShowTypesSet = [NSUserDefaults getNewsShowTypesSet];
    for (NSNumber *showTypeNumber in newsShowTypesSet) {
        [News setOutdatedNewsFreeFromHolder:[self class] inCategory:showTypeNumber];
    }
}

#pragma mark - Methods to overwrite

- (void)configureLoadedNews:(News *)news {
    [news setObjectHeldByHolder:[self class]];
}

- (void)configureLoadDataRequest:(WTRequest *)request {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getInformationInTypes:[NSUserDefaults getNewsShowTypesArray]
                       orderMethod:[userDefaults getNewsOrderMethod]
                        smartOrder:[userDefaults getNewsSmartOrderProperty]
                              page:self.nextPage];
}

#pragma mark - Properties

- (UIButton *)filterButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - UI methods

- (void)configureNaviationBarTitleView {
    NSSet *newsShowTypesSet = [NSUserDefaults getNewsShowTypesSet];
    if (newsShowTypesSet.count == 1) {
        self.navigationItem.title = [News convertCategoryStringFromCategory:newsShowTypesSet.anyObject];
        // self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[News convertCategoryStringFromCategory:newsShowTypesSet.anyObject]];
    } else {
        self.navigationItem.title = NSLocalizedString(@"News", nil);
        // self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"News", nil)];
    }
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
}

- (void)configureNavigationBar {
    [self configureNaviationBarTitleView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Featured" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickBackButton:)];
    // [self configureFilterBarButton];
}

- (void)configureFilterBarButton {
    BOOL isNewsSettingDifferentFromDefaultValue = [[NSUserDefaults standardUserDefaults] isNewsSettingDifferentFromDefaultValue];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:) focus:isNewsSettingDifferentFromDefaultValue];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickFilterButton:(UIButton *)sender {
    
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (sender.selected) {
        sender.selected = NO;

        WTNewsSettingViewController *vc = [[WTNewsSettingViewController alloc] init];
        vc.delegate = self;
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

- (IBAction)refreshControlDidChange:(UIRefreshControl *)refresh {
    self.nextPage = 1;
    [self loadMoreDataWithSuccessBlock:^{
        [self clearOutdatedData];
        [self.refreshControl endRefreshing];
    } failureBlock:^{
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName = [self.fetchedResultsController.sections[section] name];
    return [UIView sectionHeaderViewWithSectionName:sectionName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNewsDetailViewController *detailVC = [WTNewsDetailViewController createDetailViewControllerWithNews:news backBarButtonText:NSLocalizedString(@"News", nil)];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTNewsCell *newsCell = (WTNewsCell *)cell;
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [newsCell configureCellWithIndexPath:indexPath news:news];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NewsOrderMethod orderMethod = [userDefaults getNewsOrderMethod];
    BOOL smartOrder = [userDefaults getNewsSmartOrderProperty];
    BOOL orderByAsc = ![WTRequest shouldInformationOrderByDesc:orderMethod smartOrder:smartOrder];
    NSArray *descriptors = nil;
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:YES];
    
    switch (orderMethod) {
        case NewsOrderByPublishDate:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"publishDate" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        case NewsOrderByPopularity:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"likeCount" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        default:
            break;
    }
    
    [request setSortDescriptors:descriptors];

    [request setPredicate:[NSPredicate predicateWithFormat:@"(category in %@) AND (SELF in %@)", [NSUserDefaults getNewsShowTypesSet], [Controller controllerModelForClass:[self class]].hasObjects]];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    [super insertCellAtIndexPath:indexPath];
    // [self.dragToLoadDecorator scrollViewDidInsertNewCell];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTNewsCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"publishDay";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        // [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    return self.tableView;
}

- (void)didHideInnderModalViewController {
    [self configureFilterBarButton];
    self.filterButton.selected = YES;
}

#pragma mark - WTInnerSettingViewControllerDelegate

- (void)innerSettingViewController:(WTInnerSettingViewController *)controller
                  didFinishSetting:(BOOL)modified {
    if (modified) {
        [self configureNaviationBarTitleView];
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
        // [self.dragToLoadDecorator setTopViewLoading:NO];
    }
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragUp {    
    [self loadMoreDataWithSuccessBlock:^{
        // [self.dragToLoadDecorator bottomViewLoadFinished:YES];
    } failureBlock:^{
        // [self.dragToLoadDecorator bottomViewLoadFinished:NO];
    }];
}

- (void)dragToLoadDecoratorDidDragDown {
    self.nextPage = 1;
    [self loadMoreDataWithSuccessBlock:^{
        [self clearOutdatedData];
        // [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        // [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
