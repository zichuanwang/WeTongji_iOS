//
//  WTNewsBriefIntroductionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsBriefIntroductionView.h"
#import "News.h"

@interface WTNewsBriefIntroductionView ()

@property (nonatomic, weak) News *news;

@end

@implementation WTNewsBriefIntroductionView

+ (WTNewsBriefIntroductionView *)createNewsBriefIntroductionViewWithNews:(News *)news {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTNewsBriefIntroductionView" owner:nil options:nil];
    WTNewsBriefIntroductionView *result = views.lastObject;
    result.news = news;
    [result configureView];
    return result;
}

- (void)configureView {
    self.titleLabel.text = self.news.title;
    self.publisherLabel.text = self.news.source;
    self.publishTimeLabel.text = self.news.publishDay;
}

@end

@implementation WTOfficialNewsBriefIntroductionView

@end
