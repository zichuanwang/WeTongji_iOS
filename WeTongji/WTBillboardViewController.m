//
//  WTBillboardViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardViewController.h"

@interface WTBillboardViewController ()

@end

@implementation WTBillboardViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = NSLocalizedString(@"Billboard", nil);
    
    UIView *titleContainerView = [[UIView alloc] initWithFrame:titleLabel.frame];
    [titleLabel resetOriginY:2];
    [titleContainerView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleContainerView;
}

@end
