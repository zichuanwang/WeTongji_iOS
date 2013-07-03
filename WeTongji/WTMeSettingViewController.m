//
//  WTMeSettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeSettingViewController.h"
#import "WTConfigLoader.h"
#import "WTCoreDataManager.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface WTMeSettingViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@end

@implementation WTMeSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTInnerSettingViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)loadSettingConfig {
    return [[WTConfigLoader sharedLoader] loadConfig:kWTMeConfig];
}

- (void)didClickLogoutButton:(UIButton *)sender {
    [[WTClient sharedClient] logout];
    [WTCoreDataManager sharedManager].currentUser = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.view endEditing:YES];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

@end
