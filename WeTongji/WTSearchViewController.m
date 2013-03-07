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

- (void)configureSearchBarCancelButton {
    for (UIView *subView in self.searchBar.subviews) {
        //Find the button
        if([subView isKindOfClass:[UIButton class]])
        {
            //Change its properties
            UIButton *cancelButton = (UIButton *)subView;
            cancelButton.titleLabel.text = @"Changed";
            
            [WTResourceFactory configureNormalButton:cancelButton text:NSLocalizedString(@"Cancel", nil)];
        }
    }
}

- (void)configureSearchBarBg:(BOOL)isShowCancelButton {
    if (isShowCancelButton) {
        UIImage *selectBgImage = [[UIImage imageNamed:@"WTSearchBarSelectBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.searchBar setSearchFieldBackgroundImage:selectBgImage forState:UIControlStateNormal];
        
        UIImage *selectSearchIcon = [UIImage imageNamed:@"WTSearchBarSelectSearchIcon"];
        [self.searchBar setImage:selectSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
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
    
    [self configureSearchBarBg:NO];
    
    UIView *searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270.0f, 44.0F)];
    searchBarContainerView.backgroundColor = [UIColor clearColor];
    [searchBarContainerView addSubview:searchBar];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarContainerView];
    
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
}

- (void)showSearchBarCancelButton:(BOOL)show {
    [self configureSearchBarBg:show];
    [self.searchBar setShowsCancelButton:show animated:YES];
    if (show) {
        // [self configureSearchBarCancelButton];
    }
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelega

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showSearchBarCancelButton:YES];
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self showSearchBarCancelButton:NO];
    [searchBar resignFirstResponder];
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
