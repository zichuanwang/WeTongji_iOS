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
#import "User+Addition.h"
#import "WTSearchHintView.h"

@interface WTSearchViewController () <UITableViewDelegate>

@property (nonatomic, weak) UIButton *customSearchBarCancelButton;

@property (nonatomic, strong) WTSearchHintView *searchHintView;

@property (nonatomic, assign) BOOL shouldSearchBarBecomeFirstResponder;

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
    
    [self configureSearchHintView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard notification

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self configureSearchHintViewSizeWithKeyboardHeight:keyboardHeight];
}

#pragma mark - UI methods

- (void)configureSearchHintViewSizeWithKeyboardHeight:(CGFloat)keyboardHeight {
    CGFloat visibleScreenHeight = [UIScreen mainScreen].bounds.size.height - 64.0f - keyboardHeight;
    [self.searchHintView resetHeight:visibleScreenHeight];
}

- (void)configureSearchHintView {
    self.searchHintView = [WTSearchHintView createSearchHintView];
    self.searchHintView.hidden = YES;
    self.searchHintView.tableView.delegate = self;
    [self.view addSubview:self.searchHintView];
}

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

#pragma mark - WTRootNavigationControllerDelegate

- (void)didHideInnderModalViewController {
    [super didHideInnderModalViewController];
    
    if (self.shouldSearchBarBecomeFirstResponder) {
        self.shouldSearchBarBecomeFirstResponder = NO;
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchHintView.tableView) {
        
    }
}

#pragma mark - Actions

- (void)didClickCustomSearchBarCancelButton:(UIButton *)sender {
    [self showSearchBarCancelButton:NO];
    [self.searchBar resignFirstResponder];
    self.searchHintView.hidden = YES;
}

- (void)didClickNotificationButton:(WTNotificationBarButton *)sender {
    if (!sender.selected) {
        if (self.searchBar.isFirstResponder) {
            self.shouldSearchBarBecomeFirstResponder = YES;
            [self.searchBar resignFirstResponder];
        }
    }
    [super didClickNotificationButton:sender];
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelega

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showSearchBarCancelButton:YES];
    self.searchHintView.hidden = NO;
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchHintView.searchKeyWord = searchText;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    return;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Search user result:%@", responseObject);
        NSDictionary *responseDict = responseObject;
        // TODO: 实际应该为Array
        NSDictionary *searchResultUserDict = responseDict[@"User"];
        User *result = [User insertUser:searchResultUserDict];
        WTLOG(@"Search user:%@", searchResultUserDict);
        [self inviteFriend:result];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Search user:%@", error.localizedDescription);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"搜索失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }];
    [request search:searchBar.text];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)inviteFriend:(User *)user {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Invite friend:%@", responseObject);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加好友" message:[NSString stringWithFormat:@"已经添加 %@ 为好友。", user.name] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Invite friend:%@", error.localizedDescription);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加好友失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }];
    [request inviteFriend:user.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
