//
//  WTTabBarViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTTabBarViewController.h"

@interface WTTabBarViewController ()

@property (nonatomic, strong) WTTabBar *customTabBar;

@end

@implementation WTTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCustomTabBar];
    [self hideBuiltInTabBar];
}

#pragma mark - UI methods

- (void)addCustomTabBar {
    WTTabBar *view = [[WTTabBar alloc] init];
    self.customTabBar = view;
    self.customTabBar.delegate = self;
    [self.view addSubview:self.customTabBar];
}

- (void)hideBuiltInTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

#pragma mark - Actions 

- (void)didClickTabBarButton:(UIButton *)button {
    
}

#pragma mark - WTTabBarDelegate

- (void)WTTabBar:(WTTabBar *)view
               didClickTabBarButton:(UIButton *)button {
    self.selectedIndex = button.tag;
    
    // button.tag==4时似乎系统有bug，用下面的方法折衷
    if(button.tag == 4) {
        self.selectedViewController = [self.viewControllers lastObject];
    }
}

@end
