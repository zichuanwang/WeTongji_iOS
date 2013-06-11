//
//  WTInnerNotificationTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationTableViewController.h"
#import "WTWaterflowDecorator.h"
#import "WTNotificationCell.h"
#import "WTResourceFactory.h"
#import "Notification+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "NSNotificationCenter+WTAddition.h"
#import "ActivityInvitationNotification.h"
#import "Object+Addition.h"

@interface WTInnerNotificationTableViewController () <WTWaterflowDecoratorDataSource, WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) WTWaterflowDecorator *waterflowDecorator;
@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;
@property (nonatomic, assign) NSInteger nextPage;
@end

@implementation WTInnerNotificationTableViewController

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
    self.tableView.alwaysBounceVertical = YES;
    
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(handleCurrentUserDidChangeNotification:) target:self];
}

- (void)viewWillLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)viewDidLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

#pragma mark - Handle Notifications

- (void)handleCurrentUserDidChangeNotification:(NSNotification *)notification {
    if ([WTCoreDataManager sharedManager].currentUser) {
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Logic methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Get notification list succese:%@", responseObject);
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }

        if (success)
            success();
        
        NSSet *notificationsSet = [Notification insertNotifications:responseObject];
        [[WTCoreDataManager sharedManager].currentUser addReceivedNotifications:notificationsSet];
        for (Notification *notification in notificationsSet) {
            if ([notification isKindOfClass:[ActivityInvitationNotification class]]) {
                ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)notification;
                [(Object *)activityInvitation.activity setObjectHeldByHolder:[self class]];
            }
        }
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get notification list failure:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    [request getNotificationsInPage:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearAllData {
    [Object setAllObjectsFreeFromHolder:[self class]];
    [Notification clearAllNotifications];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.waterflowDecorator adjustWaterflowView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [notification cellHeight];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView bringSubviewToFront:cell];
}

#pragma mark - Properties

- (WTWaterflowDecorator *)waterflowDecorator {
    if (!_waterflowDecorator) {
        _waterflowDecorator = [WTWaterflowDecorator createDecoratorWithDataSource:self];
    }
    return _waterflowDecorator;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNotificationCell *notificationCell = (WTNotificationCell *)cell;
    notificationCell.delegate = self;
    [notificationCell configureUIWithNotificaitonObject:notification];
    
    [self.tableView bringSubviewToFront:cell];    
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *sortByPublishTime = [[NSSortDescriptor alloc] initWithKey:@"sendTime" ascending:NO];
    [request setSortDescriptors:@[sortByPublishTime]];

    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", [WTCoreDataManager sharedManager].currentUser.receivedNotifications]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [notification customCellClassName];
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - WTWaterflowDecoratorDataSource

- (NSString *)waterflowUnitImageName {
    return @"WTInnerModalViewBg";
}

- (UIScrollView *)waterflowScrollView {
    return self.tableView;
}

#pragma mark - WTNotificationCellDelegate

- (void)cellHeightDidChange {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    // [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25f];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
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
