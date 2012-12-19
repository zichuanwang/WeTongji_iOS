//
//  WTHomeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTLoginViewController.h"
#import "WTHomeNavigationController.h"
#import "WTNotificationButton.h"
#import "WTNavigationController.h"
#import "WTNotificationModalViewController.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTNotificationButton *notificationButton;

@end

@implementation WTHomeViewController

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
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.notificationButton];
}

#pragma mark - Properties

- (WTNotificationButton *)notificationButton {
    if(_notificationButton == nil) {
        _notificationButton = [[WTNotificationButton alloc] init];
        [_notificationButton addTarget:self action:@selector(didClickNotificationButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notificationButton;
}

#pragma mark - Actions

- (IBAction)didClickNotificationButton:(WTNotificationButton *)sender {
    sender.selected = !sender.selected;
    WTNavigationController *nav = (WTNavigationController *)self.navigationController;
    if(sender.selected) {
        WTNotificationModalViewController *vc = [[WTNotificationModalViewController alloc] init];
        [nav showInnerModalViewController:vc];
        [sender stopShine];
    } else {
        [nav hideInnerModalViewController];
    }
}

- (IBAction)didClickLoginButton:(UIButton *)sender {
    [WTLoginViewController show];
}

- (IBAction)didClickShineButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.isSelected) {
        [self.notificationButton startShine];
    } else {
        [self.notificationButton stopShine];
    }
}

@end
