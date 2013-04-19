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
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"
#import "WTActivityDetailDescriptionView.h"

@interface WTActivityDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *briefIntroductionView;
@property (nonatomic, weak) IBOutlet UILabel *activityTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *activityLocationButton;
@property (nonatomic, weak) IBOutlet UIImageView *activityLocationDisclosureImageView;

@property (nonatomic, strong) UIButton *friendCountButton;
@property (nonatomic, strong) UIButton *participateButton;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, assign) BOOL showingBriefIntroViewBottomButtons;

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

+ (WTActivityDetailViewController *)createActivityDetailViewControllerWithActivity:(Activity *)activity
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
    [self configureRootViewBackgroundColor];
    [self configureLikeButton];
    [self configureBriefIntroductionView];
    [self configureBannerView];
    [self configureDetailDescriptionView];
    [self configureScrollView];
}

- (void)configureRootViewBackgroundColor {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.detailDescriptionView.frame.origin.y + self.detailDescriptionView.frame.size.height);
}

#pragma mark Configure like button 

- (void)configureLikeButton {
    self.likeButtonContainerView.likeButton.selected = !self.activity.canLike.boolValue;
    [self.likeButtonContainerView setLikeCount:self.activity.likeCount.integerValue];
}

#pragma mark Configure brief introduction view

- (void)configureActivityLocationButton {
    [self.activityLocationButton setTitle:self.activity.where forState:UIControlStateNormal];
    CGFloat locationButtonHeight = self.activityLocationButton.frame.size.height;
    CGFloat locationButtonCenterY = self.activityLocationButton.center.y;
    CGFloat locationButtonRightBoundX = self.activityLocationButton.frame.origin.x + self.activityLocationButton.frame.size
    .width;
    [self.activityLocationButton sizeToFit];
    
    CGFloat maxLocationButtonWidth = 282.0f;
    if (self.activityLocationButton.frame.size.width > maxLocationButtonWidth) {
        [self.activityLocationButton resetWidth:maxLocationButtonWidth];
    }
    
    [self.activityLocationButton resetHeight:locationButtonHeight];
    [self.activityLocationButton resetCenterY:locationButtonCenterY];
    [self.activityLocationButton resetOriginX:locationButtonRightBoundX - self.activityLocationButton.frame.size.width];
}

#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH    85.0f
#define MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y 83.0f

- (void)configureInviteButton {
    self.inviteButton = [WTResourceFactory createFocusButtonWithText:NSLocalizedString(@"Invite", nil)];
    
    if (self.inviteButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.inviteButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.inviteButton resetOrigin:CGPointMake(9.0, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.inviteButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.briefIntroductionView addSubview:self.inviteButton];
    
    if (self.activity.canSchedule.boolValue) {
        self.inviteButton.alpha = 0;
    }
}

- (void)configureParticipateButton {
    self.participateButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Participate", nil)];
    
    if (self.participateButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.participateButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.participateButton resetOrigin:CGPointMake(311.0f - self.participateButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.participateButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self configureParticipateButtonStatus:!self.activity.canSchedule.boolValue];
    
    [self.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];    
    [self.briefIntroductionView addSubview:self.participateButton];
}

- (void)configureFriendCountButton {
    NSString *friendCountString = [NSString stringWithFormat:@"%d Friends", 3];
    self.friendCountButton = [WTResourceFactory createNormalButtonWithText:friendCountString];
    if (self.friendCountButton.frame.size.width < MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH)
        [self.friendCountButton resetWidth:MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_WIDTH];
    
    [self.friendCountButton resetOrigin:CGPointMake(self.participateButton.frame.origin.x - 8 - self.friendCountButton.frame.size.width, MIN_BRIEF_INTRODUCTION_VIEW_BUTTON_ORIGIN_Y)];
    self.friendCountButton.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    
    [self.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.briefIntroductionView addSubview:self.friendCountButton];
}

- (void)configureActivityTimeLabel {
    self.activityTimeLabel.text = self.activity.yearMonthDayBeginToEndTimeString;
}

#define BRIEF_DESCRIPTION_VIEW_BOTTOM_BUTTONS_HEIGHT    40.0f

- (void)configureActivityTitleLabelAndCalculateBriefIntroductionViewHeight {
    self.activityTitleLabel.text = self.activity.what;
    
    CGFloat titleLabelOriginalHeight = self.activityTitleLabel.frame.size.height;
    [self.activityTitleLabel sizeToFit];
    [self.briefIntroductionView resetHeight:self.briefIntroductionView.frame.size.height + self.activityTitleLabel.frame.size.height - titleLabelOriginalHeight];
    
    if (!self.showingBriefIntroViewBottomButtons) {
        self.activityTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        self.activityLocationButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        self.activityLocationDisclosureImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.briefIntroductionView resetHeight:self.briefIntroductionView.frame.size.height - BRIEF_DESCRIPTION_VIEW_BOTTOM_BUTTONS_HEIGHT];
    }
}

- (void)configureBriefIntroductionViewBackgroundColor {
    self.briefIntroductionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configureBriefIntroductionViewBottomButtons {
    self.showingBriefIntroViewBottomButtons = ([self.activity.endTime compare:[NSDate date]] == NSOrderedDescending);
    if (self.showingBriefIntroViewBottomButtons) {
        [self configureInviteButton];
        [self configureParticipateButton];
        [self configureFriendCountButton];
    }
}

- (void)configureBriefIntroductionView {
    [self configureBriefIntroductionViewBackgroundColor];
    [self configureActivityLocationButton];
    [self configureBriefIntroductionViewBottomButtons];
    [self configureActivityTimeLabel];
    [self configureActivityTitleLabelAndCalculateBriefIntroductionViewHeight];
}

#pragma mark Configure banner view

- (void)configureBannerView {
    if (![self.activity.image isEmptyImageURL]) {
        self.bannerView = [WTBannerContainerView createBannerContainerView];
        [self.bannerView resetOrigin:CGPointMake(0, self.briefIntroductionView.frame.origin.y + self.briefIntroductionView.frame.size.height)];
        [self.bannerView addItemViewWithImageURL:self.activity.image
                                       titleText:self.activity.what
                                organizationName:self.activity.organizer
                                           style:WTBannerItemViewStyleClear
                                         atIndex:0];
        [self.scrollView insertSubview:self.bannerView atIndex:0];
    }
}

#pragma mark Configure detail descriptioin view

- (void)configureDetailDescriptionView {
    self.detailDescriptionView = [WTActivityDetailDescriptionView createDetailDescriptionView];
    [self.detailDescriptionView configureViewWithManagedObject:self.activity];
    if (self.bannerView) {
        [self.detailDescriptionView resetOriginY:self.bannerView.frame.origin.y + self.bannerView.frame.size.height];
    } else {
        [self.detailDescriptionView resetOriginY:self.briefIntroductionView.frame.size.height];
    }
    [self.scrollView insertSubview:self.detailDescriptionView atIndex:0];
}

#pragma mark - Configure button status methods

- (void)configureParticipateButtonStatus:(BOOL)participated {
    self.participateButton.selected = !participated;
    if (participated) {
        [self.participateButton setTitle:NSLocalizedString(@"Participated", nil) forState:UIControlStateNormal];
    } else {
        [self.participateButton setTitle:NSLocalizedString(@"Participate", nil) forState:UIControlStateNormal];
    }
}

#pragma mark - UIScrollViewDelegate

#define BRIEF_DESCRIPTION_VIEW_BOTTOM_INDENT    50.0f

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.showingBriefIntroViewBottomButtons) {
        CGFloat briefDescriptionViewTopIndent = self.briefIntroductionView.frame.size.height - BRIEF_DESCRIPTION_VIEW_BOTTOM_INDENT;
        if (scrollView.contentOffset.y > briefDescriptionViewTopIndent) {
            [self.briefIntroductionView resetOriginY:scrollView.contentOffset.y - briefDescriptionViewTopIndent];
        } else {
            [self.briefIntroductionView resetOriginY:0];
        }
    }
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
    BOOL participated = self.participateButton.selected;
    [self configureParticipateButtonStatus:participated];
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set activitiy scheduled:%d succeeded", participated);
        sender.userInteractionEnabled = YES;
        self.activity.canSchedule = @(!self.activity.canSchedule.boolValue);
        
        if (participated) {
            [self.inviteButton fadeIn];
            [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:self.activity];
        }
        else {
            [self.inviteButton fadeOut];
            [[WTCoreDataManager sharedManager].currentUser removeScheduledEventsObject:self.activity];
        }
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set activitiy scheduled:%d, reason:%@", participated, error.localizedDescription);
        sender.userInteractionEnabled = YES;
        [self configureParticipateButtonStatus:!participated];
        
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

@end
