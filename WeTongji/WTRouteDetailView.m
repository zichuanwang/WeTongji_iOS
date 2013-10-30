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
    [self configureItemPosition];
}

- (void)configureSectionLabels {
    // Configure Display Label
    self.frequentTargetDisplayLabel.text = NSLocalizedString(@"Frequented Locations", nil);
    self.firstTimeIntervalDisplayLabel.text = NSLocalizedString(@"Starts", nil);
    self.secondTimeIntervalDisplayLabel.text = NSLocalizedString(@"Ends", nil);
    self.whereDisplayLabel.text = NSLocalizedString(@"Boarding Location", nil);
    self.costDisplayLabel.text = NSLocalizedString(@"Ticket Price", nil);
    
    // Configure Label - Auto Resize
    [self configureLabel:self.frequentTargetLabel Key:@"frequent_target"];
    [self configureLabel:self.firstTimeIntervalLabel Key:@"time_interval_1"];
    [self configureLabel:self.secondTimeIntervalLabel Key:@"time_interval_2"];
    [self configureLabel:self.whereLabel Key:@"where"];
    [self configureLabel:self.costLabel Key:@"cost"];
}

- (void)configureLabel:(UILabel *)label Key:(NSString *)key {
    CGSize size= CGSizeMake(152,2000);
    CGRect frame = label.frame;
    UIFont *font = label.font;
    NSString *text = [self.routeInfo objectForKey:key];
    label.text = text;
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    frame.size = labelSize;
    [label setFrame:frame];
}

- (void)configureSectionView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.sectionBgImageView.image = bgImage;
    
    self.detailInformationDisplayLabel.text = NSLocalizedString(@"Detail Information", nil);
}

- (void)configureItemPosition {
    // First Info Panel Divier
    [self configureInfoPanelDivier:self.firstInfoPanelDivier
                       AccordingTo:self.frequentTargetLabel];
    
    // Starts
    [self configureDisplayLabel:self.firstTimeIntervalDisplayLabel
                          Label:self.firstTimeIntervalLabel
                    AccordingTo:self.firstInfoPanelDivier];
    
    // Second Info Panel Divier
    [self configureInfoPanelDivier:self.secondInfoPanelDivier
                       AccordingTo:self.firstTimeIntervalLabel];
    
    // Ends
    [self configureDisplayLabel:self.secondTimeIntervalDisplayLabel
                          Label:self.secondTimeIntervalLabel
                    AccordingTo:self.secondInfoPanelDivier];
    
    // Third Info Panel Divier
    [self configureInfoPanelDivier:self.thirdInfoPanelDivier
                       AccordingTo:self.secondTimeIntervalLabel];
    
    // Boarding Location
    [self configureDisplayLabel:self.whereDisplayLabel
                          Label:self.whereLabel
                    AccordingTo:self.thirdInfoPanelDivier];
    
    // Fourth Info Panel Divier
    [self configureInfoPanelDivier:self.fourthInfoPanelDivier
                       AccordingTo:self.whereLabel];
    
    // Ticket Price
    [self configureDisplayLabel:self.costDisplayLabel
                          Label:self.costLabel
                    AccordingTo:self.fourthInfoPanelDivier];
    
    CGRect frame;

    // Bg
    frame = self.sectionContianerView.frame;
    frame.size.height = self.costLabel.frame.origin.y + self.costLabel.frame.size.height + 12;
    [self.sectionContianerView setFrame:frame];
    
    frame = self.sectionBgImageView.frame;
    frame.size.height = self.costLabel.frame.origin.y + self.costLabel.frame.size.height + 13;
    [self.sectionBgImageView setFrame:frame];
    
    // Self
    frame = self.frame;
    frame.size.height = self.sectionContianerView.frame.origin.y + self.sectionContianerView.frame.size.height + 20;
    [self setFrame:frame];
}

- (void)configureInfoPanelDivier:(UIImageView *)infoPanelDivier
                     AccordingTo:(UILabel *)label {
    CGRect frame = infoPanelDivier.frame;
    CGPoint origin = frame.origin;
    origin.y = label.frame.origin.y + label.frame.size.height + 11;
    frame.origin = origin;
    [infoPanelDivier setFrame:frame];
}

- (void)configureDisplayLabel:(UILabel *)displayLabel
                        Label:(UILabel *)label
                  AccordingTo:(UIImageView *)infoPanelDivier {
    CGRect frame = displayLabel.frame;
    CGPoint origin = frame.origin;
    origin.y = infoPanelDivier.frame.origin.y + 13;
    frame.origin = origin;
    [displayLabel setFrame:frame];
    
    frame = label.frame;
    frame.origin.y = origin.y;
    [label setFrame:frame];
}

@end
