//
//  WTFirstViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-6.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTFirstViewController.h"

@interface WTFirstViewController ()

@end

@implementation WTFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
