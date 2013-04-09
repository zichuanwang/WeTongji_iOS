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

@interface WTInnerNotificationTableViewController () <WTWaterflowDecoratorDataSource>

@property (nonatomic, strong) WTWaterflowDecorator *waterflowDecorator;

@end

@implementation WTInnerNotificationTableViewController

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
    self.tableView.alwaysBounceVertical = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self viewDidDisappear:animated];
    [self loadMoreData];
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

#pragma mark - Logic methods

- (void)loadMoreData {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"notification list:%@", responseObject);
        [Notification clearAllNotifications];
        [Notification insertNotifications:responseObject];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get notification list:%@", error.localizedDescription);
    }];
    [request getNotificationList];
    [[WTClient sharedClient] enqueueRequest:request];
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
    
    NSLog(@"row:%d, noti_id:%@, date:%@", indexPath.row, notification.identifier, [NSString yearMonthDayTimeConvertFromDate:notification.sendTime]);
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *sortByPublishTime = [[NSSortDescriptor alloc] initWithKey:@"send_time" ascending:NO];
    [request setSortDescriptors:@[sortByPublishTime]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [notification customCellClassName];
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
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25f];
}

@end
