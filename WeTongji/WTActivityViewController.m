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

@interface WTActivityViewController ()

@property (nonatomic, readonly) UIButton *filterButton;

@end

@implementation WTActivityViewController

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

#pragma mark - Properties

- (UIButton *)filterButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - Data load methods

- (void)loadData {
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Activities: %@", responseData);
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *resultArray = resultDict[@"Activities"];
        for (NSDictionary *dict in resultArray) {
            [Activity insertActivity:dict];
        }
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get activity:%@", error.localizedDescription);
    }];
    [request getActivitiesInChannel:nil inSort:nil Expired:NO nextPage:0];
    [client enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Activities", nil)];
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
        
        WTActivitySettingViewController *vc = [[WTActivitySettingViewController alloc] init];
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTActivityCell *activityCell = (WTActivityCell *)cell;
    
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [activityCell configureCellWithIndexPath:indexPath title:activity.title time:activity.begin location:activity.location imageURL:activity.image];//TODO time
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];

    NSSortDescriptor *sortByBegin = [[NSSortDescriptor alloc] initWithKey:@"begin" ascending:YES];
    [request setSortDescriptors:@[sortByBegin]];
}

- (NSString *)customCellClassName {
    return @"WTActivityCell";
}

- (NSString *)customSectionNameKeyPath {
    return nil;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTActivityDetailViewController *detailVC = [[WTActivityDetailViewController alloc] initWithActivityIdentifier:activity.identifier];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    self.filterButton.selected = YES;
}

@end
