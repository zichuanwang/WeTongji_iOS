//
//  WTRegisterInfoViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRegisterInfoViewController.h"
#import "OHAttributedLabel.h"
#import "WTResourceFactory.h"
#import "WTRegisterVarifyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIApplication+WTAddition.h"
#import "UIImage+ProportionalFill.h"

@interface WTRegisterInfoViewController () <OHAttributedLabelDelegate>

@end

@implementation WTRegisterInfoViewController

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
    [self configureAgreementLabel];
    [self configureInfoPanel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Log In / Sign Up", nil) target:self action:@selector(didClickBackButton:) restrictToMaxWidth:NO];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    UIBarButtonItem *nextBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Next", nil) target:self action:@selector(didClickNextButton:)];
    self.navigationItem.rightBarButtonItem = nextBarButtonItem;
}

- (void)configureInfoPanel {
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    self.avatarContainerView.layer.masksToBounds = YES;
    
    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
}

- (void)configureAgreementLabel {
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:self.agreementDisplayLabel.attributedText];
    [resultString setTextBold:YES range:NSMakeRange(self.agreementDisplayLabel.attributedText.length - 4, 4)];
    [resultString setTextIsUnderlined:YES range:NSMakeRange(self.agreementDisplayLabel.attributedText.length - 4, 4)];
    
    NSRegularExpression* userRegex = [NSRegularExpression regularExpressionWithPattern:@"使用条款" options:0 error:nil];
    [userRegex enumerateMatchesInString:self.agreementDisplayLabel.text
                                options:0
                                  range:NSMakeRange(0, self.agreementDisplayLabel.text.length)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
         NSString* linkURLString = [NSString stringWithFormat:@"agreement:agreement"];
         [resultString setLink:[NSURL URLWithString:linkURLString] range:match.range];
     }];
    
    self.agreementDisplayLabel.attributedText = resultString;
    self.agreementDisplayLabel.delegate = self;
    
    self.agreementDisplayLabel.linkColor = self.accountDisplayLabel.textColor;
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didClickNextButton:(UIButton *)sender {
    if (!self.avatarImageView.image) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"请上传头像"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([self.accountTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"请输入学号"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"请输入密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        WTRegisterVarifyViewController *vc = [[WTRegisterVarifyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)didClickAvatarButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Photo Album", nil), nil];
    [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 2)
        return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    if(buttonIndex == 1) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    edittedImage = [edittedImage imageScaledToFitSize:CROP_AVATAR_SIZE];
    
    self.avatarImageView.image = edittedImage;
    self.avatarContainerView.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OHAttributedStringDelegate

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel
       shouldFollowLink:(NSTextCheckingResult *)linkInfo {
	if ([linkInfo.URL.scheme isEqualToString:@"agreement"]) {
        // TODO:
    }
    // Prevent the URL from opening in Safari, as we handled it here manually instead
    return NO;
}

@end
