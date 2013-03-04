//
//  WTInnerNotificationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationViewController.h"
#import "WTInnerNotificationTableViewController.h"

@interface WTInnerNotificationViewController ()

@property (nonatomic, strong) WTInnerNotificationTableViewController *tableViewController;

@end

@implementation WTInnerNotificationViewController

+ (WTInnerNotificationViewController *)sharedViewController {
    static WTInnerNotificationViewController *viewController = nil;
    static dispatch_once_t WTInnerNotificationTableViewControllerPredicate;
    dispatch_once(&WTInnerNotificationTableViewControllerPredicate, ^{
        viewController = [[WTInnerNotificationViewController alloc] init];
    });
    
    return viewController;
}

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
    [self.view addSubview:self.tableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (WTInnerNotificationTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[WTInnerNotificationTableViewController alloc] init];
    }
    return _tableViewController;
}

@end
