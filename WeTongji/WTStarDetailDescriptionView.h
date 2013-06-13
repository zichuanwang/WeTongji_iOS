//
//  WTStarDetailDescriptionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;
@class Star;

@interface WTStarDetailDescriptionView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentContainerView;
@property (nonatomic, weak) IBOutlet UILabel *briefIntroductionDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *briefIntroductionLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *contentLabel;

+ (WTStarDetailDescriptionView *)createDetailDescriptionViewWithStar:(Star *)star;

@end
