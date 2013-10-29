//
//  WTRouteCell.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-22.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHighlightableCell.h"

@interface WTRouteCell : WTHighlightableCell

@property (weak, nonatomic) IBOutlet UILabel *trafficTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequentTargetLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                      TrafficTitle:(NSString *)trafficTitle
                    FrequentTarget:(NSString *)frequentTarget;

@end
