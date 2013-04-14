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
#import "WTNowTableViewController.h"

@interface WTNowViewController ()

@property (nonatomic, strong) WTNowTableViewController *nowTableViewController;
@property (nonatomic, strong) NSIndexPath *nowIndexPath;

@end

@implementation WTNowViewController
@synthesize nowTableViewController = _nowTableViewController;

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
    
    [self configureNavigationBar];
    [self configureTableView];
    [self.nowTableViewController.view resetHeight:self.view.frame.size.height];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.nowTableViewController viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (WTNowTableViewController *)nowTableViewController
{
    if (!_nowTableViewController) {
        _nowTableViewController = [[WTNowTableViewController alloc] init];
        [self.view addSubview:_nowTableViewController.view];
    }
    return _nowTableViewController;
}

#pragma mark - UI methods

- (void)scrollToNow
{
    [self.nowTableViewController scrollToNow:YES];
}

- (void)configureTableView {
    self.nowTableViewController.tableView.alwaysBounceVertical = YES;
    self.nowTableViewController.tableView.scrollsToTop = NO;
}

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    
    self.navigationItem.titleView = self.titleBgView;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Now", nil)
                                                                                       target:self
                                                                                       action:@selector(scrollToNow)];
}

#pragma mark - Actions

- (IBAction)didClickPrevButton:(UIButton *)sender {
    
}

- (IBAction)didClickNextButton:(UIButton *)sender {
    
}

@end
