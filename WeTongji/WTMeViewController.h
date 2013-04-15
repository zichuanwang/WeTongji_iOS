//
//  WTMeViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootViewController.h"

@interface WTMeViewController : WTRootViewController

- (IBAction)didClickLoginButton:(UIButton *)sender;
- (IBAction)didClickLogoutButton:(UIButton *)sender;
- (IBAction)didClickActivityDetailButton:(UIButton *)sender;
- (IBAction)didClickElectricityQueryButton:(UIButton *)sender;
- (IBAction)didClickFriendListButton:(UIButton *)sender;

@end
