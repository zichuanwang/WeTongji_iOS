//
//  WTTabBarViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTTabBarViewController.h"

@interface WTTabBarViewController ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIImageView *bgImageView;

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
    [self addCustomTabBarBg];
    [self hideBuiltInTabBar];
    [self showCustomTabBar];
    
    self.selectedIndex = 2;
}

#pragma mark - UI methods

- (void)addCustomTabBarBg {
    UIImage *bgImage = [UIImage imageNamed:@"WTTabBarBg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    bgImageView.frame = CGRectMake(0, screenSize.height - bgImage.size.height, screenSize.width, bgImage.size.height);
    
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.bgImageView = bgImageView;
    self.bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
}

- (void)hideBuiltInTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)showCustomTabBar{
	int viewCount = self.viewControllers.count;
	self.buttonArray = [NSMutableArray arrayWithCapacity:viewCount];
	for (int i = 0; i < viewCount; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.tag = i;
		[btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(64 * i, 0, 64, 50);
		switch (i) {
            case 0: {
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonHome"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonHomeHl"] forState:UIControlStateSelected];
                break;
            }
            case 1: {
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonNow"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonNowHl"] forState:UIControlStateSelected];
                break;
            }
            case 2: {
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonPowerSearch"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonPowerSearchHl"] forState:UIControlStateSelected];
                break;
            }
            case 3: {
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonBillBoard"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonBillBoardHl"] forState:UIControlStateSelected];
                break;
            }
            case 4: {
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonMe"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"WTTabBarButtonMeHl"] forState:UIControlStateSelected];
                break;
            }
        }
		[self.buttonArray addObject:btn];
		[self.bgImageView addSubview:btn];
	}
    ((UIButton *)self.buttonArray[0]).selected = YES;
}

- (void)selectTab:(UIButton *)button {
    if (self.selectedIndex == button.tag) {
        //[[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:YES];
        return;
    }

    self.selectedIndex = button.tag;
    // button.tag==4时似乎系统有bug，用下面的方法折衷
    if (button.tag == 4) {
        self.selectedViewController = [self.viewControllers lastObject];
    }
    
    for (UIButton* btn in self.buttonArray) {
        [btn setSelected:NO];
    }
    [button setSelected:YES];
}

@end
