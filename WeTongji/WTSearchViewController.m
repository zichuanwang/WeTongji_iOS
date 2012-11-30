//
//  WTSearchViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <WeTongjiSDK/WeTongjiSDK.h>
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
    
    BlockARCWeakSelf weakSelf = self;
    [[WTElectricityBalanceQueryService sharedService] getElectricChargeBalanceWithDistrict:@"四平校区" building:@"西南八楼" room:@"119" successBlock:^(id responseObject) {
        NSString *balance = responseObject;
        weakSelf.label.text = balance;
        [weakSelf.label sizeToFit];
    } failureBlock:^(NSError *error) {
        NSLog(@"Query Electricity Balance Failure:%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.searchBar resignFirstResponder];
}

@end
