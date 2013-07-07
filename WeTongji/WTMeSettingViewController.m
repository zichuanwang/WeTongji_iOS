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

@interface WTMeSettingViewController () <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *textFieldArray;

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
    [self registerTextFields];
}

- (NSMutableArray *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = [NSMutableArray array];
    }
    return _textFieldArray;
}

- (NSArray *)loadSettingConfig {
    return [[WTConfigLoader sharedLoader] loadConfig:kWTMeConfig];
}

- (void)registerTextFields {
    for (UIView *itemView in self.innerSettingItems) {
        if ([itemView isKindOfClass:[WTSettingTextFieldCell class]]) {
            WTSettingTextFieldCell *textFieldCell = (WTSettingTextFieldCell *)itemView;
            textFieldCell.textField.delegate = self;
            [self.textFieldArray addObject:textFieldCell.textField];
        }
    }
}

#pragma mark - Actions 

- (void)didClickLogoutButton:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to logout?", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Logout", nil), nil];
    
    [alert show];
}

- (void)didClickVisitOfficialWebsiteButton:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://we.tongji.edu.cn"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.view endEditing:YES];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUInteger index = [self.textFieldArray indexOfObject:textField];
    if (NSNotFound != index) {
        if (index == self.textFieldArray.count - 1) {
            [self.textFieldArray[0] becomeFirstResponder];
        } else {
            [self.textFieldArray[index + 1] becomeFirstResponder];
        }
        return YES;
    }
    return NO;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:NSLocalizedString(@"Are you sure you want to logout?", nil)]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[WTClient sharedClient] logout];
            [WTCoreDataManager sharedManager].currentUser = nil;
        }
    }
}

@end
