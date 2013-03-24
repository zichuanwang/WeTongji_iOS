//
//  WTRootViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"
#import "WTInnerNotificationViewController.h"

@interface WTRootViewController ()

@end

@implementation WTRootViewController

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
	// Do any additional setup after loading the view.
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureUI {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

#pragma mark - Properties

- (WTNotificationBarButton *)notificationButton {
    if (_notificationButton == nil) {
        _notificationButton = [WTNotificationBarButton createNotificationBarButtonWithTarget:self action:@selector(didClickNotificationButton:)];
    }
    return _notificationButton;
}

#pragma mark - Actions

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender {
    
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (!sender.selected) {
        sender.selected = YES;
        
        WTInnerNotificationViewController *vc = [WTInnerNotificationViewController sharedViewController];
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeRight];
        [sender stopShine];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    self.notificationButton.selected = NO;
}

@end
