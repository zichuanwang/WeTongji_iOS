//
//  WTUserDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserDetailViewController.h"
#import "User+Addition.h"

@interface WTUserDetailViewController ()

@property (nonatomic, strong) User *user;

@end

@implementation WTUserDetailViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTUserDetailViewController *)createDetailViewControllerWithUser:(User *)user
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTUserDetailViewController *result = [[WTUserDetailViewController alloc] init];

    result.user = user;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

@end
