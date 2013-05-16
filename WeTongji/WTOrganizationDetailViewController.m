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
#import <QuartzCore/QuartzCore.h>

@interface WTOrganizationDetailViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *organizationHeaderView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *organizationNameLabel;

@property (nonatomic, strong) WTBannerContainerView *bannerView;
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
    [self configureBannerView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.bounds.size.height + 1);
}

- (void)configureOrganizationHeaderView {
    self.organizationHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
    self.organizationHeaderView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f].CGColor;
    self.organizationHeaderView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.organizationHeaderView.layer.shadowOpacity = 0.25f;
    self.organizationHeaderView.layer.shadowRadius = 0;
    
    [self configureOrganizationLogoAndName];
}

- (void)configureOrganizationLogoAndName {
    [self.logoImageView loadImageWithImageURLString:self.org.avatar];
    
    self.organizationNameLabel.text = self.org.name;
    [self.organizationNameLabel sizeToFit];
    [self.organizationNameLabel resetCenterX:self.view.bounds.size.width / 2];
}

- (void)configureBannerView {
    self.bannerView = [WTBannerContainerView createBannerContainerView];
    [self.bannerView resetOrigin:CGPointMake(0, self.organizationHeaderView.frame.origin.y + self.organizationHeaderView.frame.size.height)];
    [self.scrollView insertSubview:self.bannerView atIndex:0];
    [self configureTestBanner];
}

- (void)configureTestBanner {
    NSArray *orgNameArray = @[@"WeTongji Dev Team", @"Tongji Apple Club", @"Apple Inc."];
    NSArray *titleArray = @[@"WeTongji 3.0 Coming Soon", @"Enroll 2012", @"WWDC 2011"];
    for(int i = 0; i < orgNameArray.count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"WTTestBanner%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        [self.bannerView addItemViewWithImage:image
                         titleText:titleArray[i]
                  organizationName:orgNameArray[i]
                             style:WTBannerItemViewStyleBlue
                           atIndex:i];
    }
}

#pragma mark - Actions

- (void)viewDidUnload {
    [self setLogoImageView:nil];
    [self setOrganizationHeaderView:nil];
    [self setOrganizationNameLabel:nil];
    [super viewDidUnload];
}
@end
