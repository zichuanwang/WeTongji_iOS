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
#import "WTNotificationBarButton.h"
#import "WTNavigationController.h"
#import "WTNotificationModalViewController.h"
#import "WTEventDetailViewController.h"

@interface WTHomeViewController ()

@property (nonatomic, strong) WTNotificationBarButton *notificationButton;

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
    [self configureTestBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureBackgroung {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
}

- (void)configureNavigationBar {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
    self.navigationItem.titleView = logoImageView;
    
    self.navigationItem.leftBarButtonItem = self.notificationButton;
}

- (void)configureTestBanner {
    int imageCount = 3;
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.frame.size.width * imageCount, self.bannerScrollView.frame.size.height);
    for(int i = 0; i < imageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"WTTestBanner%d", i + 1];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView resetOrigin:CGPointMake(self.bannerScrollView.frame.size.width * i, 0)];
        [imageView resetSize:self.bannerScrollView.frame.size];
        [self.bannerScrollView addSubview:imageView];
    }
    
    self.bannerPageControl.numberOfPages = imageCount;
}

- (void)updateBannerScrollView {
    int currentPage = self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width;
    self.bannerPageControl.currentPage = currentPage;
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
    [self updateBannerScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO) {
        [self updateBannerScrollView];
    }
}

@end
