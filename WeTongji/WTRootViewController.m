//
//  WTRootViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"
#import "WTNotificationModalViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (WTNotificationBarButton *)notificationButton {
    if(_notificationButton == nil) {
        _notificationButton = [WTNotificationBarButton createNotificationBarButtonWithTarget:self action:@selector(didClickNotificationButton:)];
    }
    return _notificationButton;
}

#pragma mark - Actions

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender {
    sender.selected = !sender.selected;
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    if(sender.selected) {
        WTNotificationModalViewController *vc = [[WTNotificationModalViewController alloc] init];
        [nav showInnerModalViewController:vc];
        [sender stopShine];
    } else {
        [nav hideInnerModalViewController];
    }
}

@end
