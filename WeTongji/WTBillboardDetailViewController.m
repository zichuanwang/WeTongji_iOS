//
//  WTBillboardDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardDetailViewController.h"
#import "BillboardPost.h"
#import "WTBillboardDetailHeaderView.h"

@interface WTBillboardDetailViewController ()

@property (nonatomic, strong) BillboardPost *post;
@property (nonatomic, strong) WTBillboardDetailHeaderView *headerView;

@end

@implementation WTBillboardDetailViewController

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
    [self configureHeaderView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTBillboardDetailViewController *)createBillboardDetailViewControllerWithBillboardPost:(BillboardPost *)post
                                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTBillboardDetailViewController *result = [[WTBillboardDetailViewController alloc] init];
    result.post = post;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureHeaderView {
    self.headerView = [WTBillboardDetailHeaderView createDetailHeaderViewWithBillboardPost:self.post];
    [self.view addSubview:self.headerView];
}

#pragma mark - Actions

- (void)didClickLikeButton:(UIButton *)sender {
    
}

@end
