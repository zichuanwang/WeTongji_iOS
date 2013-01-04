//
//  WTNowViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowViewController.h"
#import "WTResourceFactory.h"
#import "WTEventTableViewCell.h"

@interface WTNowViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *nowIndexPath;
@end

@implementation WTNowViewController
@synthesize titleBgView = _titleBgView;
@synthesize countLabel = _countLabel;
@synthesize timeLabel = _timeLabel;

@synthesize nowIndexPath = _nowIndexPath;

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
    [self configureBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods
- (void)configureNavigationBar {
    self.navigationItem.titleView = self.titleBgView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:@"Now"
                                                                                       target:self
                                                                                       action:nil];
}

- (void)configureBackground {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.titleBgView = nil;
    self.timeLabel = nil;
    self.countLabel = nil;
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    WTEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WTEventTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell updateCellStatus:eNORMAL];
    }
    if (indexPath.section < 2) {
        [cell updateCellStatus:ePAST];
    } else if (indexPath.section == 2) {
        [cell updateCellStatus:eNOW];
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
@end
