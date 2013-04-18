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
    [self configureLikeButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;

    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.contentLabelContainerView.frame.origin.y + self.contentLabelContainerView.frame.size.height);
}
- (void)configureBriefIntroductionView {
    self.briefIntroductionView = [WTNewsBriefIntroductionView createNewsBriefIntroductionViewWithNews:self.news];
    [self.scrollView addSubview:self.briefIntroductionView];
    [self.view sendSubviewToBack:self.briefIntroductionView];
}

#define CONTENT_LABEL_LINE_SPACING  8.0f

- (void)configureContentLabel {
    [self.contentLabelContainerView resetOriginY:self.briefIntroductionView.frame.size.height];
    
    self.contentLabelContainerView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f].CGColor;
    self.contentLabelContainerView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.contentLabelContainerView.layer.shadowOpacity = 0.25f;
    self.contentLabelContainerView.layer.shadowRadius = 0;
    
    NSMutableAttributedString *contentAttributedString = [NSMutableAttributedString attributedStringWithString:self.news.content];
    
    [contentAttributedString setAttributes:[self.contentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
    
    [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    self.contentLabel.attributedText = contentAttributedString;
    
    CGFloat contentLabelHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 200000.0f)].height;
    
    [self.contentLabel resetHeight:contentLabelHeight];
    
    [self.contentLabelContainerView resetHeight:contentLabelHeight + self.contentLabel.frame.origin.y * 2];
    
    self.contentLabel.automaticallyAddLinksForType = 0;
}

- (void)configureLikeButton {
    self.likeButtonContainerView.likeButton.selected = !self.news.canLike.boolValue;
    [self.likeButtonContainerView setLikeCount:self.news.likeCount.integerValue];
}

#pragma mark - Actions

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set news liked:%d succeeded", sender.selected);
        self.news.likeCount = @(self.news.likeCount.integerValue + (sender.selected ? 1 : (-1)));
        [self.likeButtonContainerView setLikeCount:self.news.likeCount.integerValue];
        self.news.canLike = @(!sender.selected);
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set news liked:%d, reason:%@", sender.selected, error.localizedDescription);
        sender.selected = !sender.selected;
        
        [WTErrorHandler handleError:error];
    }];
    [request setNewsLiked:sender.selected newsID:self.news.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
