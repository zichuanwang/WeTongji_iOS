//
//  WTStarDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarDetailViewController.h"
#import "Star+Addition.h"

@interface WTStarDetailViewController ()

@property (nonatomic, strong) Star *star;

@end

@implementation WTStarDetailViewController

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

+ (WTStarDetailViewController *)createDetailViewControllerWithStar:(Star *)star
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTStarDetailViewController *result = [[WTStarDetailViewController alloc] init];
    
    result.star = star;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

@end
