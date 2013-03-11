//
//  WTMeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeViewController.h"
#import "WTActivityDetailViewController.h"
#import "WTLoginViewController.h"
#import "WTElectricityQueryViewController.h"
#import "WTFriendListViewController.h"

@interface WTMeViewController ()

@end

@implementation WTMeViewController

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
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
}

#pragma mark - Actions

- (IBAction)didClickLoginButton:(UIButton *)sender {
    [WTLoginViewController show];
}

- (IBAction)didClickActivityDetailButton:(UIButton *)sender {
    [self.navigationController pushViewController:[[WTActivityDetailViewController alloc] init] animated:YES];
}

- (IBAction)didClickElectricityQueryButton:(UIButton *)sender {
    [WTElectricityQueryViewController show];
}

- (IBAction)didClickFriendListButton:(UIButton *)sender {
    [WTFriendListViewController show];
}

@end
