//
//  WTFriendListViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-11.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTFriendListViewController.h"
#import "WTRootNavigationController.h"
#import "UIApplication+WTAddition.h"
#import "WTResourceFactory.h"

@interface WTFriendListViewController ()

@end

@implementation WTFriendListViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

+ (void)show {
    WTFriendListViewController *vc = [[WTFriendListViewController alloc] init];
    WTRootNavigationController *nav = [[WTRootNavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

- (void)dismissView {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

@end
