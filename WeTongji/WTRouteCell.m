//
//  WTRouteCell.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-22.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRouteCell.h"

@implementation WTRouteCell

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

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.trafficTitleLabel.highlighted = highlighted;
    self.frequentTargetLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.trafficTitleLabel.shadowOffset = labelShadowOffset;
    self.frequentTargetLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                      TrafficTitle:(NSString *)trafficTitle
                    FrequentTarget:(NSString *)frequentTarget {
    [super configureCellWithIndexPath:indexPath];
    
    self.trafficTitleLabel.text = trafficTitle;
    self.frequentTargetLabel.text = frequentTarget;
}

@end
