//
//  WTOrganizationDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationDetailViewController.h"
#import "Organization+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import "WTBannerView.h"
#import "WTOrganizationProfileView.h"
#import "WTOrganizationHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "WTOrganizationActivityViewController.h"
#import "WTOrganizationNewsViewController.h"

@interface WTOrganizationDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) WTOrganizationProfileView *profileView;
@property (nonatomic, weak) WTOrganizationHeaderView *headerView;
@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationDetailViewController

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
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTOrganizationDetailViewController *)createDetailViewControllerWithOrganization:(Organization *)org
                                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTOrganizationDetailViewController *result = [[WTOrganizationDetailViewController alloc] init];
    
    result.org = org;
    
    result.backBarButtonText = backBarButtonText;

    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureHeaderView {
    WTOrganizationHeaderView *headerView = [WTOrganizationHeaderView createHeaderViewWithOrganization:self.org];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}

- (void)configureProfileView {
    WTOrganizationProfileView *profileView = [WTOrganizationProfileView createProfileViewWithOrganization:self.org];
    [profileView resetOriginY:self.headerView.frame.origin.y + self.headerView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.profileView = profileView;
    
    [self.profileView.newsButton addTarget:self action:@selector(didClickNewsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.profileView.activityButton addTarget:self action:@selector(didClickActivityButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)didClickActivityButton:(UIButton *)sender {
    WTOrganizationActivityViewController *vc = [WTOrganizationActivityViewController createViewControllerWithOrganization:self.org];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickNewsButton:(UIButton *)sender {
    WTOrganizationNewsViewController *vc = [WTOrganizationNewsViewController createViewControllerWithOrganization:self.org];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.org;
}

@end
