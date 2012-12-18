//
//  WTLoginViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTNavigationController.h"
#import "UIApplication+Addition.h"
#import "WTResourceFactory.h"

@interface WTLoginViewController ()

@end

@implementation WTLoginViewController

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

- (void)configureNavigationBar {
    UIButton *cancelButton = [WTResourceFactory createNavigationBarButtonWithText:NSLocalizedString(@"Not now", nil)];
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)didClickCancelButton:(UIButton *)sender {
    UIViewController *rootVC = [[UIApplication sharedApplication] rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

+ (void)show {
    WTLoginViewController *vc = [[WTLoginViewController alloc] init];
    WTNavigationController *nav = [[WTNavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *rootVC = [[UIApplication sharedApplication] rootViewController];
    [rootVC presentViewController:nav animated:YES completion:nil];
}

@end
