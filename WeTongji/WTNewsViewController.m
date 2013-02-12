//
//  WTNewsViewController.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/10/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTNewsViewController.h"
#import "OHAttributedLabel.h"
#import "WTResourceFactory.h"
#import "News+Addition.h"
#import "WTNewsCell.h"
#import "WTNewsSettingViewController.h"

@interface WTNewsViewController ()

@property (nonatomic, readonly) UIButton *filterButton;

@end

@implementation WTNewsViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
    
    self.tableView.scrollsToTop = NO;
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView resetHeight:self.view.frame.size.height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data load methods

- (void)loadData {
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get news: %@", responseData);
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *resultArray = resultDict[@"SchoolNews"];
        for(NSDictionary *dict in resultArray)
            [News insertNews:dict];
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get news:%@", error.localizedDescription);
    }];
    [request getNewsInTypes:nil sortMethod:nil page:0];
    [client enqueueRequest:request];
}

#pragma mark - Properties

- (UIButton *)filterButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"News", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self
                                                                                          action:@selector(didClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:)];
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
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - UITableView delegates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    bgImageView.image = [UIImage imageNamed:@"WTTableViewSectionBgUnit"];
    
    NSString *sectionName = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, 24)];
    label.text = sectionName;
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTNewsCell *newsCell = (WTNewsCell *)cell;
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [newsCell configureCellWithIndexPath:indexPath category:NSLocalizedString(@"Campus Update", nil) summary:news.title];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *sortByPublishTime = [[NSSortDescriptor alloc] initWithKey:@"publish_date" ascending:NO];
    [request setSortDescriptors:@[sortByPublishTime]];
}

- (NSString *)customCellClassName {
    return @"WTNewsCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"publish_day";
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    self.filterButton.selected = YES;
}

@end
