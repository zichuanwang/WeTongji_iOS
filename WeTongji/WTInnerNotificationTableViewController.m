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

@interface WTInnerNotificationTableViewController ()

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

- (void)viewWillLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)viewDidLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.waterflowDecorator adjustWaterflowView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView bringSubviewToFront:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
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
    
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *sortByPublishTime = [[NSSortDescriptor alloc] initWithKey:@"publish_date" ascending:NO];
    [request setSortDescriptors:@[sortByPublishTime]];
}

- (NSString *)customCellClassName {
    return @"WTNotificationFriendInvitationCell";
}

#pragma mark - WTWaterflowDecoratorDataSource

- (NSString *)waterflowUnitImageName {
    return @"WTInnerModalViewBg";
}

- (UIScrollView *)waterflowScrollView {
    return self.tableView;
}

@end
