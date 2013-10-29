//
//  WTYellowPageViewController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTYellowPageViewController.h"
#import "WTResourceFactory.h"
#import "WTYellowPageCell.h"
#import "UIView+TableViewSectionHeader.h"

@interface WTYellowPageViewController ()

@property (nonatomic, strong) NSMutableArray *sipingPhoneNumberList;
@property (nonatomic, strong) NSMutableArray *jiadingPhoneNumberList;

@end

@implementation WTYellowPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Properties

- (NSMutableArray *)sipingPhoneNumberList {
    if (_sipingPhoneNumberList == nil) {
        _sipingPhoneNumberList = [[NSMutableArray alloc] init];
    }
    return _sipingPhoneNumberList;
}

- (NSMutableArray *)jiadingPhoneNumberList {
    if (_jiadingPhoneNumberList == nil) {
        _jiadingPhoneNumberList = [[NSMutableArray alloc] init];
    }
    return _jiadingPhoneNumberList;
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
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Yellow Page", nil)];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data

- (void)loadData {
    //Load Data
    NSError *error;
    NSData *phoneNumberJsonFile = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tel" ofType:@"json"]];
    NSDictionary *phoneNumberData = [NSJSONSerialization JSONObjectWithData:phoneNumberJsonFile options:NSJSONReadingMutableLeaves error:&error];
    
    for (NSDictionary *officeInfo in phoneNumberData) {
        if ([[officeInfo objectForKey:@"campus"] isEqualToString:@"四平路校区"]) {
            [self.sipingPhoneNumberList addObject:officeInfo];
        } else {
            [self.jiadingPhoneNumberList addObject:officeInfo];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Call phonenumber
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView sectionHeaderViewWithSectionName:NSLocalizedString(@"Siping Road Campus", nil)];
    } else {
        return [UIView sectionHeaderViewWithSectionName:NSLocalizedString(@"Jiading Campus", nil)];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//Siping and Jiading Campus
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.sipingPhoneNumberList count];
    } else {
        return [self.jiadingPhoneNumberList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [self customCellClassNameAtIndexPath:indexPath];
    
    WTYellowPageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = (WTYellowPageCell *)[[[NSBundle mainBundle]
                              loadNibNamed:@"WTYellowPageCell" owner:nil options:nil]
                             lastObject];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTLOG(@"configure yellow page list cell at indexpath:%d", indexPath.row);
    WTYellowPageCell *yellowPageCell = (WTYellowPageCell *)cell;
    
    NSDictionary *officeInfo;
    if (indexPath.section == 0) {
        officeInfo = [self.sipingPhoneNumberList objectAtIndex:indexPath.row];
    } else {
        officeInfo = [self.jiadingPhoneNumberList objectAtIndex:indexPath.row];
    }
    
    [yellowPageCell configureCellWithIndexPath:indexPath
                                    OfficeName:[officeInfo objectForKey:@"addr"]
                                   PhoneNumber:[officeInfo objectForKey:@"tel"]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTYellowPageCell";
}

@end
