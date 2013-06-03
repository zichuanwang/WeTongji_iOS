//
//  WTStarDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarDetailViewController.h"
#import "Star+Addition.h"
#import "WTStarHeaderView.h"

@interface WTStarDetailViewController ()

@property (nonatomic, strong) Star *star;
@property (nonatomic, weak) WTStarHeaderView *headerView;

@end

@implementation WTStarDetailViewController

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

+ (WTStarDetailViewController *)createDetailViewControllerWithStar:(Star *)star
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTStarDetailViewController *result = [[WTStarDetailViewController alloc] init];
    
    result.star = star;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureScrollView];
}

- (void)configureHeaderView {
    WTStarHeaderView *headerView = [WTStarHeaderView createHeaderViewWithStar:self.star];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;    
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    // self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.star;
}

@end
