//
//  WTNotificationModalViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerModalViewController.h"

@interface WTInnerModalViewController ()

@end

@implementation WTInnerModalViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTModalViewBg"]];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.view resetHeight:screenSize.height - 20 - 44 - 41];
    
    UIImage *topShadowImage = [UIImage imageNamed:@"WTTopShadow"];
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithImage:topShadowImage];
    [topShadowImageView resetSize:CGSizeMake(screenSize.width, 6)];
    [topShadowImageView resetOrigin:CGPointMake(0, self.view.frame.size.height - 6)];
    
    [self.view addSubview:topShadowImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
