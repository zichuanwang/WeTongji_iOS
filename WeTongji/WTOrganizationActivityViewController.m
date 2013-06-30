//
//  WTOrganizationActivityViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationActivityViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "Organization+Addition.h"
#import "WTResourceFactory.h"

@interface WTOrganizationActivityViewController ()

@property (nonatomic, strong) Organization *org;

@property (nonatomic, copy) NSString *backBarButtonText;

@end

@implementation WTOrganizationActivityViewController

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
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backBarButtonText target:self action:@selector(didClickBackButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTOrganizationActivityViewController *)createViewControllerWithOrganization:(Organization *)org backBarButtonText:(NSString *)backBarButtonText {
    WTOrganizationActivityViewController *result = [[WTOrganizationActivityViewController alloc] init];
    
    result.org = org;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [super configureFetchRequest:request];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[request.predicate, [NSPredicate predicateWithFormat:@"SELF in %@", self.org.publishedActivities]]]];
}

- (void)configureLoadDataRequest:(WTRequest *)request {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getActivitiesInTypes:[NSUserDefaults getActivityShowTypesArray]
                      orderMethod:[userDefaults getActivityOrderMethod]
                       smartOrder:[userDefaults getActivitySmartOrderProperty]
                       showExpire:![userDefaults getActivityHidePastProperty]
                             page:self.nextPage
                        byAccount:self.org.identifier];
}

@end
