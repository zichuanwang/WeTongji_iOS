//
//  WTSearchViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTResourceFactory.h"

@interface WTSearchViewController ()

@property (nonatomic, weak) UIButton *customSearchBarCancelButton;

@end

@implementation WTSearchViewController

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
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)]];
    
    [self configureNavigationBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureSearchBarBgWithControlState:(UIControlState)state {
    if (state == UIControlStateSelected) {
        UIImage *selectBgImage = [[UIImage imageNamed:@"WTSearchBarSelectBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.searchBar setSearchFieldBackgroundImage:selectBgImage forState:UIControlStateNormal];
        
        UIImage *selectSearchIcon = [UIImage imageNamed:@"WTSearchBarSelectSearchIcon"];
        [self.searchBar setImage:selectSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        
    } else if (state == UIControlStateNormal) {
        UIImage *normalBgImage = [[UIImage imageNamed:@"WTSearchBarNormalBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.searchBar setSearchFieldBackgroundImage:normalBgImage forState:UIControlStateNormal];
        
        UIImage *nornalSearchIcon = [UIImage imageNamed:@"WTSearchBarNormalSearchIcon"];
        [self.searchBar setImage:nornalSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
}

- (void)configureNavigationBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 1.0f, 270.0f, 44.0f)];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    
    [searchBar.subviews[0] removeFromSuperview];
    [self addCustomCancelButtonToSearchBar];
    [self showCustomSearchBarCancelButton:NO animated:NO];
    [self configureSearchBarBgWithControlState:UIControlStateNormal];
    
    UIView *searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270.0f, 44.0f)];
    searchBarContainerView.backgroundColor = [UIColor clearColor];
    [searchBarContainerView addSubview:searchBar];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarContainerView];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
}

#define CUSTOM_SEARCH_BAR_CANCEL_BUTTNO_TAG 10000

- (void)addCustomCancelButtonToSearchBar {
    UIButton *customSearchBarCancelButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Cancel", nil)];
    [customSearchBarCancelButton resetOriginY:1.0f];
    [customSearchBarCancelButton resetOriginX:self.searchBar.frame.size.width - customSearchBarCancelButton.frame.size.width];
    customSearchBarCancelButton.tag = CUSTOM_SEARCH_BAR_CANCEL_BUTTNO_TAG;
    [customSearchBarCancelButton addTarget:self action:@selector(didClickCustomSearchBarCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:customSearchBarCancelButton];
    self.customSearchBarCancelButton = customSearchBarCancelButton;
}

- (void)hideOriginalSearchBarCancelButton {
    for (UIView *subView in self.searchBar.subviews) {
        if([subView isKindOfClass:[UIButton class]] && subView.tag != CUSTOM_SEARCH_BAR_CANCEL_BUTTNO_TAG)
        {
            subView.hidden = YES;
        }
    }
}

- (void)showCustomSearchBarCancelButton:(BOOL)show animated:(BOOL)animated {
    [self hideOriginalSearchBarCancelButton];
    if (animated) {
        CGFloat customCancelButtonOriginX = self.customSearchBarCancelButton.frame.origin.x;
        CGFloat customCacnelButtonWidth = self.customSearchBarCancelButton.frame.size.width;
        self.searchBar.userInteractionEnabled = NO;
        
        if (show) {
            self.customSearchBarCancelButton.alpha = 0;
            [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX + customCacnelButtonWidth];
        } else {
            self.customSearchBarCancelButton.alpha = 1;
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            if (show) {
                [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX];
                self.customSearchBarCancelButton.alpha = 1;
            } else {
                [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX + customCacnelButtonWidth];
                self.customSearchBarCancelButton.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self.customSearchBarCancelButton resetOriginX:customCancelButtonOriginX];
            self.searchBar.userInteractionEnabled = YES;
        }];
    } else {
        if (show) {
            self.customSearchBarCancelButton.alpha = 1;
        } else {
            self.customSearchBarCancelButton.alpha = 0;
        }
    }
}

- (void)showSearchBarCancelButton:(BOOL)show {
    if (self.searchBar.showsCancelButton == show)
        return;
    
    [self configureSearchBarBgWithControlState:show ? UIControlStateSelected : UIControlStateNormal];
    [self.searchBar setShowsCancelButton:show animated:YES];
    [self showCustomSearchBarCancelButton:show animated:YES];
}

#pragma mark - Actions

- (void)didClickCustomSearchBarCancelButton:(UIButton *)sender {
    self.searchBar.text = @"";
    [self showSearchBarCancelButton:NO];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelega

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showSearchBarCancelButton:YES];
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    WTClient *client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Search user response:%@", responseObject);
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Search user:%@", error.localizedDescription);
    }];
    [request search:searchBar.text];
    [client enqueueRequest:request];
}

@end
