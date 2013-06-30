//
//  WTOrganizationNewsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationNewsViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "Organization+Addition.h"
#import "WTResourceFactory.h"

@interface WTOrganizationNewsViewController ()

@property (nonatomic, strong) Organization *org;

@end

@implementation WTOrganizationNewsViewController

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
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.org.name target:self action:@selector(didClickBackButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTOrganizationNewsViewController *)createViewControllerWithOrganization:(Organization *)org {
    WTOrganizationNewsViewController *result = [[WTOrganizationNewsViewController alloc] init];
    
    result.org = org;
    
    return result;
}

#pragma mark - Methods to overwrite

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [super configureFetchRequest:request];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[request.predicate, [NSPredicate predicateWithFormat:@"SELF in %@", self.org.publishedNews]]]];
}

- (void)configureLoadDataRequest:(WTRequest *)request {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getInformationInTypes:[NSUserDefaults getNewsShowTypesArray]
                       orderMethod:[userDefaults getNewsOrderMethod]
                        smartOrder:[userDefaults getNewsSmartOrderProperty]
                              page:self.nextPage
                         byAccount:self.org.identifier];
}

@end
