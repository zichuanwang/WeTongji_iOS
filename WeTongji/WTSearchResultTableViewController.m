//
//  WTSearchResultTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchResultTableViewController.h"
#import "WTDragToLoadDecorator.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"
#import "Object+Addtion.h"
#import "WTNewsCell.h"
#import "WTActivityCell.h"
#import "WTOrganizationCell.h"
#import "WTNewsDetailViewController.h"
#import "WTActivityDetailViewController.h"
#import "WTOrganizationDetailViewController.h"
#import "NSUserDefaults+WTAddition.h"

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
                                                              searchCategory:(NSInteger)category
                                                                    delegate:(id<WTSearchResultTableViewControllerDelegate>)delegate {
    WTSearchResultTableViewController *result = [[WTSearchResultTableViewController alloc] init];
    
    result.searchKeyword = keyword;
    
    result.searchCategory = category;
    
    result.delegate = delegate;
    
    [[NSUserDefaults standardUserDefaults] addSearchHistoryItemWithSearchKeyword:keyword searchCategory:category];
    
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
        
        NSArray *orgInfoArray = resultDict[@"Accounts"];
        for (NSDictionary *infoDict in orgInfoArray) {
            Organization *org = [Organization insertOrganization:infoDict];
            org.searchResult = @(YES);
        }
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
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
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
    } else if ([object isKindOfClass:[Organization class]]) {
        WTOrganizationCell *orgCell = (WTOrganizationCell *)cell;
        [orgCell configureCellWithIndexPath:indexPath organization:(Organization *)object];
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
    else if ([object isKindOfClass:[Organization class]])
        return @"WTOrganizationCell";
    else
        return nil;
}

- (NSString *)customSectionNameKeyPath {
    return @"objectClass";
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = 24.0f;
    
    NSString *sectionName = NSLocalizedString([self.fetchedResultsController.sections[section] name], nil);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    label.text = sectionName;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = WTSectionHeaderViewGrayColor;
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]])
        return 105.0f;
    else if ([object isKindOfClass:[Activity class]])
        return 92.0f;
    else if ([object isKindOfClass:[Organization class]])
        return 78.0f;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController *vc = nil;
    NSString *backBarButtonText = NSLocalizedString(@"Search", nil);
    if ([object isKindOfClass:[News class]]) {
        vc = [WTNewsDetailViewController createDetailViewControllerWithNews:(News *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Activity class]]) {
        vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Organization class]]) {
        vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:(Organization *)object backBarButtonText:backBarButtonText];
    } else {
        return;
    }

    [self.delegate wantToPushViewController:vc];
}

@end
