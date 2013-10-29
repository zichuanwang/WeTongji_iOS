//
//  WTRouteDetailView.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRouteDetailView.h"

@interface WTRouteDetailView ()

@property (nonatomic, weak) NSDictionary *routeInfo;

@end

@implementation WTRouteDetailView

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

#pragma mark - Factory methods

+ (WTRouteDetailView *)createRouteDetailViewWithRouteInfo:(NSDictionary *)routeInfo {
    WTRouteDetailView *result = [[NSBundle mainBundle] loadNibNamed:@"WTRouteDetailView" owner:nil options:nil].lastObject;
    result.routeInfo = routeInfo;
    [result configureView];
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    [self configureSectionView];
    [self configureSectionLabels];
}

- (void)configureSectionLabels {
    self.frequentTargetDisplayLabel.text = NSLocalizedString(@"Frequented Locations", nil);
    self.firstTimeIntervalDisplayLabel.text = NSLocalizedString(@"time_interval_1", nil);
    self.secondTimeIntervalDisplayLabel.text = NSLocalizedString(@"time_interval_2", nil);
    self.whereDisplayLabel.text = NSLocalizedString(@"where", nil);
    self.costDisplayLabel.text = NSLocalizedString(@"cost", nil);
    
    self.frequentTargetLabel.text = [self.routeInfo objectForKey:@"frequent_target"];
    self.firstTimeIntervalLabel.text = [self.routeInfo objectForKey:@"time_interval_1"];
    self.secondTimeIntervalLabel.text = [self.routeInfo objectForKey:@"time_interval_2"];
    self.whereLabel.text = [self.routeInfo objectForKey:@"where"];
    self.costLabel.text = [self.routeInfo objectForKey:@"cost"];
}

- (void)configureSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.sectionBgImageView.image = bgImage;
    
    self.detailInformationDisplayLabel.text = NSLocalizedString(@"Detail Information", nil);
}

@end
