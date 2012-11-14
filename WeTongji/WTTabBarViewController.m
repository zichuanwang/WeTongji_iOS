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
    
    [self didClickTabBarButton:self.buttonArray[0]];
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
		[btn addTarget:self action:@selector(didClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(64 * i, 0, 64, 50);
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
		switch (i) {
            case 0: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonHome"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonHomeHl"];
                break;
            }
            case 1: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonNow"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonNowHl"];
                break;
            }
            case 2: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearch"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearchHl"];
                break;
            }
            case 3: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoard"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoardHl"];
                break;
            }
            case 4: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonMe"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonMeHl"];
                break;
            }
        }
        [btn setImage:normalStateImage forState:UIControlStateNormal];
        [btn setImage:selectStateImage forState:UIControlStateSelected];
        
		[self.buttonArray addObject:btn];
		[self.bgImageView addSubview:btn];
	}
    ((UIButton *)self.buttonArray[0]).selected = YES;
}

#pragma mark - Actions 

- (void)didDragEnterTabBarButton:(UIButton *)button {
    NSLog(@"drag enter");
}

- (void)didClickTabBarButton:(UIButton *)button {
    self.selectedIndex = button.tag;
    
    // button.tag==4时似乎系统有bug，用下面的方法折衷
    if (button.tag == 4) {
        self.selectedViewController = [self.viewControllers lastObject];
    }
    
    for (UIButton* btn in self.buttonArray) {
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    
    button.selected = YES;
    button.userInteractionEnabled = NO;
}

@end
