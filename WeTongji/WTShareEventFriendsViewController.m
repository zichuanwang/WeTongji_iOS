//
//  WTShareEventFriendsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTShareEventFriendsViewController.h"
#import "WTDragToLoadDecorator.h"
#import "WTResourceFactory.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTUserCell.h"
#import "WTUserDetailViewController.h"

@interface WTShareEventFriendsViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, weak) Event *event;

@end

@implementation WTShareEventFriendsViewController

+ (WTShareEventFriendsViewController *)createViewControllerWithEvent:(Event *)event {
    WTShareEventFriendsViewController *result = [[WTShareEventFriendsViewController alloc] init];
    
    result.event = event;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    
    [self configureTableView];
    
    [self configureDragToLoadDecorator];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Data load methods

- (void)loadDataWithSuccessBlock:(void (^)(void))success
                    failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get friends: %@", responseData);
        
        if (success)
            success();
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *friendsArray = resultDict[@"Users"];
        for (NSDictionary *infoDict in friendsArray) {
            User *friend = [User insertUser:infoDict];
            [self.event addScheduledByObject:friend];
            [[WTCoreDataManager sharedManager].currentUser addFriendsObject:friend];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get friends:%@", error.localizedDescription);
        
        if (failure)
            failure();
    }];
    if ([self.event isKindOfClass:[Activity class]]) {
        [request getFriendsWithSameActivity:self.event.identifier];
    } else if ([self.event isKindOfClass:[Course class]]) {
        Course *course = (Course *)self.event;
        [request getFriendsWithSameCourse:course.info.identifier];
    }
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearAllData {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    BOOL currentUserScheduledThisEvent = [self.event.scheduledBy containsObject:currentUser];
    [self.event removeScheduledBy:self.event.scheduledBy];
    if (currentUserScheduledThisEvent)
        [self.event addScheduledByObject:currentUser];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[NSString friendCountStringConvertFromCountNumber:self.event.friendsCount]];
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.event.what target:self action:@selector(didClickBackButton:)];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
}

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTUserCell *userCell = (WTUserCell *)cell;
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [userCell configureCellWithIndexPath:indexPath user:user];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@ AND SELF != %@", self.event.scheduledBy, [WTCoreDataManager sharedManager].currentUser]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTUserCell";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTUserDetailViewController *vc = [WTUserDetailViewController createDetailViewControllerWithUser:user backBarButtonText:[NSString friendCountStringConvertFromCountNumber:self.event.friendsCount]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
