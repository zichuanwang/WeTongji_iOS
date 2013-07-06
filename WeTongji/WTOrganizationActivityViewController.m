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
#import "Controller+Addition.h"
#import "Activity+Addition.h"
#import "Object+Addition.h"

@interface WTOrganizationActivityViewController ()

@property (nonatomic, strong) Organization *org;

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
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.org.name target:self action:@selector(didClickBackButton:)];
}

+ (WTOrganizationActivityViewController *)createViewControllerWithOrganization:(Organization *)org {
    WTOrganizationActivityViewController *result = [[WTOrganizationActivityViewController alloc] init];
    
    result.org = org;
        
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureLoadedActivity:(Activity *)activity {
    [activity setObjectHeldByHolder:[self class]];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [super configureFetchRequest:request];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(category in %@) AND (SELF in %@) AND (SELF in %@)", [NSUserDefaults getActivityShowTypesSet], [Controller controllerModelForClass:[self class]].hasObjects, self.org.publishedActivities]];
    
    if ([[NSUserDefaults standardUserDefaults] getActivityHidePastProperty]) {
        [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[request.predicate, [NSPredicate predicateWithFormat:@"endTime > %@", [NSDate date]]
                               ]]];
    }
}

- (void)clearOutdatedData {
    NSSet *activityShowTypesSet = [NSUserDefaults getActivityShowTypesSet];
    for (NSNumber *showTypeNumber in activityShowTypesSet) {
        [Activity setOutdatedActivitesFreeFromHolder:[self class] inCategory:showTypeNumber];
    }
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
