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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 42, 300, 24)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"WeTongji 3.0 Coming Soon";
    
    UILabel *orgnizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 68, 200, 18)];
    orgnizationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    orgnizationLabel.textColor = [UIColor colorWithRed:13.0f / 255 green:195.0f / 255 blue:204.0f / 255 alpha:1.0f];
    orgnizationLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    orgnizationLabel.backgroundColor = [UIColor clearColor];
    orgnizationLabel.shadowOffset = CGSizeMake(0, 1);
    orgnizationLabel.text = @"Tongji Apple Club";
    
    [self.bannerScrollView addSubview:titleLabel];
    [self.bannerScrollView addSubview:orgnizationLabel];
    
    UIImageView *leftShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTLeftShadow"]];
    UIImageView *rightShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTRightShadow"]];
    [leftShadowImageView resetOrigin:CGPointMake(-4, 0)];
    [rightShadowImageView resetOrigin:CGPointMake(self.bannerScrollView.contentSize.width, 0)];
    [self.bannerScrollView addSubview:leftShadowImageView];
    [self.bannerScrollView addSubview:rightShadowImageView];
    
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
    if(scrollView == self.bannerScrollView)
        [self updateBannerScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO) {
        if(scrollView == self.bannerScrollView)
            [self updateBannerScrollView];
    }
}

@end
