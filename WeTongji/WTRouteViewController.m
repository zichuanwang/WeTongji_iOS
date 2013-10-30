//
//  WTRouteViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRouteViewController.h"
#import "WTResourceFactory.h"
#import "UIView+TableViewSectionHeader.h"
#import "WTRouteCell.h"
#import "WTRouteDetailViewController.h"

@interface WTRouteViewController ()

@property (nonatomic, strong) NSMutableArray *sipingRouteList;
@property (nonatomic, strong) NSMutableArray *jiadingRouteList;
@property (nonatomic, strong) NSMutableArray *huxiRouteList;

@end

@implementation WTRouteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Properties

- (NSMutableArray *)sipingRouteList {
    if (_sipingRouteList == nil) {
        _sipingRouteList = [[NSMutableArray alloc] init];
    }
    return _sipingRouteList;
}

- (NSMutableArray *)jiadingRouteList {
    if (_jiadingRouteList == nil) {
        _jiadingRouteList = [[NSMutableArray alloc] init];
    }
    return _jiadingRouteList;
}

- (NSMutableArray *)huxiRouteList {
    if (_huxiRouteList == nil) {
        _huxiRouteList = [[NSMutableArray alloc] init];
    }
    return _huxiRouteList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Assistant", nil) target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Traffic Guide", nil)];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data

- (void)loadData {
    //Load Data
    NSError *error;
    NSData *routeJsonFile = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"json"]];
    NSDictionary *routeData = [NSJSONSerialization JSONObjectWithData:routeJsonFile options:NSJSONReadingMutableLeaves error:&error];
    
    int tag = 0;
    for (NSDictionary *routeInfo in routeData) {
        NSString *campus = [routeInfo objectForKey:@"campus"];
        if ([campus isEqualToString:@"四平路校区"]) {
            tag = 0;
            continue;
        } else if ([campus isEqualToString:@"嘉定校区"]) {
            tag = 1;
            continue;
        } else if ([campus isEqualToString:@"沪西校区"]) {
            tag = 2;
            continue;
        }
        
        switch (tag) {
            case 0: {
                [self.sipingRouteList addObject:routeInfo];
                break;
            }
            case 1: {
                [self.jiadingRouteList addObject:routeInfo];
                break;
            }
            case 2: {
                [self.huxiRouteList addObject:routeInfo];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *routeInfo = nil;
    if (indexPath.section == 0) {
        routeInfo = [self.sipingRouteList objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        routeInfo = [self.jiadingRouteList objectAtIndex:indexPath.row];
    } else {
        routeInfo = [self.huxiRouteList objectAtIndex:indexPath.row];
    }
    
    WTRouteDetailViewController *vc = [WTRouteDetailViewController createDetailViewControllerWithRouteInfo:routeInfo];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView sectionHeaderViewWithSectionName:NSLocalizedString(@"Siping Road Campus", nil)];
    } else if (section == 1) {
        return [UIView sectionHeaderViewWithSectionName:NSLocalizedString(@"Jiading Campus", nil)];
    } else {
        return [UIView sectionHeaderViewWithSectionName:NSLocalizedString(@"Huxi Campus", nil)];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;//Siping, Jiading and Huxi Campus
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.sipingRouteList count];
    } else if (section == 1) {
        return [self.jiadingRouteList count];
    } else {
        return [self.huxiRouteList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self customCellClassNameAtIndexPath:indexPath];
    
    WTRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = (WTRouteCell *)[[[NSBundle mainBundle]
                                     loadNibNamed:@"WTRouteCell" owner:nil options:nil]
                                    lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTLOG(@"configure route list cell at indexpath:%d", indexPath.row);
    WTRouteCell *routeCell = (WTRouteCell *)cell;
    
    NSDictionary *routeInfo;
    if (indexPath.section == 0) {
        routeInfo = [self.sipingRouteList objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        routeInfo = [self.jiadingRouteList objectAtIndex:indexPath.row];
    } else {
        routeInfo = [self.huxiRouteList objectAtIndex:indexPath.row];
    }
    
    [routeCell configureCellWithIndexPath:indexPath
                             TrafficTitle:[routeInfo objectForKey:@"title"]
                           FrequentTarget:[routeInfo objectForKey:@"frequent_target"]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTRouteCell";
}

@end
