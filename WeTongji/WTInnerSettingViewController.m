//
//  WTInnerSettingViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-2-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerSettingViewController.h"
#import "WTConfigLoader.h"
#import "WTSwitch.h"

@interface WTInnerSettingViewController ()

@property (nonatomic, strong) NSArray *settingConfig;

@end

@implementation WTInnerSettingViewController

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
	// Do any additional setup after loading the view.
    [self configureScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods to overwrite

- (NSArray *)loadSettingConfig {
    return nil;
}

#pragma mark - Properties

- (NSArray *)settingConfig {
    if (_settingConfig == nil) {
        _settingConfig = [self loadSettingConfig];
    }
    return _settingConfig;
}

#pragma mark - UI methods

- (void)configureScrollView {
    CGFloat originY = 0;
    for (NSDictionary *dict in self.settingConfig) {
        NSString *tableViewType = dict[kTableViewType];
        if ([tableViewType isEqualToString:kTableViewTypePlain]) {
            NSArray *contentArray = dict[kTableViewContent];
            for (NSDictionary *cellDict in contentArray) {
                NSString *cellTitle = cellDict[kCellTitle];
                NSString *cellAccessoryType = cellDict[kCellAccessoryType];
                NSString *cellThumbnail = cellDict[kCellThumbnail];
                
                WTSettingPlainCell *plainCell = [WTSettingPlainCell createPlainCell];
                [plainCell resetOriginY:originY];
                originY += plainCell.frame.size.height;
                [self.scrollView addSubview:plainCell];
                
                plainCell.titleLabel.text = cellTitle;
                if ([cellAccessoryType isEqualToString:kCellAccessoryTypeSwitch]) {
                    [plainCell createSwitch];
                }
                
                if (cellThumbnail) {
                    
                }
            }
        } else if ([tableViewType isEqualToString:kTableViewTypeGroup]) {
            UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTInnerModalSeparator"]];
            [separatorImageView resetOrigin:CGPointMake(0, originY)];
            [self.scrollView addSubview:separatorImageView];
            
        } else if ([tableViewType isEqualToString:kTableViewTypeSeparator]) {
            
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
}

@end

@implementation WTSettingPlainCell

+ (WTSettingPlainCell *)createPlainCell {
    WTSettingPlainCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingPlainCell class]]) {
            result = (WTSettingPlainCell *)view;
            [result resetOriginX:0];
            break;
        }
    }
    return result;
}

- (void)createSwitch {
    self.selectSwitch = [WTSwitch createSwitchWithDelegate:self];
    [self.selectSwitch resetCenterY:self.frame.size.height / 2];
    [self.selectSwitch resetOriginX:self.frame.size.width - self.selectSwitch.frame.size.width - 12];
    [self addSubview:self.selectSwitch];
}

#pragma mark - WTSwitchDelegate

- (void)switchDidChange:(WTSwitch *)sender {
    
}

@end
