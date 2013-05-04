//
//  WTCategoryNewsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCategoryNewsViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "News+Addition.h"
#import "WTNewsSettingViewController.h"
#import "WTResourceFactory.h"

@interface WTCategoryNewsViewController ()

@property (nonatomic, strong) NSNumber *showNewsCategory;

@end

@implementation WTCategoryNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTNewsViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[News convertCategoryStringFromCategory:self.showNewsCategory]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTCategoryNewsViewController *)createViewControllerWithNewsCategory:(NSNumber *)category {
    WTCategoryNewsViewController *result = [[WTCategoryNewsViewController alloc] init];
    result.showNewsCategory = category;
    return result;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureRequest:(NSFetchRequest *)request {
    [super configureRequest:request];
    request.predicate = [NSPredicate predicateWithFormat:@"category == %@", self.showNewsCategory];
}

#pragma mark - Methods to overwrite

- (NSArray *)newsShowTypes {
    return [NSUserDefaults getNewsShowTypesArrayWithNewsShowType:self.showNewsCategory.integerValue];
}

- (WTNewsSettingViewController *)createNewsSettingViewController {
    WTNewsSettingViewController *vc = [[WTNewsSettingViewController alloc] init];
    vc.delegate = self;
    vc.hideCategoryFilter = YES;
    return vc;
}

@end
