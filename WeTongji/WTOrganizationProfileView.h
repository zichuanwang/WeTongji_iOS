//
//  WTOrganizationProfileView.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "OHAttributedLabel.h"

@interface WTOrganizationProfileView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentContainerView;
@property (nonatomic, weak) IBOutlet UILabel *aboutDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *contentLabel;

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org;

@end
