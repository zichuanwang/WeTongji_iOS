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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didClickLogoutButton:(UIButton *)sender {
    [[WTClient sharedClient] logout];
    [WTCoreDataManager sharedManager].currentUser = nil;
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

@end
