//
//  WTBillboardPostViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardPostViewController.h"
#import "WTResourceFactory.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTBillboardPostPlainTextViewController.h"
#import "WTBillboardPostImageViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"
#import "BillboardPost+Addition.h"

@interface WTBillboardPostViewController ()

@end

@implementation WTBillboardPostViewController

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
	// Do any additional setup after loading the view.
    [self configureNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show {
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:self];
    [[UIApplication sharedApplication].rootTabBarController presentViewController:nav animated:YES completion:nil];
}

+ (WTBillboardPostViewController *)createPostViewControllerWithType:(WTBillboardPostViewControllerType)type {
    WTBillboardPostViewController *result = nil;
    if (type == WTBillboardPostViewControllerTypePlainText) {
        result = [[WTBillboardPostPlainTextViewController alloc] init];
    } else if (type == WTBillboardPostViewControllerTypeImage) {
        result = [[WTBillboardPostImageViewController alloc] init];
    }
    return result;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createFocusBarButtonWithText:NSLocalizedString(@"Post", nil) target:self action:@selector(didClickPostButton:)];
}

- (void)dismissView {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)didClickPostButton:(UIButton *)sender {
    
    [BillboardPost createTestBillboardPostWithTitle:self.titleTextField.text content:self.contentTextView.text image:self.postImageView.image];
    [self dismissView];
    return;
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [self dismissView];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Post failed for reason:%@", error.localizedDescription);
        sender.userInteractionEnabled = YES;
    }];
    [request addBillboardPostWithTitle:self.titleTextField.text content:self.contentTextView.text image:self.postImageView.image];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
