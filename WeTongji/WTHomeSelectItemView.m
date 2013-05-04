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
#import "UIImageView+AsyncLoading.h"
#import "NSString+WTAddition.h"
#import "Event+Addition.h"
#import "Activity+Addition.h"
#import "News+Addition.h"

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
        self.subCategoryLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
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
    
    self.subCategoryLabel.text = news.categoryString;
}

- (void)configureBgImageView:(NSString *)imageURL {
    self.bgImageContainerView.layer.masksToBounds = YES;
    self.bgImageContainerView.layer.cornerRadius = 8.0f;
    
    [self.bgImageView loadImageWithImageURLString:imageURL];
}

@end

@implementation WTHomeSelectNewsWithTicketView

+ (WTHomeSelectNewsWithTicketView *)createHomeSelectNewsWithTicketView:(News *)news {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil];
    WTHomeSelectNewsWithTicketView *result = nil;
    for(UIView *view in viewArray) {
        if ([view isKindOfClass:[WTHomeSelectNewsWithTicketView class]])
            result = (WTHomeSelectNewsWithTicketView *)view;
    }
    
    [result configureViewWithNews:news];
    
    return result;
}

- (void)configureViewWithNews:(News *)news {
    // Poster image
    NSArray *newsImageArray = news.imageArray;
    if (newsImageArray.count != 0) {
        [self.posterImageView loadImageWithImageURLString:newsImageArray[0]];
    }
    
    // Info
    if (news.hasTicket.boolValue) {
        self.newsTitleLabel.text = [NSString stringWithFormat:@"     %@", news.title];
    } else {
        self.newsTitleLabel.text = news.title;
        self.ticketIconImageView.hidden = YES;
    }
    
    self.timeLabel.text = news.publishDay;
    
    self.subCategoryLabel.text = news.categoryString;
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
    self.subCategoryLabel.text = activity.activityTypeString;
    [self configurePosterImageView:activity.image];
}

- (void)configurePosterImageView:(NSString *)imageURL {
    [self.posterImageView loadImageWithImageURLString:imageURL];
}

@end
