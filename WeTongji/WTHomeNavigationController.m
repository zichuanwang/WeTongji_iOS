//
//  WTHomeNavigationController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeNavigationController.h"
#import "WTHomeViewController.h"

@interface WTHomeNavigationController ()

@end

@implementation WTHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    WTHomeViewController *vc = [[WTHomeViewController alloc] init];
    [self pushViewController:vc animated:NO];
}

@end
