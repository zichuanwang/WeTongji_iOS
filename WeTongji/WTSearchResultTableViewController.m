//
//  WTSearchResultTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchResultTableViewController.h"
#import "WTResourceFactory.h"
#import "WTDragToLoadDecorator.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Object+Addtion.h"
#import "WTNewsCell.h"
#import "WTActivityCell.h"
#import "WTNewsDetailViewController.h"
#import "WTActivityDetailViewController.h"

@interface WTSearchResultTableViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, assign) NSInteger searchCategory;

@end

@implementation WTSearchResultTableViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    [self clearSearchResultObjects];
    [self configureDragToLoadDecorator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

+ (WTSearchResultTableViewController *)createViewControllerWithSearchKeyword:(NSString *)keyword
                                                              searchCategory:(NSInteger)category {
    WTSearchResultTableViewController *result = [[WTSearchResultTableViewController alloc] init];
    
    result.searchKeyword = keyword;
    
    result.searchCategory = category;
    
    return result;
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadSearchResult];
}

#pragma mark - Load data methods

- (void)clearSearchResultObjects {
    [Object clearAllSearchResultObjects];
}

- (void)loadSearchResult {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Load serach result success:%@", responseObject);
        
        [self clearSearchResultObjects];
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *activityInfoArray = resultDict[@"Activities"];
        for (NSDictionary *infoDict in activityInfoArray) {
            Activity *activity = [Activity insertActivity:infoDict];
            activity.searchResult = @(YES);
        }
        
        NSArray *newsInfoArray = resultDict[@"Information"];
        for (NSDictionary *infoDict in newsInfoArray) {
            News *news = [News insertNews:infoDict];
            news.searchResult = @(YES);
        }
        
//        NSArray *starInfoArray = resultDict[@"Person"];
//        for (NSDictionary *infoDict in starInfoArray) {
//            Star *star = [Star insertStar:infoDict];
//            star.searchResult = @(YES);
//        }
        [self.dragToLoadDecorator topViewLoadFinished:YES];

    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Load search result failure:%@", error.localizedDescription);
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
    [request getSearchResultInCategory:self.searchCategory keyword:self.searchKeyword];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    [self.dragToLoadDecorator setTopViewLoading:YES];
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Search Results", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Search", nil)
                                                                                    target:self
                                                                                    action:@selector(didClickBackButton:)];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]]) {
        WTNewsCell *newsCell = (WTNewsCell *)cell;
        [newsCell configureCellWithIndexPath:indexPath news:(News *)object];
    } else if ([object isKindOfClass:[Activity class]]) {
        WTActivityCell *activityCell = (WTActivityCell *)cell;
        [activityCell configureCellWithIndexPath:indexPath activity:(Activity *)object];
    }

}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    NSSortDescriptor *createTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updateTime" ascending:NO];
    
    [request setSortDescriptors:[NSArray arrayWithObject:createTimeDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchResult == YES"]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]])
        return @"WTNewsCell";
    else if ([object isKindOfClass:[Activity class]])
        return @"WTActivityCell";
    else
        return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]])
        return 105.0f;
    else if ([object isKindOfClass:[Activity class]])
        return 92.0f;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController *vc = nil;
    NSString *backBarButtonText = NSLocalizedString(@"Search Results", nil);
    if ([object isKindOfClass:[News class]]) {
        vc = [WTNewsDetailViewController createNewsDetailViewControllerWithNews:(News *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Activity class]]) {
        vc = [WTActivityDetailViewController createActivityDetailViewControllerWithActivity:(Activity *)object backBarButtonText:backBarButtonText];
    } else {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
