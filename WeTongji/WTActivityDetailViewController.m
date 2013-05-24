//
//  WTEventDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityDetailViewController.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"
#import "WTBannerView.h"
#import "Activity+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"
#import "WTActivityDetailDescriptionView.h"
#import "WTDetailImageViewController.h"
#import "WTActivityHeaderView.h"

@interface WTActivityDetailViewController () <WTDetaiImageViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) WTActivityHeaderView *headerView;
@property (nonatomic, strong) WTBannerContainerView *bannerView;
@property (nonatomic, strong) WTActivityDetailDescriptionView *detailDescriptionView;

@property (nonatomic, strong) Activity *activity;

- (IBAction)didClickOrganizerIndicator;
- (IBAction)didClickLocationIndicator;

@end

@implementation WTActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (WTActivityDetailViewController *)createDetailViewControllerWithActivity:(Activity *)activity
                                                         backBarButtonText:(NSString *)backBarButtonText {
    WTActivityDetailViewController *result = [[WTActivityDetailViewController alloc] init];
    result.activity = activity;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureLikeButton];
    [self configureHeaderView];
    [self configureBannerView];
    [self configureDetailDescriptionView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.detailDescriptionView.frame.origin.y + self.detailDescriptionView.frame.size.height);
}

#pragma mark Configure header view

- (void)configureHeaderView {
    self.headerView = [WTActivityHeaderView createHeaderViewWithActivity:self.activity];
    [self.scrollView addSubview:self.headerView];
    
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Configure like button 

- (void)configureLikeButton {
    self.likeButtonContainerView.likeButton.selected = !self.activity.canLike.boolValue;
    [self.likeButtonContainerView setLikeCount:self.activity.likeCount.integerValue];
}

#pragma mark Configure banner view

- (void)configureBannerView {
    if (self.activity.image) {
        self.bannerView = [WTBannerContainerView createBannerContainerView];
        [self.bannerView resetOrigin:CGPointMake(0, self.headerView.frame.origin.y + self.headerView.frame.size.height)];
        [self.bannerView addItemViewWithImageURL:self.activity.image
                                       titleText:self.activity.what
                                organizationName:self.activity.organizer
                                           style:WTBannerItemViewStyleClear];
        [self.scrollView insertSubview:self.bannerView atIndex:0];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagBannerView:)];
        [self.bannerView.bannerScrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

#pragma mark Configure detail descriptioin view

- (void)configureDetailDescriptionView {
    self.detailDescriptionView = [WTActivityDetailDescriptionView createDetailDescriptionView];
    [self.detailDescriptionView configureViewWithManagedObject:self.activity];
    if (self.bannerView) {
        [self.detailDescriptionView resetOriginY:self.bannerView.frame.origin.y + self.bannerView.frame.size.height];
    } else {
        [self.detailDescriptionView resetOriginY:self.headerView.frame.size.height];
    }
    [self.scrollView insertSubview:self.detailDescriptionView atIndex:0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.headerView.showingBottomButtons) {
        CGFloat briefDescriptionViewTopIndent = self.headerView.frame.size.height - HEADER_VIEW_BOTTOM_INDENT;
        if (scrollView.contentOffset.y > briefDescriptionViewTopIndent) {
            [self.headerView resetOriginY:scrollView.contentOffset.y - briefDescriptionViewTopIndent];
        } else {
            [self.headerView resetOriginY:0];
        }
    }
}

#pragma mark - Handle gesture methods

- (void)didTagBannerView:(UITapGestureRecognizer *)gesture {
    WTBannerItemView *currentBannerItemView = [self.bannerView currentItemView];
    UIImageView *currentBannerImageView = currentBannerItemView.imageView;
    CGRect imageViewFrame = [self.view convertRect:currentBannerImageView.frame fromView:currentBannerImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.activity.image
                                                         fromImageView:currentBannerImageView
                                                              fromRect:imageViewFrame
                                                              delegate:self];
}

#pragma mark - Actions

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set activitiy liked:%d succeeded", sender.selected);
        self.activity.likeCount = @(self.activity.likeCount.integerValue + (sender.selected ? 1 : (-1)));
        [self.likeButtonContainerView setLikeCount:self.activity.likeCount.integerValue];
        self.activity.canLike = @(!sender.selected);
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set activitiy liked:%d, reason:%@", sender.selected, error.localizedDescription);
        sender.selected = !sender.selected;
        
        [WTErrorHandler handleError:error];
    }];
    [request setActivitiyLiked:sender.selected activityID:self.activity.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickInviteButton:(UIButton *)sender {
    NSLog(@"Invite button clicked");
}

- (void)didClickFriendCountButton:(UIButton *)sender {
    NSLog(@"Friend count button clicked");
}

- (void)didClickParticipateButton:(UIButton *)sender {
    BOOL participated = sender.selected;
    [self.headerView configureParticipateButtonStatus:participated];
    
    if (participated) {
        [self.headerView.inviteButton fadeIn];
        [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:self.activity];
    }
    else {
        [self.headerView.inviteButton fadeOut];
        [[WTCoreDataManager sharedManager].currentUser removeScheduledEventsObject:self.activity];
    }
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set activitiy scheduled:%d succeeded", participated);
        sender.userInteractionEnabled = YES;
        self.activity.canSchedule = @(!self.activity.canSchedule.boolValue);
        
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set activitiy scheduled:%d, reason:%@", participated, error.localizedDescription);
        sender.userInteractionEnabled = YES;
        [self.headerView configureParticipateButtonStatus:!participated];
        
        if (!participated) {
            [self.headerView.inviteButton fadeIn];
            [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:self.activity];
        }
        else {
            [self.headerView.inviteButton fadeOut];
            [[WTCoreDataManager sharedManager].currentUser removeScheduledEventsObject:self.activity];
        }
        
        [WTErrorHandler handleError:error];
    }];
    
    [request setActivityScheduled:participated activityID:self.activity.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickOrganizerIndicator {
    NSLog(@"Organizer Indicator button clicked");
}

- (void)didClickLocationIndicator {
    NSLog(@"Location Indicator button clicked");
}

#pragma mark - WTDetailImageViewControllerDelegate

- (void)detailImageViewControllerDidDismiss:(NSUInteger)currentPage {
    self.bannerView.bannerScrollView.contentOffset = CGPointMake(self.bannerView.frame.size.width * currentPage, 0);
    self.bannerView.bannerPageControl.currentPage = currentPage;
    [self.bannerView reloadItemImages];
}

@end
