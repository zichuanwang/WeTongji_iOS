//
//  WTLoginViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTRootNavigationController.h"
#import "UIApplication+Addition.h"
#import "WTResourceFactory.h"

@interface WTLoginViewController ()

@property (nonatomic, strong) UIButton *forgetPasswordButton;

@end

@implementation WTLoginViewController

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
    [self configureLoginPanel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIButton *)forgetPasswordButton {
    if(_forgetPasswordButton == nil) {
        _forgetPasswordButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Forgot?", nil)];
        [_forgetPasswordButton resetCenterY:self.passwordTextField.center.y];
        
        CGFloat containerViewWidth = self.loginPanelContainerView.frame.size.width;
        CGFloat textfieldOriginX = self.accountTextField.frame.origin.x;
        CGFloat forgetButtonDisToRightBorder = 10;
        [_forgetPasswordButton resetOriginX:containerViewWidth - forgetButtonDisToRightBorder - _forgetPasswordButton.frame.size.width];
        
        [self.passwordTextField resetWidth:containerViewWidth - _forgetPasswordButton.frame.size.width - textfieldOriginX - forgetButtonDisToRightBorder * 2];
    }
    return _forgetPasswordButton;
}

- (void)configureLoginPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.loginPanelBgImageView.image = bgImage;
    
    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    
    [self.loginPanelContainerView addSubview:self.forgetPasswordButton];
    [self.accountTextField becomeFirstResponder];
}

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Not now", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    UIBarButtonItem *loginBarButtonItem = [WTResourceFactory createFocusBarButtonWithText:NSLocalizedString(@"Log In / Sign Up", nil) target:self action:@selector(didClickLoginButton:)];
    self.navigationItem.rightBarButtonItem = loginBarButtonItem;
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    UIViewController *rootVC = [UIApplication sharedApplication].rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickLoginButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

+ (void)show {
    WTLoginViewController *vc = [[WTLoginViewController alloc] init];
    WTRootNavigationController *nav = [[WTRootNavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootViewController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

@end
