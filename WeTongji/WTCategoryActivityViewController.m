//
//  WTCategoryActivityViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCategoryActivityViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "Activity+Addition.h"
#import "WTResourceFactory.h"
#import "WTActivitySettingViewController.h"

@interface WTCategoryActivityViewController ()

@property (nonatomic, strong) NSNumber *showActivityCategory;

@end

@implementation WTCategoryActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTActivityViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[Activity convertCategoryStringFromCategory:self.showActivityCategory]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTCategoryActivityViewController *)createViewControllerWithActivityCategory:(NSNumber *)category {
    WTCategoryActivityViewController *result = [[WTCategoryActivityViewController alloc] init];
    result.showActivityCategory = category;
    return result;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureRequest:(NSFetchRequest *)request {
    [super configureRequest:request];
    request.predicate = [NSPredicate predicateWithFormat:@"category == %@", self.showActivityCategory];
}

#pragma mark - Methods to overwrite

- (NSArray *)activityShowTypes {
    return [NSUserDefaults getActivityShowTypesArrayWithActivityShowType:self.showActivityCategory.integerValue];
}

- (WTActivitySettingViewController *)createActivitySettingViewController {
    WTActivitySettingViewController *vc = [[WTActivitySettingViewController alloc] init];
    vc.delegate = self;
    vc.hideCategoryFilter = YES;
    return vc;
}

@end
