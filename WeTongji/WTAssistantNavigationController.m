//
//  WTAssistantNavigationController.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTAssistantNavigationController.h"
#import "WTAssistantViewController.h"

@interface WTAssistantNavigationController ()

@end

@implementation WTAssistantNavigationController

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
    WTAssistantViewController *vc = [[WTAssistantViewController alloc] init];
    [self pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
