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
#import "Object+Addtion.h"
#import "WTNewsCell.h"
#import "WTNewsSettingViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "WTNewsDetailViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface WTNewsViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, readonly) UIButton *filterButton;

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTNewsViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView resetHeight:self.view.frame.size.height];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }
        
        if (success)
            success();
        
        NSArray *resultArray = resultDict[@"Information"];
        for(NSDictionary *dict in resultArray) {
            News *news = [News insertNews:dict];
            [news setObjectHeldByHolder:self];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get news:%@", error.localizedDescription);
        
        if (failure)
            failure();
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getInformationInTypes:[self newsShowTypes]
                       orderMethod:[userDefaults getNewsOrderMethod]
                        smartOrder:[userDefaults getNewsSmartOrderProperty]
                              page:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - Methods to overwrite

- (NSArray *)newsShowTypes {
    return [NSUserDefaults getNewsShowTypesArray];
}

- (WTNewsSettingViewController *)createNewsSettingViewController {
    WTNewsSettingViewController *vc = [[WTNewsSettingViewController alloc] init];
    vc.delegate = self;
    return vc;
}

- (void)clearAllData {
    NSSet *newsShowTypesSet = [NSUserDefaults getNewsShowTypesSet];
    for (NSNumber *showTypeNumber in newsShowTypesSet) {
        [News setAllNewsFreeFromHolder:self inCategory:showTypeNumber];
    }
}

#pragma mark - Properties

- (UIButton *)filterButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - UI methods

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.scrollsToTop = NO;
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"News", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self
                                                                                          action:@selector(didClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:)];
    
    BOOL isNewsSettingDifferentFromDefaultValue = [[NSUserDefaults standardUserDefaults] isNewsSettingDifferentFromDefaultValue];
    [WTResourceFactory configureFilterBarButton:self.navigationItem.rightBarButtonItem modified:isNewsSettingDifferentFromDefaultValue];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickFilterButton:(UIButton *)sender {
    
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (sender.selected) {
        sender.selected = NO;

        [nav showInnerModalViewController:[self createNewsSettingViewController] sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    NSString *sectionName = [self.fetchedResultsController.sections[section] name];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width - 20.0f, sectionHeaderHeight)];
    label.text = sectionName;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = WTSectionHeaderViewGrayColor;
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
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

- (void)configureRequest:(NSFetchRequest *)request {
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
    
    
    NSString *holderIdentifier = NSStringFromClass([self class]);
    [request setPredicate:[NSPredicate predicateWithFormat:@"(category in %@) AND (%@ in heldBy)", [NSUserDefaults getNewsShowTypesSet], holderIdentifier]];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    [super insertCellAtIndexPath:indexPath];
    [self.dragToLoadDecorator scrollViewDidInsertNewCell];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTNewsCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"publishDay";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
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
    return @"WTNewsController";
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
