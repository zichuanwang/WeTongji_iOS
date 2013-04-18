//
//  WTHomeSelectItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WTHomeSelectItemView.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+WTAddition.h"
#import "Event+Addition.h"
#import "Activity+Addition.h"

typedef enum {
    WTHomeSelectItemStyleNormal,
    WTHomeSelectItemStyleWithImage,
} WTHomeSelectItemStyle;

@interface WTHomeSelectItemView()

@property (nonatomic, strong) UIButton *showAllButton;
@property (nonatomic, strong) WTLikeButtonView *likeButtonView;
@property (nonatomic, assign) WTHomeSelectItemStyle itemStyle;

@end

@implementation WTHomeSelectItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didMoveToSuperview {    
    if ([self isMemberOfClass:[WTHomeSelectStarView class]]) {
        [self createLikeButtonView];
        [self addSubview:self.likeButtonView];
    } else { // WTHomeSelectNewsView, WTHomeSelectActivityView
        [self createShowAllButton];
        [self addSubview:self.showAllButton];
    }
}

#pragma mark - Actions

- (void)didClickShowAllButon:(UIButton *)sender {
    
}

- (void)didClickLikeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - Properties

- (void)createShowAllButton {
    UIButton *showAllButton = nil;
    switch (self.itemStyle) {
        case WTHomeSelectItemStyleNormal: {
            showAllButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Show Category", nil)];
        }
            break;
         
        case WTHomeSelectItemStyleWithImage: {
            showAllButton = [WTResourceFactory createTranslucentButtonWithText:NSLocalizedString(@"Show Category", nil)];
        }
            break;
        default:
            break;
    }
    
    [showAllButton resetOrigin:CGPointMake(self.frame.size.width - showAllButton.frame.size.width - 8, -3)];
    [showAllButton addTarget:self action:@selector(didClickShowAllButon:) forControlEvents:UIControlEventTouchUpInside];
    self.showAllButton = showAllButton;
}

- (void)createLikeButtonView {
    WTLikeButtonView *likeButtonView = [WTLikeButtonView createLikeButtonViewWithTarget:self action:@selector(didClickLikeButton:)];
    [likeButtonView resetOrigin:CGPointMake(242.0f, -1.0f)];
    self.likeButtonView = likeButtonView;
}

@end

@implementation WTHomeSelectNewsView

+ (WTHomeSelectNewsView *)createHomeSelectNewsView:(News *)news {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectNewsView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectNewsView class]])
            result = (WTHomeSelectNewsView *)view;
    }
    
    [result configureViewWithNews:news];
    
    return result;
}

- (void)configureViewWithNews:(News *)news {
    // Bg image
    NSArray *newsImageArray = news.imageArray;
    self.itemStyle = (newsImageArray.count == 0) ? WTHomeSelectItemStyleNormal : WTHomeSelectItemStyleWithImage;
    if (self.itemStyle == WTHomeSelectItemStyleWithImage) {
        self.bgImageContainerView.hidden = NO;
        self.subCategoryLabel.shadowColor = [UIColor blackColor];
        self.newsTitleLabel.textColor = [UIColor whiteColor];
        self.newsTitleLabel.shadowColor = [UIColor blackColor];
        [self configureBgImageView:newsImageArray[0]];
    } else {
        self.bgImageContainerView.hidden = YES;
        self.subCategoryLabel.shadowColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6f];
        self.newsTitleLabel.textColor = [UIColor colorWithRed:55 / 255.0f green:55 / 255.0f blue:55 / 255.0f alpha:1.0f];
        self.newsTitleLabel.shadowColor = [UIColor clearColor];
    }
    
    // Info
    self.newsTitleLabel.text = news.title;
}

- (void)configureBgImageView:(NSString *)imageURL {
    self.bgImageContainerView.layer.masksToBounds = YES;
    self.bgImageContainerView.layer.cornerRadius = 9.0f;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [self.bgImageView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         self.bgImageView.image = image;
                                         [self.bgImageView fadeIn];
                                     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         
                                     }];
}

@end

@implementation WTHomeSelectStarView

+ (WTHomeSelectStarView *)createHomeSelectStarView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectStarView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectStarView class]])
            result = (WTHomeSelectStarView *)view;
    }
    [result configureAvatarImageView];
    return result;
}

- (void)configureAvatarImageView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end

@implementation WTHomeSelectActivityView

+ (WTHomeSelectActivityView *)createHomeSelectActivityView:(Activity *)activity {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectActivityView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectActivityView class]])
            result = (WTHomeSelectActivityView *)view;
    }
    
    [result configureViewWithActivity:activity];
    
    return result;
}

- (void)configureViewWithActivity:(Activity *)activity {
    self.titleLabel.text = activity.what;
    self.timeLabel.text = activity.yearMonthDayBeginToEndTimeString;
    self.typeLabel.text = activity.activityTypeString;
    [self configurePosterImageView:activity.image];
}

- (void)configurePosterImageView:(NSString *)imageURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [self.posterImageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             self.posterImageView.image = image;
                                             [self.posterImageView fadeIn];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             
                                         }];
}

@end
