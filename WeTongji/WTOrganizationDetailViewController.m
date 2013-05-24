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
#import <QuartzCore/QuartzCore.h>

@interface WTOrganizationDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *organizationHeaderView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIView *logoContainerView;
@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;

@property (nonatomic, strong) WTOrganizationProfileView *profileView;
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
    [self configureOrganizationHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureOrganizationHeaderView {
    [self configureOrganizationName];
    [self configureOrganizationLogo];
}

- (void)configureOrganizationLogo {
    self.logoContainerView.layer.masksToBounds = YES;
    self.logoContainerView.layer.cornerRadius = 6.0f;
    [self.logoImageView loadImageWithImageURLString:self.org.avatar];
}

- (void)configureOrganizationName {
    self.organizationNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.organizationNameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.organizationNameLabel.layer.shadowOpacity = 0.3f;
    self.organizationNameLabel.layer.shadowRadius = 1.0f;
    self.organizationNameLabel.text = self.org.name;
    [self.organizationNameLabel sizeToFit];
    [self.organizationNameLabel resetCenterX:self.view.bounds.size.width / 2];
}

- (void)configureProfileView {
    self.profileView = [WTOrganizationProfileView createProfileViewWithOrganization:self.org];
    [self.profileView resetOriginY:self.organizationHeaderView.frame.origin.y + self.organizationHeaderView.frame.size.height];
    [self.scrollView addSubview:self.profileView];
}

#pragma mark - Actions

@end
