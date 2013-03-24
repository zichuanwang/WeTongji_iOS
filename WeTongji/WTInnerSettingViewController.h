//
//  WTInnerSettingViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerModalViewController.h"
#import "WTSwitch.h"

@protocol WTInnerSettingItem <NSObject>

- (BOOL)isDirty;

@end

@interface WTInnerSettingViewController : WTInnerModalViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (NSArray *)loadSettingConfig;

@end

@interface WTSettingPlainCell : UIView <WTSwitchDelegate, WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) WTSwitch *selectSwitch;

+ (WTSettingPlainCell *)createPlainCell:(NSDictionary *)cellInfo;

@end

@interface WTSettingGroupTableView : UIView <WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;

+ (WTSettingGroupTableView *)createGroupTableView:(NSDictionary *)tableViewInfo;

@end

@interface WTSettingGroupCell : UIView <WTInnerSettingItem>

@property (nonatomic, strong) IBOutlet UIImageView *checkmarkImageView;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UIButton *cellButton;
@property (nonatomic, strong) IBOutlet UIImageView *separatorImageView;

@property (nonatomic, assign) BOOL dirty;

+ (WTSettingGroupCell *)createGroupCell;

@end
