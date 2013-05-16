//
//  WTStarViewController.m
//  WeTongji
//
//  Created by Song on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarViewController.h"
#import "OHAttributedLabel.h"
#import "WTResourceFactory.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "NSString+WTAddition.h"
#import "WTStarCell.h"
#import "Star.h"
#import "Star+Addition.h"

@interface WTStarViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, readonly) UIButton *filterButton;

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) BOOL shouldUpdateHomeSelectViews;
@property (nonatomic, assign) BOOL shouldLoadHomeSelectedItems;
@property (nonatomic, strong) NSTimer *loadHomeSelectedItemsTimer;

@end

@implementation WTStarViewController

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




- (void)clearAllData {
     [Star clearAllStars];
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Stars: %@", responseData);
        
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
        
        NSArray *resultArray = resultDict[@"People"];
        for (NSDictionary *dict in resultArray) {
            [Star insertStar:dict];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get Stars:%@", error.localizedDescription);
        
        if (failure)
            failure();
    }];

    [request getStarsInPage:self.nextPage];
    
    [[WTClient sharedClient] enqueueRequest:request];
}


#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Stars", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self
                                                                                          action:@selector(didClickBackButton:)];
    /*self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:)];
    
    BOOL isActivitySettingDifferentFromDefaultValue = [[NSUserDefaults standardUserDefaults] isActivitySettingDifferentFromDefaultValue];
    [WTResourceFactory configureFilterBarButton:self.navigationItem.rightBarButtonItem modified:isActivitySettingDifferentFromDefaultValue];
     */
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
//    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
//    
//    if (sender.selected) {
//        sender.selected = NO;
//        
//        [nav showInnerModalViewController:[self createActivitySettingViewController] sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
//        
//    } else {
//        [nav hideInnerModalViewController];
//    }
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTStarCell *starCell = (WTStarCell *)cell;
    
    Star *star = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [starCell configureCellWithIndexPath:indexPath Star:star];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    [super insertCellAtIndexPath:indexPath];
    [self.dragToLoadDecorator scrollViewDidInsertNewCell];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
  
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:NO];
    
  
    [request setSortDescriptors:@[updateTimeDescriptor]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTStarCell";
}

- (NSString *)customSectionNameKeyPath {
    return nil;
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    Star *star = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    WTActivityDetailViewController *detailVC = [WTActivityDetailViewController createDetailViewControllerWithActivity:activity backBarButtonText:NSLocalizedString(@"Activities", nil)];
//    [self.navigationController pushViewController:detailVC animated:YES];
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
