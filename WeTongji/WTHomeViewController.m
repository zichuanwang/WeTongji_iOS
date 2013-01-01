//
//  WTHomeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTNotificationBarButton.h"
#import "WTBannerView.h"
#import "OHAttributedLabel.h"
#import "WTNotificationModalViewController.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTNotificationBarButton *notificationButton;
@property (nonatomic, strong) WTBannerView *bannerView;

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
    [self configureBackgroung];
    [self configureBanner];
    [self configureNowPanel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureBanner {
    self.bannerView = [[[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil] lastObject];
    [self.bannerView resetOrigin:CGPointZero];
    [self.scrollView addSubview:self.bannerView];
}

- (void)configureBackgroung {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
}

- (void)configureNavigationBar {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

- (void)configureNowPanel {
    NSMutableAttributedString *text = [self.nowPanelFriendLabel.attributedText mutableCopy];
    [text setTextBold:YES range:NSMakeRange(0, 1)];
    self.nowPanelFriendLabel.attributedText = text;
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
    WTNavigationController *nav = (WTNavigationController *)self.navigationController;
    if(sender.selected) {
        WTNotificationModalViewController *vc = [[WTNotificationModalViewController alloc] init];
        [nav showInnerModalViewController:vc];
        [sender stopShine];
    } else {
        [nav hideInnerModalViewController];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

@end
