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
#import "NSUserDefaults+WTAddition.h"
#import "WTResourceFactory.h"
#import "WTWaterflowDecorator.h"

@interface WTInnerSettingViewController () <WTWaterflowDecoratorDataSource>

@property (nonatomic, strong) NSArray *settingConfig;
@property (nonatomic, strong) WTWaterflowDecorator *waterflowDecorator;

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

- (void)viewWillLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)viewDidLayoutSubviews {
    [self.waterflowDecorator adjustWaterflowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.waterflowDecorator adjustWaterflowView];
}

#pragma mark - Methods to overwrite

- (NSArray *)loadSettingConfig {
    return nil;
}

#pragma mark - Properties

- (WTWaterflowDecorator *)waterflowDecorator {
    if (!_waterflowDecorator) {
        _waterflowDecorator = [WTWaterflowDecorator createDecoratorWithDataSource:self];
    }
    return _waterflowDecorator;
}

- (NSArray *)settingConfig {
    if (_settingConfig == nil) {
        _settingConfig = [self loadSettingConfig];
    }
    return _settingConfig;
}

#pragma mark - UI methods

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    CGFloat originY = 0;
    for (NSDictionary *dict in self.settingConfig) {
        NSString *tableViewType = dict[kTableViewType];
        if ([tableViewType isEqualToString:kTableViewTypePlain]) {
            NSArray *contentArray = dict[kTableViewContent];
            for (NSDictionary *cellDict in contentArray) {
                WTSettingPlainCell *plainCell = [WTSettingPlainCell createPlainCell:cellDict];
                [plainCell resetOriginY:originY];
                originY += plainCell.frame.size.height;
                [self.scrollView addSubview:plainCell];
            }
        } else if ([tableViewType isEqualToString:kTableViewTypeGroup]) {
            WTSettingGroupTableView *tableView = [WTSettingGroupTableView createGroupTableView:dict];
            [tableView resetOriginY:originY];
            originY += tableView.frame.size.height;
            [self.scrollView addSubview:tableView];
            
        } else if ([tableViewType isEqualToString:kTableViewTypeSeparator]) {
            UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTInnerModalSeparator"]];
            originY += 6;
            [separatorImageView resetOrigin:CGPointMake(0, originY)];
            [self.scrollView addSubview:separatorImageView];
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
}

#pragma mark - WTWaterflowDecoratorDataSource

- (UIScrollView *)waterflowScrollView {
    return self.scrollView;
}

- (NSString *)waterflowUnitImageName {
    return @"WTInnerModalViewBg";
}

@end

@interface WTSettingPlainCell ()

@property (nonatomic, copy) NSString *userDefaultKey;

@end

@implementation WTSettingPlainCell

+ (WTSettingPlainCell *)createPlainCell:(NSDictionary *)cellInfo {
    WTSettingPlainCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingPlainCell class]]) {
            result = (WTSettingPlainCell *)view;
            break;
        }
    }
    NSString *cellTitle = NSLocalizedString(cellInfo[kCellTitle], nil);
    NSString *cellAccessoryType = cellInfo[kCellAccessoryType];
    NSString *cellThumbnail = cellInfo[kCellThumbnail];
    result.userDefaultKey = cellInfo[kUserDefaultKey];
    
    result.titleLabel.text = cellTitle;
    if ([cellAccessoryType isEqualToString:kCellAccessoryTypeSwitch]) {
        [result createSwitch];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        BOOL value = [userDefault boolForKey:result.userDefaultKey];
        result.selectSwitch.on = value;
    }
    
    if (cellThumbnail) {
        
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.selectSwitch.isOn forKey:self.userDefaultKey];
    [userDefault synchronize];
}

@end

@interface WTSettingGroupTableView ()

@property (nonatomic, strong) NSMutableArray *cellInfoArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) BOOL supportMultiSelection;
@property (nonatomic, copy) NSString *userDefaultKey;

@end

@implementation WTSettingGroupTableView

+ (WTSettingGroupTableView *)createGroupTableView:(NSDictionary *)tableViewInfo {
    WTSettingGroupTableView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingGroupTableView class]]) {
            result = (WTSettingGroupTableView *)view;
            break;
        }
    }
    
    NSString *headerTitle = NSLocalizedString(tableViewInfo[kTableViewSectionHeader], nil);
    result.headerLabel.text = headerTitle;
    
    result.bgImageView.image = [result.bgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    result.supportMultiSelection = [tableViewInfo[kTableViewSupportsMultiSelection] boolValue];
    result.userDefaultKey = tableViewInfo[kUserDefaultKey];
    
    NSArray *contentArray = tableViewInfo[kTableViewContent];
    for (NSDictionary *cellDict in contentArray) {
        [result addCell:cellDict];
    }
    
    return result;
}

- (NSMutableArray *)cellArray {
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

- (NSMutableArray *)cellInfoArray {
    if (_cellInfoArray == nil) {
        _cellInfoArray = [NSMutableArray array];
    }
    return _cellInfoArray;
}

- (void)addCell:(NSDictionary *)cellInfo {
    NSString *cellTitle = NSLocalizedString(cellInfo[kCellTitle], nil);
    //NSString *cellAccessoryType = cellInfo[kCellAccessoryType];
    NSString *cellThumbnail = cellInfo[kCellThumbnail];
    
    WTSettingGroupCell *cell = [WTSettingGroupCell createGroupCell];
    
    if (cellThumbnail) {
        cellTitle = [NSString stringWithFormat:@"      %@", cellTitle];
        cell.thumbnailImageView.image = [UIImage imageNamed:cellThumbnail];
    }
    
    [cell.cellButton setTitle:cellTitle forState:UIControlStateNormal];
    [cell.cellButton addTarget:self action:@selector(didClickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellInfoArray addObject:cellInfo];
    [self.cellArray addObject:cell];
    
    [self addSubview:cell];
    
    [self configureTableView];
    
    NSUInteger cellIndex = cell.cellButton.tag;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger value = [userDefault integerForKey:self.userDefaultKey];
    NSInteger itemValue = 1 << cellIndex;
    if (self.supportMultiSelection) {
        cell.checkmarkImageView.hidden = !(value & itemValue);
    } else {
        cell.checkmarkImageView.hidden = !(value == itemValue);
    }
}

- (void)configureTableView {
    [self resetHeight:40 + 5 + 44 * self.cellInfoArray.count];
    
    for (int index = 0; index < self.cellArray.count; index++) {
        WTSettingGroupCell *cell = self.cellArray[index];
        cell.separatorImageView.hidden = NO;
        [cell resetOriginY:40 + index * 44];
        cell.cellButton.tag = index;
        
    }
    WTSettingGroupCell *lastCell = self.cellArray.lastObject;
    lastCell.separatorImageView.hidden = YES;
}

#pragma mark - Actions

- (void)didClickCellButton:(UIButton *)sender {
    NSUInteger cellIndex = sender.tag;
    //NSDictionary *cellInfo = self.cellInfoArray[cellIndex];
    
    if (self.supportMultiSelection) {
        WTSettingGroupCell *selectCell = self.cellArray[cellIndex];
        selectCell.checkmarkImageView.hidden = !selectCell.checkmarkImageView.hidden;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSInteger result = [userDefault integerForKey:self.userDefaultKey];
        // Convention
        NSInteger itemValue = 1 << cellIndex;
        if (selectCell.checkmarkImageView.hidden)
            result &=  ~itemValue;
        else
            result |= itemValue;
        [userDefault setInteger:result forKey:self.userDefaultKey];
        [userDefault synchronize];
        NSLog(@"%d, %d", itemValue, result);
    } else {
        for (WTSettingGroupCell *cell in self.cellArray) {
            cell.checkmarkImageView.hidden = YES;
        }
        WTSettingGroupCell *selectCell = self.cellArray[cellIndex];
        selectCell.checkmarkImageView.hidden = NO;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        // Convention
        NSInteger itemValue = 1 << cellIndex;
        [userDefault setInteger:itemValue forKey:self.userDefaultKey];
        [userDefault synchronize];
        
        NSLog(@"%d", itemValue);
    }
}

@end

@implementation WTSettingGroupCell

+ (WTSettingGroupCell *)createGroupCell {
    WTSettingGroupCell *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTSettingCells" owner:self options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTSettingGroupCell class]]) {
            result = (WTSettingGroupCell *)view;
            break;
        }
    }
    
    return result;
}

@end
