//
//  WTNowViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowViewController.h"
#import "WTResourceFactory.h"
#import "WTCoreDataManager.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTLoginViewController.h"
#import "WTNowBarTitleView.h"
#import "WTNowWeekCell.h"

@interface WTNowViewController () <WTNowBarTitleViewDelegate>

@property (nonatomic, strong) NSIndexPath *nowIndexPath;
@property (nonatomic, strong) WTNowBarTitleView *barTitleView;

@end

@implementation WTNowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureTableView];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(handleCurrentUserDidChangeNotification:)
                                                                        target:self];
    
    if (![WTCoreDataManager sharedManager].currentUser) {
        [WTLoginViewController show:NO];
    }
    
    self.barTitleView.weekNumber = 1;
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (WTNowBarTitleView *)barTitleView {
    if (!_barTitleView) {
        _barTitleView = [WTNowBarTitleView createBarTitleViewWithDelegate:self];
    }
    return _barTitleView;
}

#pragma mark - Notification handler

- (void)handleCurrentUserDidChangeNotification:(NSNotification *)notification {    
    [self.tableView reloadData];
}

#pragma mark - UI methods


- (void)configureTableView {
    CGRect frame = self.tableView.frame;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.frame = frame;
}

- (void)configureCell:(WTNowWeekCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"table view frame:%@", NSStringFromCGRect(self.tableView.frame));
    NSLog(@"cell frame%@", NSStringFromCGRect(cell.frame));
    
    [cell resetWidth:self.tableView.frame.size.height];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = self.barTitleView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Now", nil)
                                                                                       target:self
                                                                                       action:@selector(didClickNowButton:)];
}

- (void)updateTableView {
    NSUInteger index = self.tableView.contentOffset.y / self.tableView.frame.size.width;
    self.barTitleView.weekNumber = index + 1;
}

#pragma mark - Actions

- (void)didClickNowButton:(UIButton *)sender {
    if ([WTCoreDataManager sharedManager].currentUser) {
        //[self.nowTableViewController scrollToNow];
    } else {
        [WTLoginViewController show:NO];
    }
}

#pragma mark - WTNowBarTitleViewDelegate

- (void)nowBarTitleViewWeekNumberDidChange:(WTNowBarTitleView *)titleView {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:titleView.weekNumber - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = @"WTNowWeekCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject];
    }
    [self configureCell:(WTNowWeekCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateTableView];
    }
}

@end
