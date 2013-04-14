//
//  WTNowViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"

@interface WTNowViewController : WTRootViewController

@property (nonatomic, weak) IBOutlet UIView *titleBgView;
@property (nonatomic, weak) IBOutlet UILabel *weekDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *weekLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *weekContainerView;

- (IBAction)didClickPrevButton:(UIButton *)sender;
- (IBAction)didClickNextButton:(UIButton *)sender;

@end
