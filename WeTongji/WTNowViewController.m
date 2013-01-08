//
//  WTNowViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowViewController.h"
#import "WTResourceFactory.h"
#import "WTNowBaseCell.h"

@interface WTNowViewController ()

@property (nonatomic, strong) NSIndexPath *nowIndexPath;

@end

@implementation WTNowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView resetHeight:self.view.frame.size.height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureTableView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.scrollsToTop = NO;
}

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    
    self.navigationItem.titleView = self.titleBgView;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Now", nil)
                                                                                       target:self
                                                                                       action:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTNowBaseCell *cell = nil;
    if (indexPath.row == 2 || indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WTNowCourseCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WTNowCourseCell" owner:self options:nil] lastObject];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WTNowActivityCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WTNowActivityCell" owner:self options:nil] lastObject];
        }
    }
    if (indexPath.row < 2) {
        [cell updateCellStatus:WTNowBaseCellTypePast];
    } else if (indexPath.row == 2) {
        [cell updateCellStatus:WTNowBaseCellTypeNow];
    } else {
        [cell updateCellStatus:WTNowBaseCellTypeNormal];
    }
    return cell;
}

@end
