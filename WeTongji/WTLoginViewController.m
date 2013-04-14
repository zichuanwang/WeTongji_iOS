//
//  WTLoginViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTRootNavigationController.h"
#import "UIApplication+WTAddition.h"
#import "WTResourceFactory.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"
#import "WTCoreDataManager.h"
#import "WTLoginIntroViewController.h"
#import "WTRegisterInfoViewController.h"

@interface WTLoginViewController ()

@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) WTLoginIntroViewController *introViewController;
@property (nonatomic, assign) BOOL showIntro;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    
    if (self.showIntro) {
        self.introButton.selected = YES;
        [self.view addSubview:self.introViewController.view];
        self.introViewController.view.frame = self.view.frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (WTLoginIntroViewController *)introViewController {
    if (!_introViewController) {
        _introViewController = [[WTLoginIntroViewController alloc] init];
    }
    return _introViewController;
}

- (UIButton *)forgetPasswordButton {
    if (_forgetPasswordButton == nil) {
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

#pragma UI methods

- (void)configureLoginPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.loginPanelBgImageView.image = bgImage;
    
    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    
    [self.loginPanelContainerView addSubview:self.forgetPasswordButton];
    
    if (!self.showIntro)
        [self.accountTextField becomeFirstResponder];
    
    [self.signUpButton setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
}

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Not now", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    UIButton *introButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Log In / Sign Up", nil)];
    [introButton addTarget:self action:@selector(didClickIntroButton:) forControlEvents:UIControlEventTouchUpInside];
    introButton.selected = NO;
    self.introButton = introButton;
    
    UIBarButtonItem *introBarButtonItem = [WTResourceFactory createBarButtonWithButton:introButton];
    self.navigationItem.rightBarButtonItem = introBarButtonItem;
}

#pragma mark - Animations

- (void)showIntroViewAnimation {
    self.introButton.userInteractionEnabled = NO;
    [self.view addSubview:self.introViewController.view];
    self.introViewController.view.frame = self.view.frame;
    [self.introViewController.view resetOriginY:self.view.frame.size.height];
    [UIView animateWithDuration:0.25 animations:^{
        [self.introViewController.view resetOriginY:0];
    } completion:^(BOOL finished) {
        self.introButton.userInteractionEnabled = YES;
    }];
}

- (void)hideIntroViewAnimation {
    self.introButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.introViewController.view resetOriginY:self.view.frame.size.height];
    } completion:^(BOOL finished) {
        [self.introViewController.view removeFromSuperview];
        self.introButton.userInteractionEnabled = YES;
    }];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)didClickIntroButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self showIntroViewAnimation];
        [self.view endEditing:YES];
        
        NSLog(@"self frame%@", NSStringFromCGRect(self.view.frame));
        NSLog(@"intro frame:%@", NSStringFromCGRect(self.introViewController.view.frame));
    } else {
        [self hideIntroViewAnimation];
        [self.accountTextField becomeFirstResponder];
    }
}

- (IBAction)didClickSignUpButton:(UIButton *)sender {
    WTRegisterInfoViewController *vc = [[WTRegisterInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

+ (void)show:(BOOL)showIntro {
    WTLoginViewController *vc = [[WTLoginViewController alloc] init];
    WTRootNavigationController *nav = [[WTRootNavigationController alloc] initWithRootViewController:vc];
    vc.showIntro = showIntro;
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

- (void)dismissView {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Logic methods

- (void)showLoginFailedAlertView:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)configureFlurryUserData:(User *)user {
    [Flurry setGender:user.gender];
    [Flurry setUserID:user.studentNumber];
}

- (void)login {
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock: ^(id responseData) {
        User *user = [User insertUser:[responseData objectForKey:@"User"]];
        [WTCoreDataManager sharedManager].currentUser = user;
        [self configureFlurryUserData:user];
        [self dismissView];
    } failureBlock:^(NSError * error) {
        [self showLoginFailedAlertView:error];
    }];
    [request login:self.accountTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.passwordTextField) {
        [self login];
    }
    return NO;
}

@end
