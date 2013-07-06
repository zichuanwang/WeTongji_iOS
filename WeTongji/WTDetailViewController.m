//
//  WTDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailViewController.h"
#import "WTLikeButtonView.h"
#import "WTResourceFactory.h"

@interface WTDetailViewController ()

@property (nonatomic, weak) WTLikeButtonView *likeButtonContainerView;

@end

@implementation WTDetailViewController

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
    [self configureNavigationBar];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

#pragma mark - UI methods

#pragma mark Configure navigation bar

- (void)configureNavigationBarBackButton {
    UIBarButtonItem *backBarButtonItem = nil;
    if (self.backBarButtonText)
        backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backBarButtonText target:self action:@selector(didClickBackButton:)];
    else
        backBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)configureNavigationBarRightButtons {
    UIButton *commentButton = [[UIButton alloc] init];
    commentButton.showsTouchWhenHighlighted = YES;
    commentButton.adjustsImageWhenHighlighted = NO;
    UIImage *commentImage = [UIImage imageNamed:@"WTCommentButton"];
    [commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
    [commentButton resetSize:commentImage.size];
    [commentButton addTarget:self action:@selector(didClickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreButton = [[UIButton alloc] init];
    moreButton.showsTouchWhenHighlighted = YES;
    moreButton.adjustsImageWhenHighlighted = NO;
    UIImage *moreImage = [UIImage imageNamed:@"WTMoreButton"];
    [moreButton resetSize:moreImage.size];
    [moreButton setBackgroundImage:moreImage forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barCommentButton = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    barCommentButton = nil;
    
    UIBarButtonItem *barMoreButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    WTLikeButtonView *likeButtonContainerView = [WTLikeButtonView createLikeButtonViewWithObject:[self targetObject]];
    self.likeButtonContainerView = likeButtonContainerView;
    
    UIBarButtonItem *barLikeButton = [[UIBarButtonItem alloc] initWithCustomView:likeButtonContainerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"WTTransparentImage"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
//    [buttons addObject:barCommentButton];
//    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barMoreButton];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barLikeButton];
    
    [toolbar setItems:buttons animated:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)configureNavigationBar {
    [self configureNavigationBarBackButton];
    [self configureNavigationBarRightButtons];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickCommentButton:(UIButton *)sender {
    
}

- (void)didClickMoreButton:(UIButton *)sender {
    
}

- (LikeableObject *)targetObject {
    return nil;
}

@end
