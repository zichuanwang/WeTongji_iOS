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
#import "WTScrollView.h"

@interface WTOrganizationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *organizationHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
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
}

- (void)configureOrganizationHeaderView {
    self.organizationHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
    
    [self configureOrganizationLogoAndName];
}

- (void)configureOrganizationLogoAndName {
    [self.logoImageView loadImageWithImageURLString:self.org.avatar];
    
    self.organizationNameLabel.text = self.org.name;
    [self.organizationNameLabel sizeToFit];
    [self.organizationNameLabel resetCenterX:self.view.bounds.size.width / 2];
}

#pragma mark - Actions

- (void)viewDidUnload {
    [self setLogoImageView:nil];
    [self setOrganizationHeaderView:nil];
    [self setOrganizationNameLabel:nil];
    [super viewDidUnload];
}
@end
