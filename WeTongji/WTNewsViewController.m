//
//  WTNewsViewController.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/10/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTNewsViewController.h"
#import "OHAttributedLabel.h"
#import "WTResourceFactory.h"

@interface WTNewsViewController ()

@end

@implementation WTNewsViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"News", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self
                                                                                          action:@selector(didClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFilterBarButtonWithTarget:self
                                                                                         action:@selector(didClickFilterButton:)];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickFilterButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
