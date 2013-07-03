//
//  WTActivationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTActivationViewController.h"
#import "WTResourceFactory.h"
#import "OHAttributedLabel.h"

@interface WTActivationViewController () <OHAttributedLabelDelegate>

@end

@implementation WTActivationViewController

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
    [self configureInfoPanel];
    [self configureAgreementLabel];
    
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
    
    UIBarButtonItem *nextBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Activate", nil) target:self action:@selector(didClickActivateButton:)];
    self.navigationItem.rightBarButtonItem = nextBarButtonItem;
}

- (void)configureInfoPanel {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.panelBgImageView.image = bgImage;

    self.accountTextField.placeholder = NSLocalizedString(@"Student No.", nil);
    self.nameTextField.placeholder = NSLocalizedString(@"Name", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.repeatPasswordTextField.placeholder = NSLocalizedString(@"Repeat Password", nil);
}

- (void)configureAgreementLabel {
    NSString *agreementString = NSLocalizedString(@"By tapping Activate you are indicating that you have read and agree to Term of Use", nil);
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:agreementString];
    [resultString setAttributes:[self.agreementDisplayLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, resultString.length)];
    
    NSString *termOfUseString = NSLocalizedString(@"Term of Use", nil);
    [resultString setTextBold:YES range:NSMakeRange(resultString.length - termOfUseString.length, termOfUseString.length)];
    [resultString setTextIsUnderlined:YES range:NSMakeRange(resultString.length - termOfUseString.length, termOfUseString.length)];
    
    NSRegularExpression* userRegex = [NSRegularExpression regularExpressionWithPattern:termOfUseString options:0 error:nil];
    [userRegex enumerateMatchesInString:agreementString
                                options:0
                                  range:NSMakeRange(0, agreementString.length)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
     {
         NSString* linkURLString = [NSString stringWithFormat:@"agreement:agreement"];
         [resultString setLink:[NSURL URLWithString:linkURLString] range:match.range];
         *stop = YES;
     }];
    
    self.agreementDisplayLabel.attributedText = resultString;
    self.agreementDisplayLabel.delegate = self;
    
    self.agreementDisplayLabel.linkColor = [UIColor darkGrayColor];
    
    CGFloat agreementLabelHeight = [resultString sizeConstrainedToSize:CGSizeMake(self.agreementDisplayLabel.frame.size.width, 200000.0f)].height;
    [self.agreementDisplayLabel resetHeight:agreementLabelHeight];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didClickActivateButton:(UIButton *)sender {
    if ([self.accountTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Student No.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter your Password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"I see", nil)
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // TODO:
    }
}

@end
