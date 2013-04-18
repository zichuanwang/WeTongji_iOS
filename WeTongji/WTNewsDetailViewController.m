//
//  WTNewsDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsDetailViewController.h"
#import "News.h"
#import "WTLikeButtonView.h"

@interface WTNewsDetailViewController ()

@property (nonatomic, strong) News *news;

@end

@implementation WTNewsDetailViewController

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
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTNewsDetailViewController *)createNewsDetailViewControllerWithNews:(News *)news
                                                     backBarButtonText:(NSString *)backBarButtonText {
    WTNewsDetailViewController *result = [[WTNewsDetailViewController alloc] init];
    result.news = news;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureScrollView];
    [self configureBriefIntroductionView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    // TODO:
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 0);
}

- (void)configureBriefIntroductionViewBackgroundColor {
    self.briefIntroductionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTGrayPanel"]];
}

- (void)configurePublisherButton {
    
}

- (void)configureNewsPublishTimeLabel {
    
}

- (void)configureNewsTitleLabelAndCalculateBriefIntroductionViewHeight {
    
}

- (void)configureBriefIntroductionView {
    [self configureBriefIntroductionViewBackgroundColor];
    [self configurePublisherButton];
    [self configureNewsPublishTimeLabel];
    [self configureNewsTitleLabelAndCalculateBriefIntroductionViewHeight];
}

#pragma mark - Actions

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set activitiy liked:%d succeeded", sender.selected);
        self.news.likeCount = @(self.news.likeCount.integerValue + (sender.selected ? 1 : (-1)));
        [self.likeButtonContainerView setLikeCount:self.news.likeCount.integerValue];
        self.news.canLike = @(!sender.selected);
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set activitiy liked:%d, reason:%@", sender.selected, error.localizedDescription);
        sender.selected = !sender.selected;
        
        [WTErrorHandler handleError:error];
    }];
    //[request setActivitiyLiked:sender.selected activityID:self.activity.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
