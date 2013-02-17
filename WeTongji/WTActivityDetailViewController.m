//
//  WTEventDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//
//未完成：
//  1）Label中字符串太长无法显示完全该如何处理？
//  2）about中的link是否要处理？
//  3）user的friendCount, participate等信息暂时无法获取
//  4）location indicator应该是水蓝色的

#import "WTActivityDetailViewController.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"
#import "WTBannerView.h"
#import "Activity+Addition.h"

@interface WTActivityDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *briefView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *aboutContainerView;
@property (nonatomic, weak) IBOutlet UILabel *activityTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *organizerLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityDescription;

@property (nonatomic, strong) UIButton *friendCountButton;
@property (nonatomic, strong) UIButton *participateButton;
@property (nonatomic, strong) WTBannerView *bannerView;

@property (nonatomic, strong) NSString *activityIdentifier;
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, assign) int friendCount;
@property (nonatomic, assign) BOOL participated;

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

- (id)initWithActivityIdentifier:(NSString *)activityIdentifier {
    self = [super init];
    if (self) {
        self.activityIdentifier = activityIdentifier;
        self.activity = [Activity activityWithID:activityIdentifier];
        
        //TODO
        self.friendCount = 3;
        self.participated = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    [self configureActivityBriefView];
    [self configureBanner];
    [self configureBottomView];
    
    self.scrollView.contentSize = CGSizeMake(320.0, 259.0+self.bottomView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    // back button
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:@"10:00" target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    // right buttons
    UIButton *commentButton = [[UIButton alloc] init];
    UIImage *commentImage = [UIImage imageNamed:@"WTCommentButton"];
    [commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
    [commentButton resetSize:commentImage.size];
    
    UIButton *moreButton = [[UIButton alloc] init];
    UIImage *moreImage = [UIImage imageNamed:@"WTMoreButton"];
    [moreButton resetSize:moreImage.size];
    [moreButton setBackgroundImage:moreImage forState:UIControlStateNormal];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    if (toolbar.subviews.count > 0)
        [(toolbar.subviews)[0] removeFromSuperview];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    UIBarButtonItem *barCommentButton = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    UIBarButtonItem *barMoreButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    WTLikeButtonView *likeButtonContainerView = [WTLikeButtonView createLikeButtonViewWithTarget:self action:@selector(didClickLikeButton:)];
    UIBarButtonItem *barLikeButton = [[UIBarButtonItem alloc] initWithCustomView:likeButtonContainerView];
    
    [buttons addObject:barCommentButton];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barMoreButton];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [buttons addObject:barLikeButton];
    
    [toolbar setItems:buttons animated:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)configureBanner {
    self.bannerView = [[[NSBundle mainBundle] loadNibNamed:@"WTBannerView" owner:self options:nil] lastObject];
    [self.bannerView resetOrigin:CGPointMake(0.0, 129.0)];
    [self.scrollView addSubview:self.bannerView];
}

- (void)configureActivityBriefView {
    self.activityTitleLabel.text = self.activity.title;
    self.activityTimeLabel.text = self.activity.begin;
    self.activityLocationLabel.text = self.activity.location;
    
    UIButton *inviteButton = [WTResourceFactory createFocusButtonWithText:@"Invite"];
    [inviteButton resetOrigin:CGPointMake(9.0, 83.0)];
    [inviteButton resetWidth:85.0];
    [inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.briefView addSubview:inviteButton];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    UIImage *resizableSelectImage = [[UIImage imageNamed:@"WTSelectButton"] resizableImageWithCapInsets:insets];
    
    self.friendCountButton = [WTResourceFactory createNormalButtonWithText:@"placeholder"];
    [self.friendCountButton resetWidth:85.0];
    [self.friendCountButton resetOrigin:CGPointMake(129.0, 83.0)];
    [self.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendCountButton setBackgroundImage:resizableSelectImage forState:UIControlStateSelected];
    [self.friendCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.friendCountButton setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.briefView addSubview:self.friendCountButton];
    
    self.participateButton = [WTResourceFactory createNormalButtonWithText:@"Participate"];
    [self.participateButton resetOrigin:CGPointMake(222.0, 83.0)];
    [self.participateButton resetWidth:85.0];
    [self.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.participateButton setBackgroundImage:resizableSelectImage forState:UIControlStateSelected];
    [self.participateButton setTitle:@"Participated" forState:UIControlStateSelected];
    [self.participateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.participateButton setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.briefView addSubview:self.participateButton];
    
    [self updateFriendCountUI];
    [self updateParticipatedUI];
}

- (void)configureBottomView {
    self.organizerLabel.text = self.activity.organizer;
    self.bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
    
    [self configureAboutView];
    
    [self.bottomView resetHeight:180.0+self.aboutContainerView.frame.size.height];
}

- (void)configureAboutView {
    self.activityDescription.text = self.activity.activityDescription;
    self.activityDescription.numberOfLines = 0;
    [self.activityDescription sizeToFit];
    
    float activityDescriptionLabelHeight = self.activityDescription.frame.size.height;
    
    UIImage *roundCornerPanel = [UIImage imageNamed:@"WTRoundCornerPanelBg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0);
    UIImage *resizableRoundCornerPanel = [roundCornerPanel resizableImageWithCapInsets:insets];
    UIImageView *aboutImageContainer = [[UIImageView alloc] initWithImage:resizableRoundCornerPanel];
    [aboutImageContainer resetSize:CGSizeMake(292.0, 80.0+activityDescriptionLabelHeight)];
    [aboutImageContainer resetOrigin:CGPointZero];
    
    [self.aboutContainerView addSubview:aboutImageContainer];
    [self.aboutContainerView resetHeight:aboutImageContainer.frame.size.height];
    self.aboutContainerView.backgroundColor = [UIColor clearColor];

    [self.aboutContainerView sendSubviewToBack:aboutImageContainer];
}

- (void)updateFriendCountUI {
    [self.friendCountButton setTitle:[NSString stringWithFormat:@"%d Friends", self.friendCount] forState:UIControlStateNormal];
}

- (void)updateParticipatedUI {
    if (self.participated) {
        self.participateButton.selected = YES;
    } else {
        self.participateButton.selected = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)didClickInviteButton:(UIButton *)sender {
    NSLog(@"Invite button clicked");
}

- (void)didClickFriendCountButton:(UIButton *)sender {
    NSLog(@"Friend count button clicked");
}

- (void)didClickParticipateButton:(UIButton *)sender {
    self.participated = !self.participated;
    [self updateParticipatedUI];
    // TODO
    // Communicate with server
}

- (void)didClickOrganizerIndicator {
    NSLog(@"Organizer Indicator button clicked");
}

- (void)didClickLocationIndicator {
    NSLog(@"Location Indicator button clicked");
}

@end
