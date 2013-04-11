//
//  WTLoginViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView      *loginPanelContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *loginPanelBgImageView;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton    *signUpButton;

+ (void)show;

- (IBAction)didClickSignUpButton:(UIButton *)sender;

@end
