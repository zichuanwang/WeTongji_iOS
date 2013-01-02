//
//  WTSearchViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchViewController.h"

@interface WTSearchViewController ()

@end

@implementation WTSearchViewController

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
    [self.searchBar.subviews[0] removeFromSuperview];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)]];
    
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

- (void)getElectricityBalance {
    self.label.text = @"正在加载电量...";
    BlockARCWeakSelf weakSelf = self;
    [[WTElectricityBalanceQueryService sharedService] getElectricChargeBalanceWithDistrict:self.districtTextField.text building:self.buildingTextField.text room:self.roomTextField.text successBlock:^(id responseObject) {
        NSArray *result = responseObject;
        NSNumber *balance = result[WTElectricityBalanceQueryServiceResultIndexTodayBalance];
        NSNumber *avarageUse = result[WTElectricityBalanceQueryServiceResultIndexAvarageUse];
        weakSelf.label.text = [NSString stringWithFormat:@"剩余电量: %.2f kWh, 平均日用电量: %.2f kWh", balance.floatValue, avarageUse.floatValue];
        [weakSelf.label sizeToFit];
    } failureBlock:^(NSError *error) {
        NSLog(@"Query Electricity Balance Failure:%@", error.localizedDescription);
        weakSelf.label.text = @"加载电量失败";
    }];
}

- (IBAction)didClickRefreshButton:(UIButton *)sender {
    [self getElectricityBalance];
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.view endEditing:YES];
}

@end
