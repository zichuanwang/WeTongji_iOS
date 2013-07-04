//
//  WTScheduledCourseViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTScheduledCourseViewController.h"
#import "WTDragToLoadDecorator.h"
#import "User+Addition.h"
#import "Course+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTCourseCell.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"
#import "WTCourseDetailViewController.h"

@interface WTScheduledCourseViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, strong) User *user;

@end

@implementation WTScheduledCourseViewController

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
    
    [self configureTableView];
    
    [self configureDragToLoadDecorator];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
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

+ (WTScheduledCourseViewController *)createViewControllerWithUser:(User *)user {
    WTScheduledCourseViewController *result = [[WTScheduledCourseViewController alloc] init];
    
    result.user = user;
    
    return result;
}

#pragma mark - Load data methods

- (void)clearData {
    [self.user removeRegisteredCourses:self.user.registeredCourses];
}

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Courses: %@", responseData);
        
        if (success)
            success();
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get Courses:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    
    BOOL isCurrentUser = [WTCoreDataManager sharedManager].currentUser == self.user;
    [request getCoursesRegisteredByUser:isCurrentUser ? nil : self.user.identifier
                              beginDate:[semesterBeginTime convertToDate]
                                endDate:[NSDate dateWithTimeInterval:60 * 60 * 24 * 7 * 19 sinceDate:[semesterBeginTime convertToDate]]];
    
    [[WTClient sharedClient] enqueueRequest:request];
}


#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Courses", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.user.name target:self action:@selector(didClickBackButton:)];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTCourseCell *courseCell = (WTCourseCell *)cell;
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [courseCell configureCellWithIndexPath:indexPath course:course];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseName" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", self.user.registeredCourses]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTCourseCell";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTCourseDetailViewController *vc = [WTCourseDetailViewController createDetailViewControllerWithCourse:course backBarButtonText:self.user.name];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadMoreDataWithSuccessBlock:^{
        [self clearData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
