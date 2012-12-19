//
//  WTEventDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTEventDetailViewController.h"
#import "WTResourceFactory.h"

@interface WTEventDetailViewController ()

@end

@implementation WTEventDetailViewController

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
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    // back button
    UIButton *backButton = [WTResourceFactory createNavBarBackButtonWithText:@"10:00"];
    UIView *containerView = [[UIView alloc] initWithFrame:backButton.frame];
    [backButton resetOrigin:CGPointMake(0, 2)];
    [containerView addSubview:backButton];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
     // right buttons
    UIButton *commentButton = [[UIButton alloc] init];
    UIImage *commentImage = [UIImage imageNamed:@"WTCommentButton"];
    [commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
    [commentButton resetSize:commentImage.size];
    
    UIButton *moreButton = [[UIButton alloc] init];
    UIImage *moreImage = [UIImage imageNamed:@"WTMoreButton"];
    [moreButton resetSize:moreImage.size];
    [moreButton setBackgroundImage:moreImage forState:UIControlStateNormal];

    UIButton *likeButton = [[UIButton alloc] init];
    UIImage *likeNormalImage = [UIImage imageNamed:@"WTLikeNormalButton"];
    UIImage *likeSelectImage = [UIImage imageNamed:@"WTLikeSelectButton"];
    [likeButton setBackgroundImage:likeNormalImage forState:UIControlStateNormal];
    [likeButton setBackgroundImage:likeSelectImage forState:UIControlStateSelected];
    [likeButton resetSize:likeNormalImage.size];
    [likeButton addTarget:self action:@selector(didClickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    if (toolbar.subviews.count > 0)
        [[toolbar.subviews objectAtIndex:0] removeFromSuperview];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    UIBarButtonItem *barCommentButton = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    UIBarButtonItem *barMoreButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    UIBarButtonItem *barLikeButton = [[UIBarButtonItem alloc] initWithCustomView:likeButton];
    
    [buttons addObject:barCommentButton];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barMoreButton];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barLikeButton];
    
//    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    bi.width = -30;
//    [buttons addObject:bi];
    
    [toolbar setItems:buttons animated:NO];
    
//    UIImageView *likeFlagBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTLikeButtonFlagBg"]];
//    [likeFlagBg resetOrigin:CGPointMake(260, 0)];
//    [self.navigationController.navigationBar addSubview:likeFlagBg];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}


@end
