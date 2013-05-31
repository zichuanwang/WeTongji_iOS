//
//  WTInnerNotificationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationViewController.h"
#import "WTInnerNotificationTableViewController.h"
#import "Notification+Addition.h"
#import "NSNotificationCenter+WTAddition.h"

@interface WTInnerNotificationViewController ()

@property (nonatomic, strong) NSTimer *loadUnreadNotificationsTimer;

@property (nonatomic, strong) WTInnerNotificationTableViewController *tableViewController;

@end

@implementation WTInnerNotificationViewController

+ (WTInnerNotificationViewController *)sharedViewController {
    static WTInnerNotificationViewController *viewController = nil;
    static dispatch_once_t WTInnerNotificationTableViewControllerPredicate;
    dispatch_once(&WTInnerNotificationTableViewControllerPredicate, ^{
        viewController = [[WTInnerNotificationViewController alloc] init];
        [viewController setUpLoadUnreadNotificationsTimer];
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
    [self.tableViewController.view resetHeight:self.view.frame.size.height];
    [self.view addSubview:self.tableViewController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [NSNotificationCenter postUserDidCheckNotificationsNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data methods

- (void)setUpLoadUnreadNotificationsTimer {
    // 设定 2 分钟刷新频率
    self.loadUnreadNotificationsTimer = [NSTimer scheduledTimerWithTimeInterval:2 * 60
                                                               target:self
                                                             selector:@selector(loadUnreadNotificationsTimerFired:)
                                                             userInfo:nil
                                                              repeats:YES];
    
    // 立即刷新一次
    [self loadUnreadNotifications];
}

- (void)loadUnreadNotificationsTimerFired:(NSTimer *)timer {
    [self loadUnreadNotifications];
}

- (void)loadUnreadNotifications {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Get notification list succese:%@", responseObject);
        NSSet *notificationsSet = [Notification insertNotifications:responseObject];
        [[WTCoreDataManager sharedManager].currentUser addReceivedNotifications:notificationsSet];
        
        if (notificationsSet.count != 0) {
            [NSNotificationCenter postDidLoadUnreadNotificationsNotification];
        }
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get notification list failure:%@", error.localizedDescription);
    }];
    [request getUnreadNotifications];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - Properties

- (WTInnerNotificationTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[WTInnerNotificationTableViewController alloc] init];
    }
    return _tableViewController;
}

@end
