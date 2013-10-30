//
//  WTRouteDetailView.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRouteDetailView : UIView

@property (nonatomic, weak) IBOutlet UIView *sectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *frequentTargetLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstTimeIntervalLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondTimeIntervalLabel;
@property (nonatomic, weak) IBOutlet UILabel *whereLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailInformationDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *frequentTargetDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstTimeIntervalDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondTimeIntervalDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *whereDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *costDisplayLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *firstInfoPanelDivier;
@property (nonatomic, weak) IBOutlet UIImageView *secondInfoPanelDivier;
@property (nonatomic, weak) IBOutlet UIImageView *thirdInfoPanelDivier;
@property (nonatomic, weak) IBOutlet UIImageView *fourthInfoPanelDivier;

+ (WTRouteDetailView *)createRouteDetailViewWithRouteInfo:(NSDictionary *)routeInfo;

@end
