//
//  WTInnerSettingViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerModalViewController.h"
#import "WTSwitch.h"

@interface WTInnerSettingViewController : WTInnerModalViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (NSArray *)loadSettingConfig;

@end

@interface WTSettingPlainCell : UIView <WTSwitchDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) WTSwitch *selectSwitch;

+ (WTSettingPlainCell *)createPlainCell;

- (void)createSwitch;

@end
