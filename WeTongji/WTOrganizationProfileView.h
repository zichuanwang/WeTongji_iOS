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

@property (nonatomic, weak) IBOutlet UIImageView *profileSectionBgImageView;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *activityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *newsLabel;
@property (nonatomic, weak) IBOutlet UIButton *activityButton;
@property (nonatomic, weak) IBOutlet UIButton *newsButton;

+ (WTOrganizationProfileView *)createProfileViewWithOrganization:(Organization *)org;

@end
