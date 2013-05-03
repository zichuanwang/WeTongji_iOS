//
//  WTNewsBriefIntroductionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsBriefIntroductionView.h"
#import "News+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>
#import "WTResourceFactory.h"

@interface WTNewsBriefIntroductionView ()

@property (nonatomic, weak) News *news;

@end

@implementation WTNewsBriefIntroductionView

+ (WTNewsBriefIntroductionView *)createNewsBriefIntroductionViewWithNews:(News *)news {
    
    WTNewsBriefIntroductionView *result = nil;
    
    switch (news.category.integerValue) {
        case NewsShowTypeCampusUpdate:
        case NewsShowTypeAdministrativeAffairs:
            result = [WTOfficialNewsBriefIntroductionView createOfficialNewsBriefIntroductionView];
            break;
        case NewsShowTypeClubNews:
            result = [WTClubNewsBriefIntroductionView createClubNewsBriefIntroductionView];
            break;
        case NewsShowTypeLocalRecommandation:
            result = [WTRecommendationNewsBriefIntroductionView createRecommendationNewsBriefIntroductionView];
            break;
        default:
            break;
    }
    result.news = news;
    [result configureView];
    return result;
}

- (void)configureView {
    
}

@end

@implementation WTOfficialNewsBriefIntroductionView

+ (WTOfficialNewsBriefIntroductionView *)createOfficialNewsBriefIntroductionView {
    WTOfficialNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTOfficialNewsBriefIntroductionView class]]) {
            result = (WTOfficialNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.source;
    self.publishTimeLabel.text = self.news.publishDay;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

@end

@implementation WTRecommendationNewsBriefIntroductionView

+ (WTRecommendationNewsBriefIntroductionView *)createRecommendationNewsBriefIntroductionView {
    WTRecommendationNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTRecommendationNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTRecommendationNewsBriefIntroductionView class]]) {
            result = (WTRecommendationNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    [self configureOtherInfoView];
    
    // 如果有票
    if (self.news) {
        [self configureTicketInfoView];
    } else {
        self.ticketInfoContainerView.hidden = YES;
        [self.otherInfoContainerView resetOriginY:0];
        [self resetHeight:self.otherInfoContainerView.frame.size.height];
    }
}

- (void)configureTicketInfoView {
    self.ticketInfoLabel.text = @"";
}

- (void)configureBookTicketButton {
    // 如果有电话
    if (self.news) {
        UIButton *bookTicketButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Book a ticket", nil)];
        [bookTicketButton resetOriginX:10.0f];
        [bookTicketButton resetCenterY:self.locationButton.center.y];
        bookTicketButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.otherInfoContainerView addSubview:bookTicketButton];
    }
}

- (void)configureOtherInfoView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.source;
    self.publishTimeLabel.text = self.news.publishDay;
    
    [self configurePosterImageView];
    [self configureBookTicketButton];
    
    // 如果无票
    if (self.news) {
        self.ticketIconImageView.hidden = YES;
        [self.titleLabel resetOriginX:self.ticketIconImageView.frame.origin.x];
        [self.titleLabel resetWidth:self.publishTimeLabel.frame.size.width];
    }
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
}

- (void)configurePosterImageView {
    NSArray *imageArray = self.news.imageArray;
    if (imageArray.count > 0)
        [self.posterImageView loadImageWithImageURLString:imageArray[0]];
}

@end

@implementation WTClubNewsBriefIntroductionView

+ (WTClubNewsBriefIntroductionView *)createClubNewsBriefIntroductionView {
    WTClubNewsBriefIntroductionView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTClubNewsBriefIntroductionView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTClubNewsBriefIntroductionView class]]) {
            result = (WTClubNewsBriefIntroductionView *)view;
            break;
        }
    }
    return result;
}

- (void)configureView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.organizer;
    self.publishTimeLabel.text = self.news.publishDay;
    
    CGFloat titleLabelOriginalHeight = self.titleLabel.frame.size.height;
    [self.titleLabel sizeToFit];
    [self resetHeight:self.frame.size.height + self.titleLabel.frame.size.height - titleLabelOriginalHeight];
    
    [self.avatarImageView loadImageWithImageURLString:self.news.organizerAvatar];
}

- (void)awakeFromNib {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
}

@end