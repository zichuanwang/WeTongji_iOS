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
#import "WTNewsBriefIntroductionView.h"
#import "OHAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface WTNewsDetailViewController ()

@property (nonatomic, strong) WTNewsBriefIntroductionView *briefIntroductionView;
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
    [self configureBriefIntroductionView];
    [self configureContentLabel];
    [self configureScrollView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    // TODO:
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 0);
}
- (void)configureBriefIntroductionView {
    self.briefIntroductionView = [WTNewsBriefIntroductionView createNewsBriefIntroductionViewWithNews:self.news];
    [self.scrollView addSubview:self.briefIntroductionView];
    [self.view sendSubviewToBack:self.briefIntroductionView];
}

- (void)configureContentLabel {
    [self.contentLabelContainerView resetOriginY:self.briefIntroductionView.frame.size.height];
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
