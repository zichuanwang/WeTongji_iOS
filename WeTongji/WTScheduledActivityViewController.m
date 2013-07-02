//
//  WTScheduledActivityViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTScheduledActivityViewController.h"
#import "User+Addition.h"
#import "WTResourceFactory.h"
#import "NSUserDefaults+WTAddition.h"
#import "Controller+Addition.h"
#import "Activity+Addition.h"
#import "Object+Addition.h"

@interface WTScheduledActivityViewController ()

@property (nonatomic, strong) User *user;

@end

@implementation WTScheduledActivityViewController

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
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.user.name target:self action:@selector(didClickBackButton:)];
}

+ (WTScheduledActivityViewController *)createViewControllerWithUser:(User *)user {
    WTScheduledActivityViewController *result = [[WTScheduledActivityViewController alloc] init];
    
    result.user = user;
    
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureLoadedActivity:(Activity *)activity {
    [activity setObjectHeldByHolder:[self class]];
    [activity addScheduledByObject:self.user];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [super configureFetchRequest:request];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(category in %@) AND (SELF in %@) AND (SELF in %@)", [NSUserDefaults getActivityShowTypesSet], [Controller controllerModelForClass:[self class]].hasObjects, self.user.scheduledEvents]];
    
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
                  scheduledByUser:self.user.identifier];
}

@end
